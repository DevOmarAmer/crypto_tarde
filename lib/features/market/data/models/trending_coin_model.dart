import '../../domain/entities/trending_coin_item.dart';

class TrendingCoinModel extends TrendingCoinItem {
  const TrendingCoinModel({
    required super.id,
    required super.name,
    required super.symbol,
    required super.thumbUrl,
    required super.marketCapRank,
    required super.price,
    required super.priceChangePercentage24h,
    required super.marketCap,
    required super.totalVolume,
    required super.score,
  });

  /// Parses one element from the `coins` array of /search/trending
  /// Structure: { "item": { ... } }
  factory TrendingCoinModel.fromJson(Map<String, dynamic> json) {
    final item = json['item'] as Map<String, dynamic>;
    final data = item['data'] as Map<String, dynamic>? ?? {};
    final priceChange24h =
        (data['price_change_percentage_24h'] as Map<String, dynamic>?)?['usd'];

    return TrendingCoinModel(
      id: item['id'] as String? ?? '',
      name: item['name'] as String? ?? '',
      symbol: (item['symbol'] as String? ?? '').toUpperCase(),
      thumbUrl: item['small'] as String? ??
          item['thumb'] as String? ??
          '',
      marketCapRank: item['market_cap_rank'] as int?,
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      priceChangePercentage24h:
          (priceChange24h as num?)?.toDouble() ?? 0.0,
      marketCap: data['market_cap'] as String? ?? '--',
      totalVolume: data['total_volume'] as String? ?? '--',
      score: (item['score'] as num?)?.toInt() ?? 0,
    );
  }
}
