import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routes/app_router.dart';

import '../widgets/home_header.dart';
import '../widgets/trading_option_card.dart';
import '../widgets/coin_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120.0), // مساحة لشريط التنقل
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeHeader(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TradingOptionCard(
                    title: 'P2P Trading',
                    subtitle: 'Bank Transfer, Paypal Revolut...',
                    imageAsset: 'assets/images/png/rocket.png',
                    onTap: () => context.push(AppRouter.market),
                  ),
                  TradingOptionCard(
                    title: 'Credit/Debit Card',
                    subtitle: 'Visa, Mastercard',
                    imageAsset: 'assets/images/png/credit.png',
                    onTap: () => context.push(AppRouter.wallet),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Recent Coin',
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCoinsList(context), // Recent Coins
                  const SizedBox(height: 24),
                  const Text(
                    'Top Coins',
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCoinsList(context), // Top Coins
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // قائمة العملات الأفقية (تم وضع بيانات وهمية للتوضيح)
  Widget _buildCoinsList(BuildContext context) {
    return SizedBox(
      height: 140, // ارتفاع ثابت للبطاقة
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none, // لمنع قص الـ Shadow إذا تم إضافته لاحقاً
        children: [
          CoinCard(
            price: '40,059.83',
            pair: 'BTC/BUSD',
            change: '+0.81%',
            isPositive: true,
            coinIconAsset: 'assets/images/svg/bitcoin.svg',
            chartImageAsset:
                'assets/images/png/onboarding_one.png', // Placeholder for chart
            onTap: () => context.push(
              AppRouter.trades,
              extra: {'coinId': 'bitcoin', 'symbol': 'BTC', 'name': 'Bitcoin'},
            ),
          ),
          CoinCard(
            price: '2,059.83',
            pair: 'SOL/BUSD',
            change: '-0.81%',
            isPositive: false,
            coinIconAsset: 'assets/images/svg/solana.svg',
            chartImageAsset:
                'assets/images/png/onboarding_two.png', // Placeholder for chart
            onTap: () => context.push(
              AppRouter.trades,
              extra: {'coinId': 'solana', 'symbol': 'SOL', 'name': 'Solana'},
            ),
          ),
          CoinCard(
            price: '40,059.83',
            pair: 'ETH/BUSD',
            change: '+1.20%',
            isPositive: true,
            coinIconAsset: 'assets/images/svg/ethernum.svg',
            chartImageAsset:
                'assets/images/png/onboarding_three.png', // Placeholder for chart
            onTap: () => context.push(
              AppRouter.trades,
              extra: {
                'coinId': 'ethereum',
                'symbol': 'ETH',
                'name': 'Ethereum',
              },
            ),
          ),
        ],
      ),
    );
  }
}
