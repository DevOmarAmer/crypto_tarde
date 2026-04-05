import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/exceptions.dart';
import '../models/coin_market_model.dart';
import '../../domain/repositories/market_repository.dart';

class MarketRemoteDataSource {
  final DioClient dioClient;

  MarketRemoteDataSource({required this.dioClient});

  Future<List<CoinMarketModel>> getMarketCoins(int page, int perPage) async {
    try {
      final response = await dioClient.coinGeckoDio.get(
        '/coins/markets',
        queryParameters: {
          'vs_currency': 'usd',
          'order': 'market_cap_desc',
          'per_page': perPage,
          'page': page,
          'sparkline': 'true',
          'price_change_percentage': '24h',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => CoinMarketModel.fromJson(json)).toList();
      } else if (response.statusCode == 429) {
        throw const RateLimitException();
      } else {
        throw Exception('Failed to load market data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        throw const RateLimitException();
      }
      throw Exception('Failed to perform API request: $e');
    } catch (e) {
      if (e is RateLimitException) rethrow;
      throw Exception('Failed to perform API request: $e');
    }
  }
}

class MarketRepositoryImpl implements MarketRepository {
  final MarketRemoteDataSource remoteDataSource;

  MarketRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CoinMarketModel>> getMarketCoins(int page, int perPage) async {
    return await remoteDataSource.getMarketCoins(page, perPage);
  }
}
