import '../../../../core/network/dio_client.dart';
import '../../../../core/di/dependency_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/search_model.dart';

class SearchRepo {
  final DioClient _dioClient;
  
  SearchRepo(this._dioClient);

  Future<List<SearchCoinModel>> searchCoins(String query) async {
    try {
      final response = await _dioClient.coinGeckoDio.get('/search?query=$query');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['coins'];
        return data.map((json) => SearchCoinModel.fromJson(json)).toList();
      }
      throw Exception('Search failed');
    } catch (e) {
      throw Exception('Search failed. Please try again.');
    }
  }

  Future<void> saveSearchQuery(String query) async {
    if (query.trim().isEmpty) return;
    final prefs = sl<SharedPreferences>();
    final history = prefs.getStringList('search_history') ?? [];
    if (history.contains(query)) {
      history.remove(query);
    }
    history.insert(0, query);
    if (history.length > 10) history.removeLast();
    await prefs.setStringList('search_history', history);
  }

  Future<List<String>> getSearchHistory() async {
    final prefs = sl<SharedPreferences>();
    return prefs.getStringList('search_history') ?? [];
  }

  Future<void> clearSearchHistory() async {
    final prefs = sl<SharedPreferences>();
    await prefs.remove('search_history');
  }

  Future<void> removeSearchQuery(String query) async {
    final prefs = sl<SharedPreferences>();
    final history = prefs.getStringList('search_history') ?? [];
    history.remove(query);
    await prefs.setStringList('search_history', history);
  }
}