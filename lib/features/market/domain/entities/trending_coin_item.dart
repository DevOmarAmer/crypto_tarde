class TrendingCoinItem {
  final String id;
  final String name;
  final String symbol;
  final String thumbUrl;
  final int? marketCapRank;
  final double price;
  final double priceChangePercentage24h;
  final String marketCap;
  final String totalVolume;
  final int score; // trending rank (0 = hottest)

  const TrendingCoinItem({
    required this.id,
    required this.name,
    required this.symbol,
    required this.thumbUrl,
    required this.marketCapRank,
    required this.price,
    required this.priceChangePercentage24h,
    required this.marketCap,
    required this.totalVolume,
    required this.score,
  });

  bool get isPositive => priceChangePercentage24h >= 0;
}
