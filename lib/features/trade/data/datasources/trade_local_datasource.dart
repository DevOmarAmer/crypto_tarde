import 'package:hive/hive.dart';
import '../../../../core/local_db/hive_boxes.dart';
import '../../../activity/domain/models/trade_record_model.dart';
import '../../../wallet/domain/models/portfolio_holding_model.dart';
import 'package:uuid/uuid.dart';

class TradeLocalDataSource {
  static const String virtualBalanceKey = 'virtual_cash_balance_usd';
  static const double initialVirtualBalance = 10000.0; // $10k initial balance

  Future<double> getVirtualBalance() async {
    final box = Hive.box(HiveBoxes.userSettings);
    return box.get(virtualBalanceKey, defaultValue: initialVirtualBalance);
  }

  Future<void> updateVirtualBalance(double newBalance) async {
    final box = Hive.box(HiveBoxes.userSettings);
    await box.put(virtualBalanceKey, newBalance);
  }

  Future<PortfolioHoldingModel?> getPortfolioHolding(String coinId) async {
    final box = Hive.box<PortfolioHoldingModel>(HiveBoxes.portfolio);
    return box.get(coinId);
  }

  Future<void> _saveTradeHistory(TradeRecordModel trade) async {
    final box = Hive.box<TradeRecordModel>(HiveBoxes.tradeHistory);
    await box.put(trade.id, trade);
  }

  Future<void> executeBuy({
    required String coinId,
    required String symbol,
    required String name,
    required String logoUrl,
    required double quantity,
    required double price,
    required double totalCost,
  }) async {
    final balance = await getVirtualBalance();
    if (balance < totalCost) {
      throw Exception('Insufficient virtual balance');
    }

    // Deduct balance
    await updateVirtualBalance(balance - totalCost);

    // Update portfolio
    final box = Hive.box<PortfolioHoldingModel>(HiveBoxes.portfolio);
    var holding = await getPortfolioHolding(coinId);
    
    if (holding != null) {
      // Calculate new weighted avg price
      final oldTotalValue = holding.quantity * holding.avgBuyPrice;
      final newTotalValue = oldTotalValue + totalCost;
      final newQuantity = holding.quantity + quantity;
      
      holding.quantity = newQuantity;
      holding.avgBuyPrice = newTotalValue / newQuantity;
      await holding.save();
    } else {
      holding = PortfolioHoldingModel(
        coinId: coinId,
        symbol: symbol,
        name: name,
        logoUrl: logoUrl,
        quantity: quantity,
        avgBuyPrice: price,
      );
      await box.put(coinId, holding);
    }

    // Save history
    await _saveTradeHistory(
      TradeRecordModel(
        id: const Uuid().v4(),
        type: 'BUY',
        coinId: coinId,
        symbol: symbol,
        quantity: quantity,
        price: price,
        total: totalCost,
        timestamp: DateTime.now(),
      ),
    );
  }

  Future<void> executeSell({
    required String coinId,
    required String symbol,
    required double quantity,
    required double price,
    required double totalGain,
  }) async {
    final holding = await getPortfolioHolding(coinId);
    if (holding == null || holding.quantity < quantity) {
      throw Exception('Insufficient holding quantity');
    }

    // Update portfolio
    final box = Hive.box<PortfolioHoldingModel>(HiveBoxes.portfolio);
    holding.quantity -= quantity;
    
    if (holding.quantity <= 0.00000001) { // Floating point buffer
      await box.delete(coinId);
    } else {
      await holding.save();
    }

    // Add balance
    final balance = await getVirtualBalance();
    await updateVirtualBalance(balance + totalGain);

    // Save history
    await _saveTradeHistory(
      TradeRecordModel(
        id: const Uuid().v4(),
        type: 'SELL',
        coinId: coinId,
        symbol: symbol,
        quantity: quantity,
        price: price,
        total: totalGain,
        timestamp: DateTime.now(),
      ),
    );
  }
}
