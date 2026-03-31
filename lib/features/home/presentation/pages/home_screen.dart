import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_colors.dart';

import '../widgets/quick_action_item.dart';
import '../widgets/trading_option_card.dart';
import '../widgets/coin_card.dart';
import '../widgets/custom_bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      extendBody: true, // ضرورية لكي يظهر المحتوى أسفل شريط التنقل العائم
      bottomNavigationBar: const CustomBottomNav(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120.0), // مساحة لشريط التنقل
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(context),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TradingOptionCard(
                    title: 'P2P Trading',
                    subtitle: 'Bank Transfer, Paypal Revolut...',
                    imageAsset: 'assets/images/png/rocket.png',
                    onTap: () {},
                  ),
                  TradingOptionCard(
                    title: 'Credit/Debit Card',
                    subtitle: 'Visa, Mastercard',
                    imageAsset: 'assets/images/png/credit.png',
                    onTap: () {},
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
                  _buildCoinsList(), // Recent Coins
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
                  _buildCoinsList(), // Top Coins
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // القسم العلوي الداكن
  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 60.0,
        left: 24.0,
        right: 24.0,
        bottom: 24.0,
      ),
      decoration: const BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.0),
          bottomRight: Radius.circular(32.0),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/png/user.png'),
              ),

              Row(
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/svg/search.svg',
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/svg/scan.svg',
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/svg/notif.svg',
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () => context.push(AppRouter.notifications),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // شبكة الأيقونات السريعة
          SizedBox(
            height: 200,
            child: GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.0,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              children: const [
                QuickActionItem(
                  title: 'Deposit',
                  iconAsset: 'assets/images/svg/deposit.svg',
                ),
                QuickActionItem(
                  title: 'Referral',
                  iconAsset: 'assets/images/svg/referral.svg',
                ),
                QuickActionItem(
                  title: 'Grid Trading',
                  iconAsset: 'assets/images/svg/grid_trading.svg',
                ),
                QuickActionItem(
                  title: 'Margin',
                  iconAsset: 'assets/images/svg/margin.svg',
                ),
                QuickActionItem(
                  title: 'Launchpad',
                  iconAsset: 'assets/images/svg/launchpad.svg',
                ),
                QuickActionItem(
                  title: 'Savings',
                  iconAsset: 'assets/images/svg/savings.svg',
                ),
                QuickActionItem(
                  title: 'Liquid Swap',
                  iconAsset: 'assets/images/svg/liquid_swap.svg',
                ),
                QuickActionItem(
                  title: 'More',
                  iconAsset: 'assets/images/svg/more.svg',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // قائمة العملات الأفقية (تم وضع بيانات وهمية للتوضيح)
  Widget _buildCoinsList() {
    return SizedBox(
      height: 140, // ارتفاع ثابت للبطاقة
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none, // لمنع قص الـ Shadow إذا تم إضافته لاحقاً
        children: const [
          CoinCard(
            price: '40,059.83',
            pair: 'BTC/BUSD',
            change: '+0.81%',
            isPositive: true,
            coinIconAsset: 'assets/images/svg/bitcoin.svg',
            chartImageAsset:
                'assets/images/png/onboarding_one.png', // Placeholder for chart
          ),
          CoinCard(
            price: '2,059.83',
            pair: 'SOL/BUSD',
            change: '-0.81%',
            isPositive: false,
            coinIconAsset: 'assets/images/svg/solana.svg',
            chartImageAsset:
                'assets/images/png/onboarding_two.png', // Placeholder for chart
          ),
          CoinCard(
            price: '40,059.83',
            pair: 'ETH/BUSD',
            change: '+1.20%',
            isPositive: true,
            coinIconAsset: 'assets/images/svg/ethernum.svg',
            chartImageAsset:
                'assets/images/png/onboarding_three.png', // Placeholder for chart
          ),
        ],
      ),
    );
  }
}
