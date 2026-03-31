import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24.0),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem('assets/images/svg/home.svg', 'Home', true),
          _buildNavItem('assets/images/svg/market.svg', 'Markets', false),
          _buildNavItem('assets/images/svg/trades.svg', 'Trades', false),
          _buildNavItem('assets/images/svg/activity.svg', 'Activity', false),
          _buildNavItem('assets/images/svg/wallet.svg', 'Wallets', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(String assetPath, String label, bool isActive) {
    final color = isActive ? AppColors.primary : AppColors.textSecondary;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          assetPath,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          width: 50,
          height: 50,
        ),
        // const SizedBox(height: 4),
        Text(label, style: TextStyle(color: color, fontSize: 10)),
      ],
    );
  }
}
