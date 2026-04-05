import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/market_cubit.dart';
import '../widgets/market_coin_tile.dart';
import '../widgets/market_skeleton_tile.dart';
import '../../domain/entities/coin_entity.dart';

// ── Tab definition ────────────────────────────────────────────────────────────

enum _MarketTab { all, gainers, losers, top }

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
    }
  }

  List<CoinEntity> filter(List<CoinEntity> coins) {
    switch (this) {
      case _MarketTab.all:
        return coins;
      case _MarketTab.gainers:
        return [...coins.where((c) => c.priceChangePercentage24h > 0)]..sort(
          (a, b) =>
              b.priceChangePercentage24h.compareTo(a.priceChangePercentage24h),
        );
      case _MarketTab.losers:
        return [...coins.where((c) => c.priceChangePercentage24h < 0)]..sort(
          (a, b) =>
              a.priceChangePercentage24h.compareTo(b.priceChangePercentage24h),
        );
      case _MarketTab.top:
        final sorted = [...coins]
          ..sort((a, b) => b.marketCap.compareTo(a.marketCap));
        return sorted.take(10).toList();
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

  /// Trigger load-more when the user is 200 px from the bottom
  /// (only relevant in the "All" tab where pagination is active).
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_selectedTab != _MarketTab.all)
      return; // no pagination for filtered tabs
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
            Expanded(
              child: BlocBuilder<MarketCubit, MarketState>(
                builder: (context, state) {
                  if (state is MarketInitial || state is MarketLoading) {
                    return const MarketSkeletonList();
                  }

                  if (state is MarketError) {
                    return _buildErrorView(context);
                  }

                  if (state is MarketLoaded) {
                    // Apply search filter first, then tab filter.
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

                    // Pagination footer only makes sense for the "All" tab.
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
                          // Footer (only in "All" tab)
                          return state.isLoadingMore
                              ? _buildLoadMoreIndicator()
                              : _buildAddFavoriteButton();
                        },
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Tab Bar ────────────────────────────────────────────────────────────────

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: const Color(0xFF0F141A),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: _MarketTab.values.map((tab) {
          final isActive = _selectedTab == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF1E2329)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  tab.label,
                  style: TextStyle(
                    color: isActive
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── "Load more" spinner ────────────────────────────────────────────────────

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
            onPressed: () => context.read<MarketCubit>().fetchMarketCoins(),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
