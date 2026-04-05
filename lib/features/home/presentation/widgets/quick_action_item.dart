import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';

class QuickActionItem extends StatelessWidget {
  final String title;
  final String iconAsset; // مسار الأيقونة SVG
  final VoidCallback? onTap;

  const QuickActionItem({
    super.key,
    required this.title,
    required this.iconAsset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          iconAsset,
          width: 50,
          height: 50,
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
        ),

        // const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
        ),
      ],
    ),
    );
  }
}
