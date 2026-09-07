import 'dart:math' as math;
import 'package:flutter/material.dart';

class PendulumLabWidget extends StatefulWidget {
  const PendulumLabWidget({super.key});

  @override
  State<PendulumLabWidget> createState() => _PendulumLabWidgetState();
}

class _PendulumLabWidgetState extends State<PendulumLabWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _length = 1.0; // m
  double _initialAngle = 30.0; // deg
  final double _gravity = 9.8; // m/s^2

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final period = 2 * math.pi * math.sqrt(_length / _gravity);
    final rad0 = _initialAngle * math.pi / 180;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value * period;
        final omega = math.sqrt(_gravity / _length);
        final theta = rad0 * math.cos(omega * t);
        final velocity = -rad0 * omega * math.sin(omega * t) * _length;

        const mass = 1.0;
        final h = _length * (1 - math.cos(theta));
        final pe = mass * _gravity * h;
        final ke = 0.5 * mass * velocity * velocity;
        final totalE = pe + ke;

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
                        Icon(Icons.waves, color: Color(0xFF38BDF8), size: 18),
                        SizedBox(width: 8),
                        Text('単振り子＆力学的エネルギー保存則', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '周期公式: T = 2π√(L/g) = ${period.toStringAsFixed(2)} 秒\n位置エネルギー U と運動エネルギー K が相互に変換され、力学的エネルギー総量は一定に保存されます。',
                      style: const TextStyle(fontSize: 11, color: Colors.white70, height: 1.4),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Canvas
              Container(
                height: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFF030712),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: CustomPaint(
                    painter: _PendulumPainter(theta: theta, length: _length),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Energy Bars
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF131B2E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildEnergyBar('運動エネルギー K', ke, totalE, const Color(0xFF34D399)),
                    const SizedBox(height: 8),
                    _buildEnergyBar('位置エネルギー U', pe, totalE, const Color(0xFFFBBF24)),
                    const SizedBox(height: 8),
                    _buildEnergyBar('全エネルギー E (一定保存)', totalE, totalE, const Color(0xFF38BDF8)),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Text('振り子の長さ L: ${_length.toStringAsFixed(2)} m', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              Slider(
                value: _length,
                min: 0.5,
                max: 2.0,
                divisions: 15,
                activeColor: const Color(0xFF38BDF8),
                onChanged: (val) => setState(() => _length = val),
              ),

              Text('振幅角度 θ₀: ${_initialAngle.toStringAsFixed(0)}°', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              Slider(
                value: _initialAngle,
                min: 10.0,
                max: 50.0,
                divisions: 8,
                activeColor: const Color(0xFFFBBF24),
                onChanged: (val) => setState(() => _initialAngle = val),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEnergyBar(String label, double val, double maxVal, Color color) {
    final ratio = maxVal > 0 ? (val / maxVal).clamp(0.0, 1.0) : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
            Text('${val.toStringAsFixed(1)} J', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: ratio,
          minHeight: 6,
          backgroundColor: Colors.white12,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }
}

class _PendulumPainter extends CustomPainter {
  final double theta;
  final double length;

  _PendulumPainter({required this.theta, required this.length});

  @override
  void paint(Canvas canvas, Size size) {
    final pivot = Offset(size.width / 2, 25);
    final r = (size.height - 60) * (length / 2.0).clamp(0.4, 1.0);

    final bobX = pivot.dx + r * math.sin(theta);
    final bobY = pivot.dy + r * math.cos(theta);

    // Pivot support
    final pivotPaint = Paint()..color = Colors.white54..strokeWidth = 3;
    canvas.drawLine(Offset(pivot.dx - 30, pivot.dy), Offset(pivot.dx + 30, pivot.dy), pivotPaint);

    // String
    final stringPaint = Paint()..color = const Color(0xFF38BDF8)..strokeWidth = 2;
    canvas.drawLine(pivot, Offset(bobX, bobY), stringPaint);

    // Center dotted line
    final centerPaint = Paint()..color = Colors.white24..strokeWidth = 1;
    canvas.drawLine(pivot, Offset(pivot.dx, pivot.dy + r + 20), centerPaint);

    // Bob
    final bobPaint = Paint()..color = const Color(0xFFFBBF24);
    canvas.drawCircle(Offset(bobX, bobY), 14, bobPaint);

    // Angle Arc
    final arcRect = Rect.fromCircle(center: pivot, radius: 40);
    final arcPaint = Paint()..color = const Color(0xFFF43F5E)..strokeWidth = 1.5..style = PaintingStyle.stroke;
    canvas.drawArc(arcRect, math.pi / 2, theta, false, arcPaint);
  }

  @override
  bool shouldRepaint(covariant _PendulumPainter oldDelegate) =>
      oldDelegate.theta != theta || oldDelegate.length != length;
}
