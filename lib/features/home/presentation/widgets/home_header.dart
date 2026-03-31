import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import 'quick_action_item.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24.0),
      decoration: const BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.0),
          bottomRight: Radius.circular(32.0),
        ),
      ),
      child: Column(
        children: [
          const CustomAppBar(),
          const SizedBox(height: 8),
          // شبكة الأيقونات السريعة
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SizedBox(
              height: 200,
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 0.8,
                mainAxisSpacing: 8.0,
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
          ),
        ],
      ),
    );
  }
}
