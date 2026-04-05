import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/di/dependency_injection.dart';
import '../bloc/trade_cubit.dart';
import '../widgets/candlestick_chart.dart';

class TradeScreen extends StatelessWidget {
  final String coinId;
  final String symbol;
  final String name;
  final String logoUrl;

  const TradeScreen({
    super.key,
    required this.coinId,
    required this.symbol,
    required this.name,
    required this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TradeCubit>()..initTrade(coinId, '${symbol}USDT'),
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(title: '$symbol/USDT', showBackButton: true),
              Expanded(
                child: BlocConsumer<TradeCubit, TradeState>(
                  listener: (context, state) {
                    if (state is TradeExecutionSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message), backgroundColor: AppColors.success),
                      );
                    } else if (state is TradeExecutionError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is TradeLoading || state is TradeInitial) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TradeLoaded) {
                      return _buildTradeContent(context, state);
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTradeContent(BuildContext context, TradeLoaded state) {
    return Column(
      children: [
        // Top section: Price
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${state.currentPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.priceGreen,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Could add 24h change here
            ],
          ),
        ),
        
        // Tab bar for intervals
        _buildIntervalSelector(context, state.selectedInterval),
        
        // Chart Area
        Container(
          height: 280,
          color: AppColors.darkSurface,
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: CandlestickChart(klines: state.klines),
        ),

        // Order Book Area
        Expanded(
          child: Row(
            children: [
              // Bids (Green)
              Expanded(
                child: ListView.builder(
                  itemCount: state.orderBook.bids.length,
                  itemBuilder: (context, index) {
                    final bid = state.orderBook.bids[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(bid.price.toStringAsFixed(2), style: const TextStyle(color: AppColors.priceGreen, fontSize: 12)),
                          Text(bid.quantity.toStringAsFixed(4), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Asks (Red)
              Expanded(
                child: ListView.builder(
                  itemCount: state.orderBook.asks.length,
                  itemBuilder: (context, index) {
                    final ask = state.orderBook.asks[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(ask.price.toStringAsFixed(2), style: const TextStyle(color: AppColors.priceRed, fontSize: 12)),
                          Text(ask.quantity.toStringAsFixed(4), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // Bottom Trade Bar
        _buildTradeBottomBar(context, state),
      ],
    );
  }

  Widget _buildIntervalSelector(BuildContext context, String currentInterval) {
    final intervals = ['1m', '5m', '15m', '1h', '4h', '1d'];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: intervals.length,
        itemBuilder: (context, index) {
          final interval = intervals[index];
          final isSelected = currentInterval == interval;
          return GestureDetector(
            onTap: () => context.read<TradeCubit>().changeInterval(interval),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                interval,
                style: TextStyle(
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTradeBottomBar(BuildContext context, TradeLoaded state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Available Balance', style: TextStyle(color: AppColors.textSecondary)),
              Text('\$${state.virtualBalance.toStringAsFixed(2)}', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (state.ownedQuantity <= 0)
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.priceGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      context.read<TradeCubit>().executeBuy(
                        coinId: coinId,
                        symbol: symbol,
                        name: name,
                        logoUrl: logoUrl,
                        quantity: 1.0, // Hardcoded for demo/simplicity
                      );
                    },
                    child: const Text('Buy', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                )
              else
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.priceRed,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      context.read<TradeCubit>().executeSell(
                        coinId: coinId,
                        symbol: symbol,
                        quantity: 1.0, // Hardcoded for demo/simplicity
                      );
                    },
                    child: const Text('Sell', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
