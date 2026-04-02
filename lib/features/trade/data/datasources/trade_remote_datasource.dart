import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/kline_entity.dart';
import '../../domain/entities/order_book_entity.dart';

class TradeRemoteDataSource {
  final DioClient dioClient;

  TradeRemoteDataSource({required this.dioClient});

  Future<List<KlineEntity>> getKlines(String symbol, String interval, {int limit = 100}) async {
    try {
      final response = await dioClient.binanceDio.get(
        '/klines',
        queryParameters: {
          'symbol': symbol.toUpperCase(),
          'interval': interval,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((kline) {
          return KlineEntity(
            timestamp: DateTime.fromMillisecondsSinceEpoch(kline[0] as int),
            open: double.parse(kline[1].toString()),
            high: double.parse(kline[2].toString()),
            low: double.parse(kline[3].toString()),
            close: double.parse(kline[4].toString()),
            volume: double.parse(kline[5].toString()),
          );
        }).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch klines: $e');
    }
  }

  Future<OrderBookEntity> getOrderBook(String symbol, {int limit = 20}) async {
    try {
      final response = await dioClient.binanceDio.get(
        '/depth',
        queryParameters: {
          'symbol': symbol.toUpperCase(),
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        final bids = (data['bids'] as List).map((e) => OrderBookLevel(
          price: double.parse(e[0].toString()),
          quantity: double.parse(e[1].toString()),
        )).toList();
        
        final asks = (data['asks'] as List).map((e) => OrderBookLevel(
          price: double.parse(e[0].toString()),
          quantity: double.parse(e[1].toString()),
        )).toList();

        return OrderBookEntity(bids: bids, asks: asks);
      }
      return OrderBookEntity.empty();
    } catch (e) {
      throw Exception('Failed to fetch order book: $e');
    }
  }
}
