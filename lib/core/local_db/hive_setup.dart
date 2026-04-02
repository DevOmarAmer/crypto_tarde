import 'package:crypto_tarde/features/wallet/domain/models/portfolio_holding_model.dart';
import 'package:crypto_tarde/features/activity/domain/models/trade_record_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'hive_boxes.dart';

class HiveSetup {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(PortfolioHoldingModelAdapter());
    Hive.registerAdapter(TradeRecordModelAdapter());

    // Open Core Boxes
    await Hive.openBox<PortfolioHoldingModel>(HiveBoxes.portfolio);
    await Hive.openBox<TradeRecordModel>(HiveBoxes.tradeHistory);
    await Hive.openBox<String>(HiveBoxes.watchlist);
    await Hive.openBox(HiveBoxes.userSettings);
    // await Hive.openBox<PriceAlertModel>(HiveBoxes.priceAlerts);
  }
}
