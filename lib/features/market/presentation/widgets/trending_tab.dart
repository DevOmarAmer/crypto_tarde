import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/trending_coin_item.dart';
import '../bloc/trending_cubit.dart';

class TrendingTab extends StatefulWidget {
  const TrendingTab({super.key});

  @override
  State<TrendingTab> createState() => _TrendingTabState();
}

class _TrendingTabState extends State<TrendingTab> {
  @override
  void initState() {
    super.initState();
    context.read<TrendingCubit>().fetchTrending();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrendingCubit, TrendingState>(
      builder: (context, state) {
        if (state is TrendingLoading || state is TrendingInitial) {
          return _buildSkeleton();
        }
        if (state is TrendingError) {
          return _buildError(context, state.message);
        }
        if (state is TrendingLoaded) {
          return _buildList(context, state.coins);
        }
        if (state is TrendingRateLimited) {
          if (state.staleCoins != null && state.staleCoins!.isNotEmpty) {
            return Column(
              children: [
                _buildRateLimitBanner(context, state.retryAfterSeconds),
                Expanded(child: _buildList(context, state.staleCoins!)),
              ],
            );
          }
          return _buildRateLimitView(context, state.retryAfterSeconds);
        }
        return const SizedBox();
      },
    );
  }

  // ── List ────────────────────────────────────────────────────────────────────

  Widget _buildList(BuildContext context, List<TrendingCoinItem> coins) {
    return RefreshIndicator(
      onRefresh: () => context.read<TrendingCubit>().fetchTrending(),
      color: AppColors.primary,
      backgroundColor: const Color(0xFF1E2329),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          _buildSectionHeader(context),
          ...coins.asMap().entries.map(
                (e) => _TrendingCoinTile(
                  coin: e.value,
                  rank: e.key + 1,
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
      child: Row(
        children: [
          const Text(
            '🔥',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 8),
          const Text(
            'Trending Coins',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Top 15',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Skeleton ─────────────────────────────────────────────────────────────────

  Widget _buildSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 120),
      itemCount: 10,
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: const Color(0xFF1E2329),
          highlightColor: const Color(0xFF2B3139),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 24.0, vertical: 12.0),
            child: Row(
              children: [
                // Rank
                Container(
                    width: 22,
                    height: 14,
                    color: Colors.white,
                    margin: const EdgeInsets.only(right: 12)),
                // Logo
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 14, color: Colors.white),
                      const SizedBox(height: 6),
                      Container(
                          height: 11,
                          width: 60,
                          color: Colors.white),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                        height: 14, width: 70, color: Colors.white),
                    const SizedBox(height: 6),
                    Container(
                        height: 11, width: 50, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Rate-limit views ───────────────────────────────────────────────────────

  Widget _buildRateLimitView(BuildContext context, int seconds) {
    final mm = (seconds ~/ 60).toString().padLeft(2, '0');
    final ss = (seconds % 60).toString().padLeft(2, '0');
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1E2329),
                border: Border.all(
                  color: AppColors.warning.withOpacity(0.6),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.hourglass_top_rounded,
                color: AppColors.warning,
                size: 36,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Trending Rate Limiting',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'CoinGecko trending data is temporarily limited.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.warning.withOpacity(0.4),
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer_outlined,
                      color: AppColors.warning, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Retrying in $mm:$ss',
                    style: const TextStyle(
                      color: AppColors.warning,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.read<TrendingCubit>().fetchTrending(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary),
              child: const Text('Retry Now',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateLimitBanner(BuildContext context, int seconds) {
    final mm = (seconds ~/ 60).toString().padLeft(2, '0');
    final ss = (seconds % 60).toString().padLeft(2, '0');
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.warning.withOpacity(0.4),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.hourglass_top_rounded,
              color: AppColors.warning, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Showing cached trending. Retrying in $mm:$ss…',
              style: const TextStyle(
                color: AppColors.warning,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => context.read<TrendingCubit>().fetchTrending(),
            child: const Text(
              'Retry',
              style: TextStyle(
                color: AppColors.warning,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Error ─────────────────────────────────────────────────────────────────

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 48),
          const SizedBox(height: 16),
          const Text(
            'Failed to load trending coins',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<TrendingCubit>().fetchTrending(),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary),
            child: const Text('Retry',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ── Tile ───────────────────────────────────────────────────────────────────────

class _TrendingCoinTile extends StatelessWidget {
  final TrendingCoinItem coin;
  final int rank;

  const _TrendingCoinTile({required this.coin, required this.rank});

  @override
  Widget build(BuildContext context) {
    final changeColor =
        coin.isPositive ? AppColors.priceGreen : AppColors.priceRed;

    final priceFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: coin.price < 1 ? (coin.price < 0.001 ? 6 : 4) : 2,
    );

    final changeStr = coin.priceChangePercentage24h >= 0
        ? '+${coin.priceChangePercentage24h.toStringAsFixed(2)}%'
        : '${coin.priceChangePercentage24h.toStringAsFixed(2)}%';

    return InkWell(
      onTap: () => context.push(
        AppRouter.trades,
        extra: {
          'coinId': coin.id,
          'symbol': coin.symbol,
          'name': coin.name,
          'logoUrl': coin.thumbUrl,
        },
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 24.0, vertical: 12.0),
        child: Row(
          children: [
            // ── Rank Badge ───────────────────────────────────────────
            _RankBadge(rank: rank),
            const SizedBox(width: 12),

            // ── Logo ─────────────────────────────────────────────────
            CachedNetworkImage(
              imageUrl: coin.thumbUrl,
              width: 40,
              height: 40,
              placeholder: (_, __) => Shimmer.fromColors(
                baseColor: const Color(0xFF1E2329),
                highlightColor: const Color(0xFF2B3139),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              errorWidget: (_, __, ___) =>
                  const Icon(Icons.error, color: AppColors.error),
            ),
            const SizedBox(width: 12),

            // ── Name + Symbol + Market Cap Rank ───────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          coin.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (coin.marketCapRank != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color:
                                AppColors.textSecondary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '#${coin.marketCapRank}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ],
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

            // ── Price + Change ────────────────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  coin.price > 0
                      ? priceFormat.format(coin.price)
                      : '--',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: changeColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    changeStr,
                    style: TextStyle(
                      color: changeColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Rank Badge ─────────────────────────────────────────────────────────────────

class _RankBadge extends StatelessWidget {
  final int rank;

  const _RankBadge({required this.rank});

  @override
  Widget build(BuildContext context) {
    // Top 3 get fire emoji
    if (rank <= 3) {
      const emojis = ['🥇', '🥈', '🥉'];
      return SizedBox(
        width: 28,
        child: Text(
          emojis[rank - 1],
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      );
    }

    return SizedBox(
      width: 28,
      child: Text(
        '$rank',
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
