import 'package:flutter/material.dart';

class CalculusTangentLabWidget extends StatefulWidget {
  const CalculusTangentLabWidget({super.key});

  @override
  State<CalculusTangentLabWidget> createState() => _CalculusTangentLabWidgetState();
}

class _CalculusTangentLabWidgetState extends State<CalculusTangentLabWidget> {
  final double _a = 1.0;
  double _t = 1.0; // Tangent contact point x = t

  // f(x) = (a/3)*x^3 - x
  double _f(double x) => (_a / 3.0) * x * x * x - x;
  // f'(x) = a*x^2 - 1
  double _fPrime(double x) => _a * x * x - 1.0;

  @override
  Widget build(BuildContext context) {
    final ft = _f(_t);
    final slope = _fPrime(_t);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.calculate, color: Color(0xFF38BDF8), size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '三次関数・微分係数・接線シミュレーター (数学II/III)',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '接点 t を動かして接線の傾き f\'(t) と極大・極小値（増減表）の関係をリアルタイム確認',
                        style: TextStyle(fontSize: 11, color: Colors.white60),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Parameter Sliders
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '接点のx座標 t = ${_t.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                    ),
                    Text(
                      '接点 P(${_t.toStringAsFixed(2)}, ${ft.toStringAsFixed(2)})',
                      style: const TextStyle(fontSize: 12, color: Color(0xFFFBBF24), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Slider(
                  value: _t,
                  min: -2.2,
                  max: 2.2,
                  divisions: 44,
                  activeColor: const Color(0xFFFBBF24),
                  label: 't = ${_t.toStringAsFixed(2)}',
                  onChanged: (val) {
                    setState(() {
                      _t = val;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetricCard('接線の傾き f\'(t)', slope.toStringAsFixed(2), slope > 0 ? '単調増加' : slope < 0 ? '単調減少' : '極値 (傾き0)', slope == 0.0 ? const Color(0xFF10B981) : const Color(0xFF38BDF8)),
                    _buildMetricCard('極大値', '2/3 ≒ 0.67', 'x = -1.00', const Color(0xFFF43F5E)),
                    _buildMetricCard('極小値', '-2/3 ≒ -0.67', 'x = +1.00', const Color(0xFF10B981)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Cubic Function Graph with Tangent Line
          Container(
            height: 240,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CustomPaint(
                painter: _CubicTangentPainter(t: _t, a: _a),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String val, String sub, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          const SizedBox(height: 2),
          Text(val, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
          Text(sub, style: TextStyle(fontSize: 8, color: color.withValues(alpha: 0.8))),
        ],
      ),
    );
  }
}

class _CubicTangentPainter extends CustomPainter {
  final double t;
  final double a;

  _CubicTangentPainter({required this.t, required this.a});

  double _f(double x) => (a / 3.0) * x * x * x - x;
  double _fPrime(double x) => a * x * x - 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    final origin = Offset(size.width / 2, size.height / 2);
    final scaleX = size.width / 5.5; // ~ -2.5 to +2.5
    final scaleY = size.height / 3.5; // ~ -1.7 to +1.7

    // Draw coordinate axes
    final axisPaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(0, origin.dy), Offset(size.width, origin.dy), axisPaint);
    canvas.drawLine(Offset(origin.dx, 0), Offset(origin.dx, size.height), axisPaint);

    // Draw Cubic curve f(x) = (1/3)x^3 - x
    final curvePath = Path();
    final curvePaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    for (int i = -100; i <= 100; i++) {
      final x = (i / 100.0) * 2.5;
      final y = _f(x);

      final screenX = origin.dx + x * scaleX;
      final screenY = origin.dy - y * scaleY;

      if (i == -100) {
        curvePath.moveTo(screenX, screenY);
      } else {
        curvePath.lineTo(screenX, screenY);
      }
    }
    canvas.drawPath(curvePath, curvePaint);

    // Draw Tangent Line: y - f(t) = f'(t)(x - t)
    final ft = _f(t);
    final m = _fPrime(t);

    final tangentPaint = Paint()
      ..color = const Color(0xFFFBBF24)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    final x1 = -2.5;
    final y1 = ft + m * (x1 - t);
    final x2 = 2.5;
    final y2 = ft + m * (x2 - t);

    canvas.drawLine(
      Offset(origin.dx + x1 * scaleX, origin.dy - y1 * scaleY),
      Offset(origin.dx + x2 * scaleX, origin.dy - y2 * scaleY),
      tangentPaint,
    );

    // Draw Contact Point P(t, f(t))
    final pScreen = Offset(origin.dx + t * scaleX, origin.dy - ft * scaleY);
    canvas.drawCircle(pScreen, 6.0, Paint()..color = const Color(0xFFFBBF24));
    canvas.drawCircle(
      pScreen,
      10.0,
      Paint()
        ..color = const Color(0xFFFBBF24).withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Extreme points (x = -1, y = 2/3) and (x = 1, y = -2/3)
    final maxScreen = Offset(origin.dx - 1.0 * scaleX, origin.dy - (2.0 / 3.0) * scaleY);
    final minScreen = Offset(origin.dx + 1.0 * scaleX, origin.dy - (-2.0 / 3.0) * scaleY);

    canvas.drawCircle(maxScreen, 4.0, Paint()..color = const Color(0xFFF43F5E));
    canvas.drawCircle(minScreen, 4.0, Paint()..color = const Color(0xFF10B981));
  }

  @override
  bool shouldRepaint(covariant _CubicTangentPainter oldDelegate) => oldDelegate.t != t || oldDelegate.a != a;
}
