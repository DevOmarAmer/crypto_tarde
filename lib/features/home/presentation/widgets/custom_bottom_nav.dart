import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({super.key, this.currentIndex = 0});

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
          _buildNavItem(
            context,
            'assets/images/svg/home.svg',
            'Home',
            currentIndex == 0,
            () => context.go(AppRouter.home),
          ),
          _buildNavItem(
            context,
            'assets/images/svg/shopping-bag.svg',
            'Markets',
            currentIndex == 1,
            () => context.go(AppRouter.market),
          ),
          _buildNavItem(
            context,
            'assets/images/svg/receipt.svg',
            'Favorites',
            currentIndex == 2,
            () => context.go(AppRouter.favorites),
            icon: currentIndex == 2
                ? Icons.star_rounded
                : Icons.star_outline_rounded,
          ),
          _buildNavItem(
            context,
            'assets/images/svg/receipt.svg',
            'Activity',
            currentIndex == 3,
            () => context.go(AppRouter.myTrades),
          ),
          _buildNavItem(
            context,
            'assets/images/svg/empty-wallet.svg',
            'Wallets',
            currentIndex == 4,
            () => context.go(AppRouter.wallet),
          ),

        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String assetPath,
    String label,
    bool isActive,
    VoidCallback onTap, {
    IconData? icon,
  }) {
    final color = isActive ? AppColors.primary : AppColors.textSecondary;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(icon, color: color, size: 24)
          else
            SvgPicture.asset(
              assetPath,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              width: 24,
              height: 24,
            ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 10)),
        ],
      ),
    );
  }
}
