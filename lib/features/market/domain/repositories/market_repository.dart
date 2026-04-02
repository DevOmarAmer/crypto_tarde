import '../entities/coin_entity.dart';

abstract class MarketRepository {
  Future<List<CoinEntity>> getMarketCoins(int page, int perPage);
}
