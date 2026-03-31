import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/wallet_asset_model.dart';

import '../widgets/wallet_asset_tile.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _isBalanceVisible = true; // حالة العين (إظهار/إخفاء الرصيد)
  int _selectedActionIndex = 0;  // تبويب (Deposit) هو الافتراضي
  final List<String> _actions = ['Deposit', 'Withdraw', 'Transfer'];

  // بيانات وهمية للتوضيح (تتطابق مع التصميم)
  final List<WalletAssetModel> _assets = [
    WalletAssetModel(
      name: 'Bitcoin',
      symbol: 'BTC',
      iconAsset: 'assets/images/svg/bitcoin.svg',
      cryptoBalance: '32,697.05',
      fiatBalance: '\$468,554.23',
    ),
    WalletAssetModel(
      name: 'Ethereum',
      symbol: 'ETH',
      iconAsset: 'assets/images/svg/ethernum.svg',
      cryptoBalance: '32,697.05',
      fiatBalance: '\$468,554.23',
    ),
    WalletAssetModel(
      name: 'Cardano',
      symbol: 'ADA',
      iconAsset: 'assets/images/svg/cardano.svg',
      cryptoBalance: '32,697.05',
      fiatBalance: '\$468,554.23',
    ),
    WalletAssetModel(
      name: 'SHIBA INU',
      symbol: 'SHIB',
      iconAsset: 'assets/images/svg/ahiba_inu.svg',
      cryptoBalance: '32,697.05',
      fiatBalance: '\$468,554.23',
    ),
    WalletAssetModel(
      name: 'HIFI',
      symbol: 'MFT',
      iconAsset: 'assets/images/svg/hifi_finance.svg',
      cryptoBalance: '32,697.05',
      fiatBalance: '\$468,554.23',
    ),
    WalletAssetModel(
      name: 'REN',
      symbol: 'REN',
      iconAsset: 'assets/images/svg/ren.svg',
      cryptoBalance: '32,697.05',
      fiatBalance: '\$468,554.23',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(

        child: Column(
          children: [
            _buildHeaderSection(),
            _buildActionButtons(),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 120), // مساحة لعدم تغطية الـ Bottom Nav
                itemCount: _assets.length,
                itemBuilder: (context, index) {
                  return WalletAssetTile(
                    asset: _assets[index],
                    isBalanceVisible: _isBalanceVisible,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // القسم العلوي الخاص بإجمالي الرصيد
  Widget _buildHeaderSection() {
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
            _isBalanceVisible ? '40,059.83' : '********',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _isBalanceVisible ? '\$468,554.23' : '********',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
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
