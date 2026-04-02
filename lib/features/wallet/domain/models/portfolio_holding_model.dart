import 'package:hive/hive.dart';

part 'portfolio_holding_model.g.dart';

@HiveType(typeId: 0)
class PortfolioHoldingModel extends HiveObject {
  @HiveField(0)
  final String coinId;

  @HiveField(1)
  final String symbol;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String logoUrl;

  @HiveField(4)
  double quantity;

  @HiveField(5)
  double avgBuyPrice;

  PortfolioHoldingModel({
    required this.coinId,
    required this.symbol,
    required this.name,
    required this.logoUrl,
    required this.quantity,
    required this.avgBuyPrice,
  });
}
