import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/market_cubit.dart';

import '../widgets/market_coin_tile.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  int _selectedTabIndex = 1; // الافتراضي 'Spot' كما في التصميم
  final List<String> _tabs = ['Convert', 'Spot', 'Margin', 'Fiat'];

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
              child: BlocBuilder<MarketCubit, MarketState>(
                builder: (context, state) {
                  if (state is MarketLoading || state is MarketInitial) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  } else if (state is MarketError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load market data',
                            style: const TextStyle(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context.read<MarketCubit>().fetchMarketCoins(),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                            child: const Text('Retry', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  } else if (state is MarketLoaded) {
                    final coins = state.filteredCoins;
                    return RefreshIndicator(
                      onRefresh: () => context.read<MarketCubit>().fetchMarketCoins(),
                      color: AppColors.primary,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 120), // مساحة للـ Bottom Nav
                        itemCount: coins.length + 1,
                        itemBuilder: (context, index) {
                          if (index == coins.length) {
                            return _buildAddFavoriteButton();
                          }
                          return MarketCoinTile(coin: coins[index]);
                        },
                      ),
                    );
                  }
                  return const SizedBox();
                },
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
