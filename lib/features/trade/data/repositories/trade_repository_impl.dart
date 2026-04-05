import '../../data/datasources/trade_local_datasource.dart';
import '../../data/datasources/trade_remote_datasource.dart';
import '../../domain/entities/kline_entity.dart';
import '../../domain/entities/order_book_entity.dart';
import '../../domain/repositories/trade_repository.dart';

class TradeRepositoryImpl implements TradeRepository {
  final TradeRemoteDataSource remoteDataSource;
  final TradeLocalDataSource localDataSource;

  TradeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<KlineEntity>> getKlines(String symbol, String interval) {
    return remoteDataSource.getKlines(symbol, interval);
  }

  @override
  Future<OrderBookEntity> getOrderBook(String symbol) {
    return remoteDataSource.getOrderBook(symbol);
  }

  @override
  Future<void> executeBuy({
    required String coinId,
    required String symbol,
    required String name,
    required String logoUrl,
    required double quantity,
    required double price,
    required double totalCost,
  }) {
    return localDataSource.executeBuy(
      coinId: coinId,
      symbol: symbol,
      name: name,
      logoUrl: logoUrl,
      quantity: quantity,
      price: price,
      totalCost: totalCost,
    );
  }

  @override
  Future<void> executeSell({
    required String coinId,
    required String symbol,
    required double quantity,
    required double price,
    required double totalGain,
  }) {
    return localDataSource.executeSell(
      coinId: coinId,
      symbol: symbol,
      quantity: quantity,
      price: price,
      totalGain: totalGain,
    );
  }

  @override
  Future<double> getVirtualBalance() {
    return localDataSource.getVirtualBalance();
  }

  @override
  Future<double> getOwnedQuantity(String coinId) async {
    final holding = await localDataSource.getPortfolioHolding(coinId);
    return holding?.quantity ?? 0.0;
  }
}
