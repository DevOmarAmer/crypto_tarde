import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/wallet_asset_model.dart';

class WalletAssetTile extends StatelessWidget {
  final WalletAssetModel asset;
  final bool isBalanceVisible; // لاستقبال حالة إخفاء/إظهار الرصيد

  const WalletAssetTile({
    super.key,
    required this.asset,
    required this.isBalanceVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        children: [
          // أيقونة العملة
          CachedNetworkImage(
            imageUrl: asset.iconAsset,
            width: 40,
            height: 40,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error, color: AppColors.error),
          ),
          const SizedBox(width: 16),
          
          // اسم العملة ورمزها
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  asset.symbol,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // الرصيد
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isBalanceVisible ? asset.cryptoBalance : '****',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isBalanceVisible ? asset.fiatBalance : '****',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
