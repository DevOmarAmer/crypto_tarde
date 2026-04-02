import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/coin_entity.dart';
import '../../domain/usecases/get_market_coins_usecase.dart';

abstract class MarketState extends Equatable {
  const MarketState();

  @override
  List<Object?> get props => [];
}

class MarketInitial extends MarketState {}

class MarketLoading extends MarketState {}

class MarketLoaded extends MarketState {
  final List<CoinEntity> coins;
  final List<CoinEntity> filteredCoins; // Use for search/filters
  
  const MarketLoaded({required this.coins, required this.filteredCoins});

  @override
  List<Object?> get props => [coins, filteredCoins];

  MarketLoaded copyWith({
    List<CoinEntity>? coins,
    List<CoinEntity>? filteredCoins,
  }) {
    return MarketLoaded(
      coins: coins ?? this.coins,
      filteredCoins: filteredCoins ?? this.filteredCoins,
    );
  }
}

class MarketError extends MarketState {
  final String message;

  const MarketError(this.message);

  @override
  List<Object?> get props => [message];
}

class MarketCubit extends Cubit<MarketState> {
  final GetMarketCoinsUseCase getMarketCoinsUseCase;

  MarketCubit({required this.getMarketCoinsUseCase}) : super(MarketInitial());

  Future<void> fetchMarketCoins() async {
    try {
      emit(MarketLoading());
      final coins = await getMarketCoinsUseCase();
      emit(MarketLoaded(coins: coins, filteredCoins: coins));
    } catch (e) {
      emit(MarketError(e.toString()));
    }
  }

  void searchCoins(String query) {
    if (state is MarketLoaded) {
      final currentState = state as MarketLoaded;
      if (query.isEmpty) {
        emit(currentState.copyWith(filteredCoins: currentState.coins));
        return;
      }

      final lowerQuery = query.toLowerCase();
      final filtered = currentState.coins.where((coin) {
        return coin.name.toLowerCase().contains(lowerQuery) ||
            coin.symbol.toLowerCase().contains(lowerQuery);
      }).toList();

      emit(currentState.copyWith(filteredCoins: filtered));
    }
  }
}
