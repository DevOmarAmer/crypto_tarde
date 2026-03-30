import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomActionTile extends StatelessWidget {
  final String title;
  final String trailingText;
  final IconData? leadingIcon;
  final VoidCallback onTap;

  const CustomActionTile({
    super.key,
    required this.title,
    required this.trailingText,
    this.leadingIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Row(
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, color: AppColors.primary, size: 24),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              trailingText,
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
