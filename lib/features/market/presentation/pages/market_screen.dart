import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/di/dependency_injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/market_cubit.dart';
import '../bloc/trending_cubit.dart';
import '../widgets/market_coin_tile.dart';
import '../widgets/market_skeleton_tile.dart';
import '../widgets/trending_tab.dart';
import '../../domain/entities/coin_entity.dart';

// ── Tab definition ────────────────────────────────────────────────────────────

enum _MarketTab { all, gainers, losers, top, trending }

extension _MarketTabExt on _MarketTab {
  String get label {
    switch (this) {
      case _MarketTab.all:
        return 'All';
      case _MarketTab.gainers:
        return 'Gainers';
      case _MarketTab.losers:
        return 'Losers';
      case _MarketTab.top:
        return 'Top';
      case _MarketTab.trending:
        return '🔥 Hot';
    }
  }

  List<CoinEntity> filter(List<CoinEntity> coins) {
    switch (this) {
      case _MarketTab.all:
        return coins;
      case _MarketTab.gainers:
        return [...coins.where((c) => c.priceChangePercentage24h > 0)]..sort(
            (a, b) => b.priceChangePercentage24h
                .compareTo(a.priceChangePercentage24h),
          );
      case _MarketTab.losers:
        return [...coins.where((c) => c.priceChangePercentage24h < 0)]..sort(
            (a, b) => a.priceChangePercentage24h
                .compareTo(b.priceChangePercentage24h),
          );
      case _MarketTab.top:
        final sorted = [...coins]
          ..sort((a, b) => b.marketCap.compareTo(a.marketCap));
        return sorted.take(10).toList();
      case _MarketTab.trending:
        return []; // handled by TrendingTab widget
    }
  }
}

// ── Screen ────────────────────────────────────────────────────────────────────

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  _MarketTab _selectedTab = _MarketTab.all;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_selectedTab != _MarketTab.all) return;
    final threshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.offset >= threshold) {
      context.read<MarketCubit>().loadMoreCoins();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(),
            _buildTabBar(),
            const SizedBox(height: 8),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  // ── Body ───────────────────────────────────────────────────────────────────

  Widget _buildBody() {
    // Trending has its own cubit and widget
    if (_selectedTab == _MarketTab.trending) {
      return BlocProvider<TrendingCubit>(
        create: (_) => sl<TrendingCubit>(),
        child: const TrendingTab(),
      );
    }

    return BlocBuilder<MarketCubit, MarketState>(
      builder: (context, state) {
        if (state is MarketInitial || state is MarketLoading) {
          return const MarketSkeletonList();
        }

        if (state is MarketError) {
          return _buildErrorView(context);
        }

        if (state is MarketRateLimited) {
          if (state.staleCoins != null && state.staleCoins!.isNotEmpty) {
            final tabCoins = _selectedTab.filter(state.staleCoins!);
            return Column(
              children: [
                _buildRateLimitBanner(context, state.retryAfterSeconds),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 120),
                    itemCount: tabCoins.length,
                    itemBuilder: (_, i) => MarketCoinTile(coin: tabCoins[i]),
                  ),
                ),
              ],
            );
          }
          return _buildRateLimitView(context, state.retryAfterSeconds);
        }

        if (state is MarketLoaded) {
          final baseCoins = state.filteredCoins;
          final tabCoins = _selectedTab.filter(baseCoins);

          if (tabCoins.isEmpty) {
            return Center(
              child: Text(
                state.searchQuery.isNotEmpty
                    ? 'No results for "${state.searchQuery}"'
                    : 'No coins found.',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            );
          }

          final showFooter = _selectedTab == _MarketTab.all;

          return RefreshIndicator(
            onRefresh: () =>
                context.read<MarketCubit>().fetchMarketCoins(),
            color: AppColors.primary,
            backgroundColor: const Color(0xFF1E2329),
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 120),
              itemCount: tabCoins.length + (showFooter ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < tabCoins.length) {
                  return MarketCoinTile(coin: tabCoins[index]);
                }
                return state.isLoadingMore
                    ? _buildLoadMoreIndicator()
                    : _buildAddFavoriteButton();
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  // ── Tab Bar ────────────────────────────────────────────────────────────────
  // Scrollable SingleChildScrollView so all 5 labels fit on small screens.

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: const Color(0xFF0F141A),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _MarketTab.values.map((tab) {
            final isActive = _selectedTab == tab;
            return GestureDetector(
              onTap: () => setState(() => _selectedTab = tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(
                    horizontal: 18.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF1E2329)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  tab.label,
                  style: TextStyle(
                    color: isActive
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight:
                        isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ── Load-more indicator ────────────────────────────────────────────────────

  Widget _buildLoadMoreIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24.0),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  // ── Add Favourite button ───────────────────────────────────────────────────

  Widget _buildAddFavoriteButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: AppColors.textSecondary.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
                color: AppColors.textSecondary,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Add Favorite',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Rate-limit views ───────────────────────────────────────────────────────

  /// Full-screen view when there is no stale data to show.
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
              'Rate Limit Exceeded',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'CoinGecko allows only a limited number of\nrequests per minute on the free plan.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.5,
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
                  const Icon(
                    Icons.timer_outlined,
                    color: AppColors.warning,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Auto-retry in $mm:$ss',
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
              onPressed: () =>
                  context.read<MarketCubit>().fetchMarketCoins(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Retry Now',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Compact amber banner shown above stale coin data.
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
          const Icon(
            Icons.hourglass_top_rounded,
            color: AppColors.warning,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Rate limit – showing cached data. Retrying in $mm:$ss…',
              style: const TextStyle(
                color: AppColors.warning,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => context.read<MarketCubit>().fetchMarketCoins(),
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

  // ── Error view ─────────────────────────────────────────────────────────────

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
            onPressed: () =>
                context.read<MarketCubit>().fetchMarketCoins(),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary),
            child:
                const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
