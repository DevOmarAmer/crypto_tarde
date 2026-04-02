import '../../domain/entities/coin_entity.dart';

class CoinMarketModel extends CoinEntity {
  const CoinMarketModel({
    required super.id,
    required super.symbol,
    required super.name,
    required super.image,
    required super.currentPrice,
    required super.priceChangePercentage24h,
    required super.sparkline,
    required super.marketCap,
    required super.totalVolume,
  });

  factory CoinMarketModel.fromJson(Map<String, dynamic> json) {
    return CoinMarketModel(
      id: json['id'] ?? '',
      symbol: (json['symbol'] ?? '').toString().toUpperCase(),
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      currentPrice: (json['current_price'] ?? 0).toDouble(),
      priceChangePercentage24h: (json['price_change_percentage_24h'] ?? 0).toDouble(),
      sparkline: _parseSparkline(json['sparkline_in_7d']),
      marketCap: (json['market_cap'] ?? 0).toDouble(),
      totalVolume: (json['total_volume'] ?? 0).toDouble(),
    );
  }

  static List<double> _parseSparkline(dynamic sparklineData) {
    if (sparklineData != null && sparklineData['price'] != null) {
      final List<dynamic> prices = sparklineData['price'];
      return prices.map((e) => (e as num).toDouble()).toList();
    }
    return [];
  }
}
