import 'package:hive/hive.dart';

part 'trade_record_model.g.dart';

@HiveType(typeId: 1)
class TradeRecordModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String type; // 'BUY' or 'SELL' or 'DEPOSIT' or 'WITHDRAW'

  @HiveField(2)
  final String coinId;

  @HiveField(3)
  final String symbol;

  @HiveField(4)
  final double quantity;

  @HiveField(5)
  final double price;

  @HiveField(6)
  final double total;

  @HiveField(7)
  final DateTime timestamp;

  TradeRecordModel({
    required this.id,
    required this.type,
    required this.coinId,
    required this.symbol,
    required this.quantity,
    required this.price,
    required this.total,
    required this.timestamp,
  });
}
