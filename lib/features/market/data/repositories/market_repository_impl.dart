import '../../../../core/network/dio_client.dart';
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
      } else {
        throw Exception('Failed to load market data: ${response.statusCode}');
      }
    } catch (e) {
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
