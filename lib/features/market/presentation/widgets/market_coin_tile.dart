import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/coin_entity.dart';

class MarketCoinTile extends StatelessWidget {
  final CoinEntity coin;

  const MarketCoinTile({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    final changeColor = coin.isPositive ? AppColors.priceGreen : AppColors.priceRed;

    final priceFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: coin.currentPrice < 1 ? 4 : 2,
    );
    final percentFormat =
        NumberFormat.decimalPattern().changeFormatter(coin.priceChangePercentage24h);

    return InkWell(
      onTap: () {
        context.push(
          AppRouter.trades,
          extra: {
            'coinId': coin.id,
            'symbol': coin.symbol,
            'name': coin.name,
            'logoUrl': coin.image,
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Row(
          children: [
            // ── Coin Logo ─────────────────────────────────────────────────
            CachedNetworkImage(
              imageUrl: coin.image,
              width: 40,
              height: 40,
              placeholder: (context, url) => Shimmer.fromColors(
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
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error, color: AppColors.error),
            ),
            const SizedBox(width: 16),

            // ── Name and Symbol ───────────────────────────────────────────
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coin.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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

            // ── Mini Sparkline ────────────────────────────────────────────
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 40,
                child: _buildSparkline(changeColor),
              ),
            ),

            // ── Price and Change ──────────────────────────────────────────
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    priceFormat.format(coin.currentPrice),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    percentFormat,
                    style: TextStyle(
                      color: changeColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSparkline(Color changeColor) {
    if (coin.sparkline.isEmpty) return const SizedBox();

    final minY = coin.sparkline.reduce((a, b) => a < b ? a : b);
    final maxY = coin.sparkline.reduce((a, b) => a > b ? a : b);
    // Guard against flat line (min == max) which causes an fl_chart assertion.
    final range = maxY - minY;
    final safeMin = range == 0 ? minY - 1 : minY;
    final safeMax = range == 0 ? maxY + 1 : maxY;

    return AbsorbPointer(
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: coin.sparkline.length.toDouble() - 1,
          minY: safeMin,
          maxY: safeMax,
          lineBarsData: [
            LineChartBarData(
              spots: coin.sparkline
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                  .toList(),
              isCurved: true,
              color: changeColor,
              barWidth: 1.5,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: changeColor.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension NumberFormatExtension on NumberFormat {
  String changeFormatter(double value) {
    if (value > 0) return '+${value.toStringAsFixed(2)}%';
    return '${value.toStringAsFixed(2)}%';
  }
}
