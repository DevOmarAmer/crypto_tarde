import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routes/app_router.dart';
import '../../../market/presentation/bloc/market_cubit.dart';
import '../../../market/presentation/widgets/market_coin_tile.dart';
import '../../../market/presentation/widgets/market_skeleton_tile.dart';
import '../bloc/favorites_cubit.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.star_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Watchlist',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ── Body ───────────────────────────────────────────────────────────────────

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, favState) {
        if (favState.favoriteCoinIds.isEmpty) {
          return _buildEmptyState(context);
        }

        return BlocBuilder<MarketCubit, MarketState>(
          builder: (context, marketState) {
            if (marketState is MarketInitial || marketState is MarketLoading) {
              return const MarketSkeletonList();
            }

            if (marketState is MarketError) {
              return _buildErrorView(context);
            }

            if (marketState is MarketLoaded) {
              final favCoins = marketState.coins
                  .where((c) => favState.isFavorited(c.id))
                  .toList();

              if (favCoins.isEmpty) {
                return _buildEmptyState(context);
              }

              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 120),
                itemCount: favCoins.length,
                itemBuilder: (context, index) =>
                    MarketCoinTile(coin: favCoins[index]),
              );
            }

            return const SizedBox();
          },
        );
      },
    );
  }

  // ── Empty State ────────────────────────────────────────────────────────────

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.star_outline_rounded,
              color: AppColors.primary.withOpacity(0.6),
              size: 40,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No favorites yet',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the ★ on any coin to add it\nto your watchlist.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => context.go(AppRouter.market),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.explore_outlined,
                color: Colors.white, size: 18),
            label: const Text(
              'Browse Markets',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Error View ─────────────────────────────────────────────────────────────

  Widget _buildErrorView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 48),
          const SizedBox(height: 16),
          const Text(
            'Failed to load market data',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<MarketCubit>().fetchMarketCoins(),
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child:
                const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
