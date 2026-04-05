import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';

class CoinCard extends StatelessWidget {
  final String price;
  final String pair;
  final String change;
  final bool isPositive;
  final String coinIconAsset; // SVG path
  final String chartImageAsset; // PNG/Image path
  final VoidCallback? onTap;

  const CoinCard({
    super.key,
    required this.price,
    required this.pair,
    required this.change,
    required this.isPositive,
    required this.coinIconAsset,
    required this.chartImageAsset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final changeColor = isPositive ? AppColors.priceGreen : AppColors.priceRed;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 16.0),
        padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: TextStyle(
                  color: changeColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SvgPicture.asset(coinIconAsset, width: 24, height: 24),
            ],
          ),

          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                pair,
                style: const TextStyle(color: AppColors.textDark, fontSize: 12),
              ),
              const SizedBox(width: 4),
              Text(
                change,
                style: TextStyle(color: changeColor, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          // صورة الرسم البياني المصغرة
          Image.asset(
            chartImageAsset,
            width: double.infinity,
            height: 40,
            fit: BoxFit.contain,
          ),
        ],
      ),
      ),
    );
  }
}
