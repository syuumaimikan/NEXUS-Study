import 'dart:math' as math;
import 'package:flutter/material.dart';

class QuadraticLabWidget extends StatefulWidget {
  const QuadraticLabWidget({super.key});

  @override
  State<QuadraticLabWidget> createState() => _QuadraticLabWidgetState();
}

class _QuadraticLabWidgetState extends State<QuadraticLabWidget> {
  double _a = 1.0;
  double _b = -2.0;
  double _c = -3.0;

  @override
  Widget build(BuildContext context) {
    if (_a == 0.0) _a = 0.1;

    final vertexX = -_b / (2 * _a);
    final vertexY = _c - (_b * _b) / (4 * _a);
    final discriminant = _b * _b - 4 * _a * _c;

    String rootsText;
    Color dColor;
    if (discriminant > 0) {
      final r1 = (-_b - math.sqrt(discriminant)) / (2 * _a);
      final r2 = (-_b + math.sqrt(discriminant)) / (2 * _a);
      rootsText = 'x = ${r1.toStringAsFixed(2)}, ${r2.toStringAsFixed(2)} (共有点2個)';
      dColor = const Color(0xFF10B981);
    } else if (discriminant == 0) {
      final r = -_b / (2 * _a);
      rootsText = 'x = ${r.toStringAsFixed(2)} (重解・共有点1個)';
      dColor = const Color(0xFFF59E0B);
    } else {
      rootsText = '実数解なし (x軸と共有点を持たない)';
      dColor = const Color(0xFFF43F5E);
    }

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
              border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
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
                painter: _QuadraticGraphPainter(
                  a: _a,
                  b: _b,
                  c: _c,
                  vertexX: vertexX,
                  vertexY: vertexY,
                  discriminant: discriminant,
                ),
                size: Size.infinite,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Analysis Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'y = ${_formatEquation(_a, _b, _c)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF38BDF8),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: dColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: dColor),
                      ),
                      child: Text(
                        'D = ${discriminant.toStringAsFixed(1)}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: dColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '頂点: (${vertexX.toStringAsFixed(2)}, ${vertexY.toStringAsFixed(2)})  |  軸: x = ${vertexX.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  'x軸との交点: $rootsText',
                  style: TextStyle(fontSize: 12, color: dColor),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Sliders
          _buildSlider(
            label: '係数 a (グラフの開き・向き)',
            value: _a,
            min: -3.0,
            max: 3.0,
            divisions: 60,
            onChanged: (val) => setState(() => _a = (val == 0) ? 0.1 : val),
          ),
          _buildSlider(
            label: '係数 b (軸の位置移動)',
            value: _b,
            min: -6.0,
            max: 6.0,
            divisions: 60,
            onChanged: (val) => setState(() => _b = val),
          ),
          _buildSlider(
            label: '係数 c (y切片の上下移動)',
            value: _c,
            min: -6.0,
            max: 6.0,
            divisions: 60,
            onChanged: (val) => setState(() => _c = val),
          ),

          // Reset button
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              icon: const Icon(Icons.refresh, size: 16, color: Color(0xFF38BDF8)),
              label: const Text('デフォルト値に戻す', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 12)),
              onPressed: () => setState(() {
                _a = 1.0;
                _b = -2.0;
                _c = -3.0;
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
              Text(
                value.toStringAsFixed(2),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8)),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF38BDF8),
              thumbColor: const Color(0xFF38BDF8),
              inactiveTrackColor: Colors.white12,
              trackHeight: 3,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  String _formatEquation(double a, double b, double c) {
    String res = '${a.toStringAsFixed(1)}x²';
    if (b >= 0) {
      res += ' + ${b.toStringAsFixed(1)}x';
    } else {
      res += ' - ${(-b).toStringAsFixed(1)}x';
    }
    if (c >= 0) {
      res += ' + ${c.toStringAsFixed(1)}';
    } else {
      res += ' - ${(-c).toStringAsFixed(1)}';
    }
    return res;
  }
}

class _QuadraticGraphPainter extends CustomPainter {
  final double a;
  final double b;
  final double c;
  final double vertexX;
  final double vertexY;
  final double discriminant;

  _QuadraticGraphPainter({
    required this.a,
    required this.b,
    required this.c,
    required this.vertexX,
    required this.vertexY,
    required this.discriminant,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const scale = 20.0; // pixels per unit

    // Grid
    final gridPaint = Paint()
      ..color = const Color(0xFF1E293B).withValues(alpha: 0.6)
      ..strokeWidth = 1;
    for (double x = center.dx % scale; x < size.width; x += scale) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = center.dy % scale; y < size.height; y += scale) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Axes
    final axisPaint = Paint()
      ..color = Colors.white54
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), axisPaint);
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), axisPaint);

    // Parabola path
    final curvePaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    bool first = true;
    for (double px = 0; px <= size.width; px += 2) {
      final mathX = (px - center.dx) / scale;
      final mathY = a * mathX * mathX + b * mathX + c;
      final py = center.dy - (mathY * scale);

      if (first) {
        path.moveTo(px, py);
        first = false;
      } else {
        path.lineTo(px, py);
      }
    }
    canvas.drawPath(path, curvePaint);

    // Axis of symmetry
    final symScreenX = center.dx + vertexX * scale;
    if (symScreenX >= 0 && symScreenX <= size.width) {
      final symPaint = Paint()
        ..color = const Color(0xFFF59E0B).withValues(alpha: 0.5)
        ..strokeWidth = 1.0;
      canvas.drawLine(Offset(symScreenX, 0), Offset(symScreenX, size.height), symPaint);
    }

    // Vertex
    final vertexScreen = Offset(center.dx + vertexX * scale, center.dy - vertexY * scale);
    if (vertexScreen.dx >= 0 && vertexScreen.dx <= size.width && vertexScreen.dy >= 0 && vertexScreen.dy <= size.height) {
      canvas.drawCircle(vertexScreen, 5, Paint()..color = const Color(0xFFF59E0B));
    }

    // Intercepts
    if (discriminant >= 0) {
      final rootPaint = Paint()..color = const Color(0xFF10B981);
      final r1 = (-b - math.sqrt(discriminant)) / (2 * a);
      final r2 = (-b + math.sqrt(discriminant)) / (2 * a);

      final root1Screen = Offset(center.dx + r1 * scale, center.dy);
      final root2Screen = Offset(center.dx + r2 * scale, center.dy);

      if (root1Screen.dx >= 0 && root1Screen.dx <= size.width) {
        canvas.drawCircle(root1Screen, 4, rootPaint);
      }
      if (root2Screen.dx >= 0 && root2Screen.dx <= size.width) {
        canvas.drawCircle(root2Screen, 4, rootPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _QuadraticGraphPainter oldDelegate) {
    return oldDelegate.a != a || oldDelegate.b != b || oldDelegate.c != c;
  }
}
