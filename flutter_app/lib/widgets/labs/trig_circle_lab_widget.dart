import 'dart:math' as math;
import 'package:flutter/material.dart';

class TrigCircleLabWidget extends StatefulWidget {
  const TrigCircleLabWidget({super.key});

  @override
  State<TrigCircleLabWidget> createState() => _TrigCircleLabWidgetState();
}

class _TrigCircleLabWidgetState extends State<TrigCircleLabWidget> {
  double _degrees = 45.0;

  @override
  Widget build(BuildContext context) {
    final rad = _degrees * math.pi / 180.0;
    final sinVal = math.sin(rad);
    final cosVal = math.cos(rad);
    final isTanUndef = (_degrees == 90 || _degrees == 270);
    final tanVal = isTanUndef ? double.nan : math.tan(rad);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Canvas Card
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF818CF8).withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CustomPaint(
                painter: _TrigUnitCirclePainter(degrees: _degrees),
                size: Size.infinite,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Values Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildValBox('θ', '${_degrees.toStringAsFixed(0)}° (${(rad / math.pi).toStringAsFixed(2)}π rad)', Colors.white),
                    _buildValBox('sin θ (高さ)', sinVal.toStringAsFixed(3), const Color(0xFF38BDF8)),
                  ],
                ),
                const Divider(height: 20, color: Colors.white10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildValBox('cos θ (底辺)', cosVal.toStringAsFixed(3), const Color(0xFF10B981)),
                    _buildValBox('tan θ (傾き)', isTanUndef ? '定義なし (∞)' : tanVal.toStringAsFixed(3), const Color(0xFFF59E0B)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Slider
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('回転角 θ', style: TextStyle(fontSize: 12, color: Colors.white70)),
                    Text(
                      '${_degrees.toStringAsFixed(0)}°',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF818CF8)),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFF818CF8),
                    thumbColor: const Color(0xFF818CF8),
                    inactiveTrackColor: Colors.white12,
                    trackHeight: 3,
                  ),
                  child: Slider(
                    value: _degrees,
                    min: 0,
                    max: 360,
                    divisions: 72,
                    onChanged: (val) => setState(() => _degrees = val),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Preset Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [0.0, 30.0, 45.0, 60.0, 90.0, 120.0, 180.0, 270.0, 360.0].map((deg) {
              final isSelected = (_degrees == deg);
              return ChoiceChip(
                label: Text('${deg.toInt()}°'),
                selected: isSelected,
                selectedColor: const Color(0xFF818CF8),
                backgroundColor: const Color(0xFF1E293B),
                labelStyle: TextStyle(
                  fontSize: 11,
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (_) => setState(() => _degrees = deg),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildValBox(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.white60)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}

class _TrigUnitCirclePainter extends CustomPainter {
  final double degrees;

  _TrigUnitCirclePainter({required this.degrees});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.45, size.height * 0.5);
    final radius = math.min(size.width * 0.35, size.height * 0.42);

    // Axes
    final axisPaint = Paint()
      ..color = Colors.white38
      ..strokeWidth = 1.2;
    canvas.drawLine(Offset(20, center.dy), Offset(size.width - 20, center.dy), axisPaint);
    canvas.drawLine(Offset(center.dx, 15), Offset(center.dx, size.height - 15), axisPaint);

    // Unit circle
    final circlePaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, circlePaint);

    // Angle calculations
    final rad = degrees * math.pi / 180.0;
    final px = center.dx + radius * math.cos(rad);
    final py = center.dy - radius * math.sin(rad);
    final pPoint = Offset(px, py);

    // Angle arc
    final arcRect = Rect.fromCircle(center: center, radius: 25);
    canvas.drawArc(
      arcRect,
      0,
      -rad,
      false,
      Paint()
        ..color = const Color(0xFF818CF8).withValues(alpha: 0.7)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );

    // Hypotenuse line
    canvas.drawLine(
      center,
      pPoint,
      Paint()
        ..color = const Color(0xFF818CF8)
        ..strokeWidth = 2.5,
    );

    // Cosine projection (base)
    canvas.drawLine(
      center,
      Offset(px, center.dy),
      Paint()
        ..color = const Color(0xFF10B981)
        ..strokeWidth = 3,
    );

    // Sine projection (height)
    canvas.drawLine(
      Offset(px, center.dy),
      pPoint,
      Paint()
        ..color = const Color(0xFF38BDF8)
        ..strokeWidth = 3,
    );

    // Tangent line if within bounds
    if (math.cos(rad).abs() > 0.05) {
      final tanLen = radius * math.tan(rad);
      final tanStart = Offset(center.dx + radius, center.dy);
      final tanEnd = Offset(center.dx + radius, center.dy - tanLen);
      canvas.drawLine(
        tanStart,
        tanEnd,
        Paint()
          ..color = const Color(0xFFF59E0B)
          ..strokeWidth = 2,
      );
      canvas.drawCircle(tanEnd, 3, Paint()..color = const Color(0xFFF59E0B));
    }

    // Point P
    canvas.drawCircle(pPoint, 5, Paint()..color = const Color(0xFFF59E0B));

    // Sine wave trace on the right side
    final waveStartX = center.dx + radius + 30;
    if (waveStartX < size.width - 20) {
      final wavePaint = Paint()
        ..color = const Color(0xFF38BDF8).withValues(alpha: 0.5)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

      final wavePath = Path();
      bool first = true;
      for (double x = waveStartX; x < size.width - 10; x += 2) {
        final sampleRad = rad + (x - waveStartX) * 0.05;
        final y = center.dy - radius * math.sin(sampleRad);
        if (first) {
          wavePath.moveTo(x, y);
          first = false;
        } else {
          wavePath.lineTo(x, y);
        }
      }
      canvas.drawPath(wavePath, wavePaint);

      // Connect point P to wave start
      canvas.drawLine(
        pPoint,
        Offset(waveStartX, py),
        Paint()
          ..color = const Color(0xFF38BDF8).withValues(alpha: 0.3)
          ..strokeWidth = 1.0,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TrigUnitCirclePainter oldDelegate) {
    return oldDelegate.degrees != degrees;
  }
}
