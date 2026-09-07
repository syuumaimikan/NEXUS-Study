import 'dart:math' as math;
import 'package:flutter/material.dart';

class NormalDistributionLabWidget extends StatefulWidget {
  const NormalDistributionLabWidget({super.key});

  @override
  State<NormalDistributionLabWidget> createState() => _NormalDistributionLabWidgetState();
}

class _NormalDistributionLabWidgetState extends State<NormalDistributionLabWidget> {
  double _mean = 50.0; // Mean score
  double _stdDev = 10.0; // Sigma
  double _userScore = 65.0; // Target score

  @override
  Widget build(BuildContext context) {
    // T-Score (Deviation Score)
    final z = (_userScore - _mean) / _stdDev;
    final tScore = 50.0 + 10.0 * z;

    // Approximate percentile using Error Function
    final percentile = 0.5 * (1.0 + _erf(z / math.sqrt(2.0))) * 100.0;
    final topPercent = 100.0 - percentile;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E293B)]),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.query_stats, color: Color(0xFF38BDF8), size: 18),
                    SizedBox(width: 8),
                    Text('正規分布＆偏差値・統計学モデル', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '得点: ${_userScore.toStringAsFixed(1)} 点  →  偏差値: ${tScore.toStringAsFixed(1)}\n上位割合: 約 ${topPercent.toStringAsFixed(1)} % (全体の受検生の中で上位に位置)',
                  style: const TextStyle(fontSize: 11, color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Bell Curve Canvas
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFF030712),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: CustomPaint(
                painter: _BellCurvePainter(mean: _mean, stdDev: _stdDev, userScore: _userScore),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text('あなたの素点: ${_userScore.toStringAsFixed(0)} 点', style: const TextStyle(color: Colors.white70, fontSize: 11)),
          Slider(
            value: _userScore,
            min: 20.0,
            max: 100.0,
            divisions: 80,
            activeColor: const Color(0xFFFBBF24),
            onChanged: (v) => setState(() => _userScore = v),
          ),

          Text('平均点 μ: ${_mean.toStringAsFixed(0)} 点', style: const TextStyle(color: Colors.white70, fontSize: 11)),
          Slider(
            value: _mean,
            min: 30.0,
            max: 80.0,
            divisions: 50,
            activeColor: const Color(0xFF38BDF8),
            onChanged: (v) => setState(() => _mean = v),
          ),

          Text('標準偏差 σ: ${_stdDev.toStringAsFixed(1)}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
          Slider(
            value: _stdDev,
            min: 5.0,
            max: 25.0,
            divisions: 20,
            activeColor: const Color(0xFF34D399),
            onChanged: (v) => setState(() => _stdDev = v),
          ),
        ],
      ),
    );
  }

  static double _erf(double x) {
    const a1 = 0.254829592;
    const a2 = -0.284496736;
    const a3 = 1.421413741;
    const a4 = -1.453152027;
    const a5 = 1.061405429;
    const p = 0.3275911;

    final sign = x < 0 ? -1 : 1;
    final absX = x.abs();

    final t = 1.0 / (1.0 + p * absX);
    final y = 1.0 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * math.exp(-absX * absX);
    return sign * y;
  }
}

class _BellCurvePainter extends CustomPainter {
  final double mean;
  final double stdDev;
  final double userScore;

  _BellCurvePainter({required this.mean, required this.stdDev, required this.userScore});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height - 30.0;

    final axisPaint = Paint()..color = Colors.white24..strokeWidth = 1.0;
    canvas.drawLine(Offset(20, cy), Offset(size.width - 20, cy), axisPaint);

    final curvePath = Path();
    final fillPath = Path();

    const xMin = 10.0;
    const xMax = 90.0;
    final scaleX = (size.width - 60) / (xMax - xMin);

    bool first = true;
    for (double score = xMin; score <= xMax; score += 0.5) {
      final px = 30 + (score - xMin) * scaleX;
      final z = (score - mean) / stdDev;
      final pdf = (1.0 / (stdDev * math.sqrt(2 * math.pi))) * math.exp(-0.5 * z * z);
      final py = cy - (pdf * 2800);

      if (first) {
        curvePath.moveTo(px, py);
        fillPath.moveTo(px, cy);
        fillPath.lineTo(px, py);
        first = false;
      } else {
        curvePath.lineTo(px, py);
        if (score <= userScore) {
          fillPath.lineTo(px, py);
        }
      }
    }

    final userPx = 30 + (userScore.clamp(xMin, xMax) - xMin) * scaleX;
    fillPath.lineTo(userPx, cy);
    fillPath.close();

    // Fill shaded area up to userScore
    final fillPaint = Paint()..color = const Color(0xFF38BDF8).withValues(alpha: 0.25);
    canvas.drawPath(fillPath, fillPaint);

    // Curve Line
    final curvePaint = Paint()..color = const Color(0xFF38BDF8)..strokeWidth = 2.5..style = PaintingStyle.stroke;
    canvas.drawPath(curvePath, curvePaint);

    // User Score Indicator Line
    final userLinePaint = Paint()..color = const Color(0xFFFBBF24)..strokeWidth = 2.0;
    canvas.drawLine(Offset(userPx, cy), Offset(userPx, 30), userLinePaint);
    canvas.drawCircle(Offset(userPx, 30), 4, userLinePaint);

    // Labels
    _drawText(canvas, '平均 μ', Offset(cx - 15, cy + 6), Colors.white54);
    _drawText(canvas, 'あなた: ${userScore.toStringAsFixed(0)}点', Offset(userPx - 25, 14), const Color(0xFFFBBF24));
  }

  void _drawText(Canvas canvas, String text, Offset offset, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: 9.5, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _BellCurvePainter oldDelegate) => true;
}
