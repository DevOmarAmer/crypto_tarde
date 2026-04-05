import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── State ─────────────────────────────────────────────────────────────────────

class FavoritesState extends Equatable {
  final Set<String> favoriteCoinIds;

  const FavoritesState({this.favoriteCoinIds = const {}});

  bool isFavorited(String coinId) => favoriteCoinIds.contains(coinId);

  FavoritesState copyWith({Set<String>? favoriteCoinIds}) =>
      FavoritesState(favoriteCoinIds: favoriteCoinIds ?? this.favoriteCoinIds);

  @override
  List<Object?> get props => [favoriteCoinIds];
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

const _kPrefKey = 'favorite_coin_ids';

class FavoritesCubit extends Cubit<FavoritesState> {
  final SharedPreferences _prefs;

  FavoritesCubit(this._prefs) : super(const FavoritesState()) {
    _loadFromPrefs();
  }

  void _loadFromPrefs() {
    final saved = _prefs.getStringList(_kPrefKey) ?? [];
    emit(FavoritesState(favoriteCoinIds: saved.toSet()));
  }

  void toggleFavorite(String coinId) {
    final current = Set<String>.from(state.favoriteCoinIds);
    if (current.contains(coinId)) {
      current.remove(coinId);
    } else {
      current.add(coinId);
    }
    emit(state.copyWith(favoriteCoinIds: current));
    _prefs.setStringList(_kPrefKey, current.toList());
  }

  void removeFavorite(String coinId) {
    final current = Set<String>.from(state.favoriteCoinIds)..remove(coinId);
    emit(state.copyWith(favoriteCoinIds: current));
    _prefs.setStringList(_kPrefKey, current.toList());
  }
}
