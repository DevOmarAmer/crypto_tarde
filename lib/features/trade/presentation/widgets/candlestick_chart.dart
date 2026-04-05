import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/kline_entity.dart';

/// A full candlestick chart drawn with [CustomPainter].
/// Renders OHLC data as candle bodies + wicks with crosshair on long-press.
class CandlestickChart extends StatefulWidget {
  final List<KlineEntity> klines;

  const CandlestickChart({super.key, required this.klines});

  @override
  State<CandlestickChart> createState() => _CandlestickChartState();
}

class _CandlestickChartState extends State<CandlestickChart> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.klines.isEmpty) {
      return const Center(
        child: Text('No chart data', style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    return Column(
      children: [
        // ── Tooltip bar ──────────────────────────────────────────────────
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: _selectedIndex != null
              ? _OhlcTooltip(kline: widget.klines[_selectedIndex!])
              : _DefaultPriceHeader(klines: widget.klines),
        ),
        const SizedBox(height: 4),

        // ── Chart canvas ─────────────────────────────────────────────────
        Expanded(
          child: GestureDetector(
            onTapDown: (d) => _onTap(d.localPosition),
            onHorizontalDragUpdate: (d) => _onTap(d.localPosition),
            onHorizontalDragEnd: (_) => setState(() => _selectedIndex = null),
            onTapUp: (_) => Future.delayed(
              const Duration(seconds: 2),
              () {
                if (mounted) setState(() => _selectedIndex = null);
              },
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: _CandlePainter(
                    klines: widget.klines,
                    selectedIndex: _selectedIndex,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _onTap(Offset localPosition) {
    if (!mounted) return;
    final klines = widget.klines;
    if (klines.isEmpty) return;

    // Estimate width from mounted context
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final w = renderBox.size.width;

    const paddingH = 8.0;
    final candleW = (w - paddingH * 2) / klines.length;
    final index = ((localPosition.dx - paddingH) / candleW).floor();

    setState(() {
      _selectedIndex = index.clamp(0, klines.length - 1);
    });
  }
}

// ── Painter ──────────────────────────────────────────────────────────────────

class _CandlePainter extends CustomPainter {
  final List<KlineEntity> klines;
  final int? selectedIndex;

  _CandlePainter({required this.klines, this.selectedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    if (klines.isEmpty) return;

    const paddingH = 8.0;
    const paddingV = 12.0;

    // ── Price range ───────────────────────────────────────────────────────
    final allHighs = klines.map((k) => k.high);
    final allLows = klines.map((k) => k.low);
    final maxPrice = allHighs.reduce(max);
    final minPrice = allLows.reduce(min);
    final priceRange = maxPrice - minPrice;
    if (priceRange == 0) return;

    final chartH = size.height - paddingV * 2;
    final chartW = size.width - paddingH * 2;
    final candleW = chartW / klines.length;

    double toY(double price) =>
        paddingV + chartH * (1 - (price - minPrice) / priceRange);

    // ── Grid lines ────────────────────────────────────────────────────────
    final gridPaint = Paint()
      ..color = const Color(0xFF2B3139)
      ..strokeWidth = 0.5;

    for (int i = 0; i <= 4; i++) {
      final y = paddingV + chartH * i / 4;
      canvas.drawLine(
        Offset(paddingH, y),
        Offset(size.width - paddingH, y),
        gridPaint,
      );
      // Price label
      final price = maxPrice - (priceRange * i / 4);
      _drawText(
        canvas,
        _formatPrice(price),
        Offset(paddingH + 2, y - 10),
        const Color(0xFF5E6673),
        9,
      );
    }

    // ── Candles ───────────────────────────────────────────────────────────
    for (int i = 0; i < klines.length; i++) {
      final kline = klines[i];
      final isGreen = kline.close >= kline.open;
      final color = isGreen ? AppColors.priceGreen : AppColors.priceRed;

      final bodyPaint = Paint()..color = color;
      final wickPaint = Paint()
        ..color = color
        ..strokeWidth = 1.0;

      final centerX = paddingH + candleW * i + candleW / 2;
      final bodyLeft = paddingH + candleW * i + candleW * 0.2;
      final bodyRight = paddingH + candleW * (i + 1) - candleW * 0.2;

      final bodyTop = toY(max(kline.open, kline.close));
      final bodyBottom = toY(min(kline.open, kline.close));
      final bodyHeight = (bodyBottom - bodyTop).abs().clamp(1.0, double.infinity);

      // Wick
      canvas.drawLine(
        Offset(centerX, toY(kline.high)),
        Offset(centerX, toY(kline.low)),
        wickPaint,
      );

      // Body
      canvas.drawRect(
        Rect.fromLTWH(bodyLeft, bodyTop, bodyRight - bodyLeft, bodyHeight),
        bodyPaint,
      );
    }

    // ── Crosshair for selected candle ─────────────────────────────────────
    if (selectedIndex != null && selectedIndex! < klines.length) {
      final i = selectedIndex!;
      final centerX = paddingH + candleW * i + candleW / 2;
      final closeY = toY(klines[i].close);

      final crosshairPaint = Paint()
        ..color = AppColors.textSecondary.withValues(alpha: 0.5)
        ..strokeWidth = 0.8
        ..style = PaintingStyle.stroke;

      // Vertical line
      canvas.drawLine(
        Offset(centerX, paddingV),
        Offset(centerX, size.height - paddingV),
        crosshairPaint,
      );
      // Horizontal line
      canvas.drawLine(
        Offset(paddingH, closeY),
        Offset(size.width - paddingH, closeY),
        crosshairPaint,
      );

      // Dot on close
      canvas.drawCircle(
        Offset(centerX, closeY),
        3,
        Paint()..color = AppColors.primary,
      );
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset, Color color, double fontSize) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: fontSize, fontFamily: 'monospace'),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  String _formatPrice(double price) {
    if (price >= 1000) return '\$${(price / 1000).toStringAsFixed(1)}k';
    if (price >= 1) return '\$${price.toStringAsFixed(2)}';
    return '\$${price.toStringAsFixed(4)}';
  }

  @override
  bool shouldRepaint(_CandlePainter oldDelegate) =>
      oldDelegate.klines != klines || oldDelegate.selectedIndex != selectedIndex;
}

// ── Header Widgets ────────────────────────────────────────────────────────────

class _DefaultPriceHeader extends StatelessWidget {
  final List<KlineEntity> klines;
  const _DefaultPriceHeader({required this.klines});

  @override
  Widget build(BuildContext context) {
    final last = klines.last;
    final prev = klines.length > 1 ? klines[klines.length - 2] : last;
    final change = last.close - prev.close;
    final pct = prev.close != 0 ? (change / prev.close) * 100 : 0.0;
    final isUp = change >= 0;
    final color = isUp ? AppColors.priceGreen : AppColors.priceRed;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Text(
            '\$${last.close.toStringAsFixed(last.close < 1 ? 4 : 2)}',
            style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${isUp ? '+' : ''}${pct.toStringAsFixed(2)}%',
              style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _OhlcTooltip extends StatelessWidget {
  final KlineEntity kline;
  const _OhlcTooltip({required this.kline});

  @override
  Widget build(BuildContext context) {
    final isUp = kline.close >= kline.open;
    final color = isUp ? AppColors.priceGreen : AppColors.priceRed;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          _label('O', kline.open, AppColors.textSecondary),
          const SizedBox(width: 10),
          _label('H', kline.high, AppColors.priceGreen),
          const SizedBox(width: 10),
          _label('L', kline.low, AppColors.priceRed),
          const SizedBox(width: 10),
          _label('C', kline.close, color),
        ],
      ),
    );
  }

  Widget _label(String tag, double val, Color c) {
    final str = val >= 1 ? val.toStringAsFixed(2) : val.toStringAsFixed(4);
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$tag ',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
          TextSpan(
            text: str,
            style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
