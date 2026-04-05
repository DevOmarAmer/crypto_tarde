import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/coin_entity.dart';
import '../../domain/usecases/get_market_coins_usecase.dart';

// ---------------------------------------------------------------------------
// States
// ---------------------------------------------------------------------------

abstract class MarketState extends Equatable {
  const MarketState();

  @override
  List<Object?> get props => [];
}

/// Shown only on the very first load (no data yet).
class MarketInitial extends MarketState {}

/// Full-screen skeleton shown on first fetch.
class MarketLoading extends MarketState {}

/// Data available. Optionally a "load more" request is in-flight.
class MarketLoaded extends MarketState {
  final List<CoinEntity> coins;
  final List<CoinEntity> filteredCoins;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final String searchQuery;

  const MarketLoaded({
    required this.coins,
    required this.filteredCoins,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [
        coins,
        filteredCoins,
        isLoadingMore,
        hasMore,
        currentPage,
        searchQuery,
      ];

  MarketLoaded copyWith({
    List<CoinEntity>? coins,
    List<CoinEntity>? filteredCoins,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    String? searchQuery,
  }) {
    return MarketLoaded(
      coins: coins ?? this.coins,
      filteredCoins: filteredCoins ?? this.filteredCoins,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class MarketError extends MarketState {
  final String message;

  const MarketError(this.message);

  @override
  List<Object?> get props => [message];
}

// ---------------------------------------------------------------------------
// Cubit
// ---------------------------------------------------------------------------

const int _kPerPage = 20;

class MarketCubit extends Cubit<MarketState> {
  final GetMarketCoinsUseCase getMarketCoinsUseCase;

  MarketCubit({required this.getMarketCoinsUseCase}) : super(MarketInitial());

  /// Initial / refresh fetch – always resets to page 1.
  Future<void> fetchMarketCoins() async {
    try {
      emit(MarketLoading());
      final coins = await getMarketCoinsUseCase(page: 1, perPage: _kPerPage);
      emit(MarketLoaded(
        coins: coins,
        filteredCoins: coins,
        hasMore: coins.length >= _kPerPage,
        currentPage: 1,
      ));
    } catch (e) {
      emit(MarketError(e.toString()));
    }
  }

  /// Appends the next page to the existing list.
  Future<void> loadMoreCoins() async {
    if (state is! MarketLoaded) return;
    final current = state as MarketLoaded;
    if (current.isLoadingMore || !current.hasMore) return;
    // Don't paginate while the user is searching.
    if (current.searchQuery.isNotEmpty) return;

    emit(current.copyWith(isLoadingMore: true));

    try {
      final nextPage = current.currentPage + 1;
      final newCoins = await getMarketCoinsUseCase(
        page: nextPage,
        perPage: _kPerPage,
      );
      final allCoins = [...current.coins, ...newCoins];
      emit(current.copyWith(
        coins: allCoins,
        filteredCoins: allCoins,
        isLoadingMore: false,
        hasMore: newCoins.length >= _kPerPage,
        currentPage: nextPage,
      ));
    } catch (_) {
      // Silently stop pagination on error; user can scroll up to retry.
      emit(current.copyWith(isLoadingMore: false, hasMore: false));
    }
  }

  void searchCoins(String query) {
    if (state is MarketLoaded) {
      final currentState = state as MarketLoaded;
      if (query.isEmpty) {
        emit(currentState.copyWith(
          filteredCoins: currentState.coins,
          searchQuery: '',
        ));
        return;
      }

      final lowerQuery = query.toLowerCase();
      final filtered = currentState.coins.where((coin) {
        return coin.name.toLowerCase().contains(lowerQuery) ||
            coin.symbol.toLowerCase().contains(lowerQuery);
      }).toList();

      emit(currentState.copyWith(
        filteredCoins: filtered,
        searchQuery: query,
      ));
    }
  }
}
