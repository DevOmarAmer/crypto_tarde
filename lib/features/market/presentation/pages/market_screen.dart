import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../domain/models/market_coin_model.dart';

import '../widgets/market_coin_tile.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  int _selectedTabIndex = 1; // الافتراضي 'Spot' كما في التصميم
  final List<String> _tabs = ['Convert', 'Spot', 'Margin', 'Fiat'];

  // بيانات وهمية للتوضيح
  final List<MarketCoinModel> _coins = [
    MarketCoinModel(
      name: 'Bitcoin',
      symbol: 'BTC',
      iconAsset: 'assets/images/svg/bitcoin.svg',
      chartAsset: 'assets/images/png/onboarding_one.png',
      price: '32,697.05',
      change: '+0.81%',
      isPositive: true,
    ),
    MarketCoinModel(
      name: 'Ethereum',
      symbol: 'ETH',
      iconAsset: 'assets/images/svg/ethernum.svg',
      chartAsset: 'assets/images/png/onboarding_one.png',
      price: '32,697.05',
      change: '-0.81%',
      isPositive: false,
    ),
    MarketCoinModel(
      name: 'Cardano',
      symbol: 'ADA',
      iconAsset: 'assets/images/svg/cardano.svg',
      chartAsset: 'assets/images/png/onboarding_one.png',
      price: '32,697.05',
      change: '+0.81%',
      isPositive: true,
    ),
    MarketCoinModel(
      name: 'SHIBA INU',
      symbol: 'SHIB',
      iconAsset: 'assets/images/svg/ahiba_inu.svg',
      chartAsset: 'assets/images/png/onboarding_one.png',
      price: '32,697.05',
      change: '-0.81%',
      isPositive: false,
    ),
    MarketCoinModel(
      name: 'HIFI',
      symbol: 'MFT',
      iconAsset: 'assets/images/svg/hifi_finance.svg',
      chartAsset: 'assets/images/png/onboarding_one.png',
      price: '32,697.05',
      change: '-0.81%',
      isPositive: false,
    ),
    MarketCoinModel(
      name: 'REN',
      symbol: 'REN',
      iconAsset: 'assets/images/svg/ren.svg',
      chartAsset: 'assets/images/png/onboarding_one.png',
      price: '32,697.05',
      change: '+0.81%',
      isPositive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(

        child: Column(
          children: [
            const CustomAppBar(), // المكون المُعاد استخدامه
            _buildCustomTabBar(), // شريط التبويبات المخصص
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 120), // مساحة للـ Bottom Nav
                children: [
                  ..._coins.map((coin) => MarketCoinTile(coin: coin)),
                  _buildAddFavoriteButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // شريط التبويبات المخصص (Convert, Spot, Margin...)
  Widget _buildCustomTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: const Color(0xFF0F141A), // خلفية داكنة جداً
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_tabs.length, (index) {
          final isActive = _selectedTabIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTabIndex = index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF1E2329) : Colors.transparent, // لون الزر النشط
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  _tabs[index],
                  style: TextStyle(
                    color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // زر إضافة للمفضلة
  Widget _buildAddFavoriteButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: AppColors.textSecondary.withOpacity(0.3), width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add_circle_outline, color: AppColors.textSecondary, size: 20),
              SizedBox(width: 8),
              Text(
                'Add Favorite',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
