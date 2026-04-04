import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/local_db/hive_boxes.dart';
import '../../domain/models/wallet_asset_model.dart';
import '../../domain/models/portfolio_holding_model.dart';

import '../widgets/wallet_asset_tile.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _isBalanceVisible = true;
  int _selectedActionIndex = 0;
  final List<String> _actions = ['Deposit', 'Withdraw', 'Transfer'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: Hive.box(HiveBoxes.userSettings).listenable(keys: ['virtual_cash_balance_usd']),
          builder: (context, Box settingsBox, _) {
            final virtualBalance = settingsBox.get('virtual_cash_balance_usd', defaultValue: 10000.0) as double;
            
            return ValueListenableBuilder(
              valueListenable: Hive.box<PortfolioHoldingModel>(HiveBoxes.portfolio).listenable(),
              builder: (context, Box<PortfolioHoldingModel> portfolioBox, _) {
                final holdings = portfolioBox.values.toList();
                
                // Calculate total invested fiat for demo purposes
                double totalAssetsValue = 0;
                for (var holding in holdings) {
                  totalAssetsValue += holding.quantity * holding.avgBuyPrice;
                }
                final totalBalance = virtualBalance + totalAssetsValue;

                return Column(
                  children: [
                    _buildHeaderSection(totalBalance),
                    _buildActionButtons(),
                    const SizedBox(height: 8),
                    Expanded(
                      child: holdings.isEmpty 
                        ? const Center(child: Text('No assets in wallet', style: TextStyle(color: AppColors.textSecondary)))
                        : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 120),
                            itemCount: holdings.length,
                            itemBuilder: (context, index) {
                              final holding = holdings[index];
                              // Convert to WalletAssetModel for the existing tile
                              final assetModel = WalletAssetModel(
                                name: holding.name,
                                symbol: holding.symbol,
                                iconAsset: holding.logoUrl, // Note: Tile may need update if it expects SVG
                                cryptoBalance: holding.quantity.toStringAsFixed(4),
                                fiatBalance: '\$${(holding.quantity * holding.avgBuyPrice).toStringAsFixed(2)}',
                              );
                              return WalletAssetTile(
                                asset: assetModel,
                                isBalanceVisible: _isBalanceVisible,
                              );
                            },
                          ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  // القسم العلوي الخاص بإجمالي الرصيد
  Widget _buildHeaderSection(double totalBalance) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Current Balance',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  _isBalanceVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isBalanceVisible = !_isBalanceVisible;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _isBalanceVisible ? '\$${totalBalance.toStringAsFixed(2)}' : '********',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // شريط أزرار العمليات (Deposit, Withdraw, Transfer)
  Widget _buildActionButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2329), // خلفية داكنة خفيفة
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: List.generate(_actions.length, (index) {
          final isActive = _selectedActionIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedActionIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : Colors.transparent, // اللون الأخضر إذا كان نشطاً
                  borderRadius: BorderRadius.circular(12.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  _actions[index],
                  style: TextStyle(
                    color: isActive
                        ? AppColors.darkBackground
                        : AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
