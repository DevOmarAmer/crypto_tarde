import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/model/search_model.dart';

class SearchResultCard extends StatelessWidget {
  final SearchCoinModel coin;

  const SearchResultCard({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Opacity(
              opacity: 0.05,
              child: CachedNetworkImage(
                imageUrl: coin.large,
                width: 100,
                height: 100,
                placeholder: (context, url) => const Center(
                  child: SizedBox(),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary10,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.network(
                        coin.thumb,
                        width: 32,
                        height: 32,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.monetization_on,
                              color: AppColors.primary,
                            ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            coin.name,
                            style: const TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            coin.symbol.toUpperCase(),
                            style: const TextStyle(color: AppColors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          coin.marketCapRank != null
                              ? '#${coin.marketCapRank}'
                              : 'N/A',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Rank', style: TextStyle(color: AppColors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
