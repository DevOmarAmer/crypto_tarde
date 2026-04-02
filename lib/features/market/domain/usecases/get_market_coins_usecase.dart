import '../entities/coin_entity.dart';
import '../repositories/market_repository.dart';

class GetMarketCoinsUseCase {
  final MarketRepository repository;

  GetMarketCoinsUseCase(this.repository);

  Future<List<CoinEntity>> call({int page = 1, int perPage = 100}) async {
    return await repository.getMarketCoins(page, perPage);
  }
}
