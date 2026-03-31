class MarketCoinModel {
  final String name;
  final String symbol;
  final String iconAsset;
  final String chartAsset;
  final String price;
  final String change;
  final bool isPositive;

  MarketCoinModel({
    required this.name,
    required this.symbol,
    required this.iconAsset,
    required this.chartAsset,
    required this.price,
    required this.change,
    required this.isPositive,
  });
}
