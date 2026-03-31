import 'package:flutter/material.dart';
import'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/market_coin_model.dart';

class MarketCoinTile extends StatelessWidget {
  final MarketCoinModel coin;

  const MarketCoinTile({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    final changeColor = coin.isPositive ? AppColors.priceGreen : AppColors.priceRed;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Row(
        children: [
          // أيقونة العملة
          SvgPicture.asset(coin.iconAsset, width: 40, height: 40),
          const SizedBox(width: 16),
          
          // اسم العملة ورمزها
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coin.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  coin.symbol,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // الرسم البياني المصغرة (Mini Chart)
          Expanded(
            flex: 2,
            child: Image.asset(
              coin.chartAsset,
              height: 30,
              fit: BoxFit.contain,
              color: changeColor, // لتلوين مسار الرسم البياني حسب الحالة
            ),
          ),

          // السعر ونسبة التغيير
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  coin.price,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  coin.change,
                  style: TextStyle(
                    color: changeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
