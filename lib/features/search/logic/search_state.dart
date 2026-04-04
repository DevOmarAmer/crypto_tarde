
import '../data/model/search_model.dart';

sealed class SearchState {}

class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}
class SearchHistoryLoaded extends SearchState {
  final List<String> history;
  SearchHistoryLoaded(this.history);
}
class SearchResultsSuccess extends SearchState {
  final List<SearchCoinModel> coins;
  SearchResultsSuccess(this.coins);
}
class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}