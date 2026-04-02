class CoinEntity {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double priceChangePercentage24h;
  final List<double> sparkline;
  final double marketCap;
  final double totalVolume;

  const CoinEntity({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.sparkline,
    required this.marketCap,
    required this.totalVolume,
  });

  bool get isPositive => priceChangePercentage24h >= 0;
}
