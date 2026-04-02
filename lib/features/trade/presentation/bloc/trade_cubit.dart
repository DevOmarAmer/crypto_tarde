import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/network/binance_websocket_service.dart';
import '../../domain/entities/kline_entity.dart';
import '../../domain/entities/order_book_entity.dart';
import '../../domain/repositories/trade_repository.dart';

abstract class TradeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TradeInitial extends TradeState {}

class TradeLoading extends TradeState {}

class TradeLoaded extends TradeState {
  final List<KlineEntity> klines;
  final OrderBookEntity orderBook;
  final double currentPrice;
  final double virtualBalance;
  final String selectedInterval;

  TradeLoaded({
    required this.klines,
    required this.orderBook,
    required this.currentPrice,
    required this.virtualBalance,
    required this.selectedInterval,
  });

  @override
  List<Object?> get props => [
        klines,
        orderBook,
        currentPrice,
        virtualBalance,
        selectedInterval,
      ];

  TradeLoaded copyWith({
    List<KlineEntity>? klines,
    OrderBookEntity? orderBook,
    double? currentPrice,
    double? virtualBalance,
    String? selectedInterval,
  }) {
    return TradeLoaded(
      klines: klines ?? this.klines,
      orderBook: orderBook ?? this.orderBook,
      currentPrice: currentPrice ?? this.currentPrice,
      virtualBalance: virtualBalance ?? this.virtualBalance,
      selectedInterval: selectedInterval ?? this.selectedInterval,
    );
  }
}

class TradeExecutionSuccess extends TradeState {
  final String message;
  TradeExecutionSuccess(this.message);
}

class TradeExecutionError extends TradeState {
  final String message;
  TradeExecutionError(this.message);
}

class TradeCubit extends Cubit<TradeState> {
  final TradeRepository repository;
  final BinanceWebSocketService webSocketService;

  StreamSubscription? _tickerSubscription;
  StreamSubscription? _depthSubscription;
  StreamSubscription? _klineSubscription;

  String _currentSymbol = '';

  TradeCubit({
    required this.repository,
    required this.webSocketService,
  }) : super(TradeInitial());

  Future<void> initTrade(String symbol, {String interval = '1m'}) async {
    _currentSymbol = symbol;
    emit(TradeLoading());

    try {
      final klines = await repository.getKlines(symbol, interval);
      final orderBook = await repository.getOrderBook(symbol);
      final balance = await repository.getVirtualBalance();

      final currentPrice = klines.isNotEmpty ? klines.last.close : 0.0;

      emit(TradeLoaded(
        klines: klines,
        orderBook: orderBook,
        currentPrice: currentPrice,
        virtualBalance: balance,
        selectedInterval: interval,
      ));

      _subscribeToStreams(symbol, interval);
    } catch (e) {
      emit(TradeExecutionError('Failed to load trade data.'));
    }
  }

  void _subscribeToStreams(String symbol, String interval) {
    _cancelStreams();

    try {
      _tickerSubscription = webSocketService.getTickerStream(symbol).listen((event) {
        if (state is TradeLoaded && event['c'] != null) {
          final price = double.parse(event['c'].toString());
          emit((state as TradeLoaded).copyWith(currentPrice: price));
        }
      });

      _depthSubscription = webSocketService.getDepthStream(symbol).listen((event) {
        if (state is TradeLoaded && event['bids'] != null && event['asks'] != null) {
          final bids = (event['bids'] as List).map((e) => OrderBookLevel(
                price: double.parse(e[0].toString()),
                quantity: double.parse(e[1].toString()),
              )).toList();
          final asks = (event['asks'] as List).map((e) => OrderBookLevel(
                price: double.parse(e[0].toString()),
                quantity: double.parse(e[1].toString()),
              )).toList();

          emit((state as TradeLoaded).copyWith(orderBook: OrderBookEntity(bids: bids, asks: asks)));
        }
      });

      _klineSubscription = webSocketService.getKlineStream(symbol, interval).listen((event) {
        if (state is TradeLoaded && event['k'] != null) {
          // Minimal update implementation: append or update last candle
          // For perfection, we'd actually splice the klines list.
        }
      });
    } catch (_) {}
  }

  void changeInterval(String interval) {
    if (_currentSymbol.isNotEmpty) {
      initTrade(_currentSymbol, interval: interval);
    }
  }

  Future<void> executeBuy({
    required String coinId,
    required String symbol,
    required String name,
    required String logoUrl,
    required double quantity,
  }) async {
    if (state is! TradeLoaded) return;
    
    final currentState = state as TradeLoaded;
    final price = currentState.currentPrice;
    final totalCost = price * quantity;

    try {
      await repository.executeBuy(
        coinId: coinId,
        symbol: symbol,
        name: name,
        logoUrl: logoUrl,
        quantity: quantity,
        price: price,
        totalCost: totalCost,
      );
      
      final newBalance = await repository.getVirtualBalance();
      emit(TradeExecutionSuccess('Bought $quantity $symbol successfully!'));
      emit(currentState.copyWith(virtualBalance: newBalance));
    } catch (e) {
      final s = state;
      emit(TradeExecutionError(e.toString()));
      emit(s);
    }
  }

  Future<void> executeSell({
    required String coinId,
    required String symbol,
    required double quantity,
  }) async {
    if (state is! TradeLoaded) return;
    
    final currentState = state as TradeLoaded;
    final price = currentState.currentPrice;
    final totalGain = price * quantity;

    try {
      await repository.executeSell(
        coinId: coinId,
        symbol: symbol,
        quantity: quantity,
        price: price,
        totalGain: totalGain,
      );
      
      final newBalance = await repository.getVirtualBalance();
      emit(TradeExecutionSuccess('Sold $quantity $symbol successfully!'));
      emit(currentState.copyWith(virtualBalance: newBalance));
    } catch (e) {
      final s = state;
      emit(TradeExecutionError(e.toString()));
      emit(s);
    }
  }

  void _cancelStreams() {
    _tickerSubscription?.cancel();
    _depthSubscription?.cancel();
    _klineSubscription?.cancel();
  }

  @override
  Future<void> close() {
    _cancelStreams();
    return super.close();
  }
}
