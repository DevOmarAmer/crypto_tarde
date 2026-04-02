import '../entities/kline_entity.dart';
import '../entities/order_book_entity.dart';

abstract class TradeRepository {
  Future<List<KlineEntity>> getKlines(String symbol, String interval);
  Future<OrderBookEntity> getOrderBook(String symbol);
  
  Future<void> executeBuy({
    required String coinId,
    required String symbol,
    required String name,
    required String logoUrl,
    required double quantity,
    required double price,
    required double totalCost,
  });

  Future<void> executeSell({
    required String coinId,
    required String symbol,
    required double quantity,
    required double price,
    required double totalGain,
  });

  Future<double> getVirtualBalance();
}
