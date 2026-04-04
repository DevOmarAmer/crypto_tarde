import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repos/search_repo.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepo _repo;
  final TextEditingController searchController = TextEditingController();

  SearchCubit(this._repo) : super(SearchInitial());

  Future<void> loadSearchHistory() async {
    final history = await _repo.getSearchHistory();
    emit(SearchHistoryLoaded(history));
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      loadSearchHistory();
      return;
    }

    emit(SearchLoading());
    try {
      final coins = await _repo.searchCoins(query);
      emit(SearchResultsSuccess(coins));
    } catch (e) {
      emit(SearchError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> addToHistory(String query) async {
    await _repo.saveSearchQuery(query);
  }

  Future<void> clearHistory() async {
    await _repo.clearSearchHistory();
    emit(SearchHistoryLoaded([]));
  }

  Future<void> removeQuery(String query) async {
    await _repo.removeSearchQuery(query);
    loadSearchHistory();
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}