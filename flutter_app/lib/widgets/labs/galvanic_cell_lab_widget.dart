import 'package:flutter/material.dart';

class GalvanicCellLabWidget extends StatefulWidget {
  const GalvanicCellLabWidget({super.key});

  @override
  State<GalvanicCellLabWidget> createState() => _GalvanicCellLabWidgetState();
}

class _GalvanicCellLabWidgetState extends State<GalvanicCellLabWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isConnected = true;

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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.battery_charging_full, color: Color(0xFF38BDF8), size: 18),
                    SizedBox(width: 8),
                    Text('ダニエル電池＆イオン化傾向モデル', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  '負極 (Zn): Zn → Zn²⁺ + 2e⁻ (酸化反応・Zn板溶解)\n正極 (Cu): Cu²⁺ + 2e⁻ → Cu (還元反応・Cu析出)\n電子 e⁻ は導線を通って Zn極 → Cu極 へ移動し、起電力約 1.1 V を発生します。',
                  style: TextStyle(fontSize: 11, color: Colors.white70, height: 1.45),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Cell Diagram Canvas
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: const Color(0xFF030712),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) => CustomPaint(
                  painter: _CellPainter(progress: _controller.value, isConnected: _isConnected),
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Action Switch
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isConnected ? '回路接続中 (電流放電中 1.10 V)' : '回路切断中 (起電力停止 0.00 V)',
                style: TextStyle(
                  color: _isConnected ? const Color(0xFF34D399) : Colors.white60,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => setState(() => _isConnected = !_isConnected),
                icon: Icon(_isConnected ? Icons.power_settings_new : Icons.play_arrow, size: 16),
                label: Text(_isConnected ? 'スイッチOFF' : 'スイッチON'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isConnected ? const Color(0xFFF43F5E) : const Color(0xFF38BDF8),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CellPainter extends CustomPainter {
  final double progress;
  final bool isConnected;

  _CellPainter({required this.progress, required this.isConnected});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Beaker Left (ZnSO4, Zn electrode)
    final leftBeaker = Rect.fromLTWH(cx - 130, cy - 30, 110, 110);
    final rightBeaker = Rect.fromLTWH(cx + 20, cy - 30, 110, 110);

    final glassPaint = Paint()..color = Colors.white24..strokeWidth = 2..style = PaintingStyle.stroke;
    canvas.drawRRect(RRect.fromRectAndRadius(leftBeaker, const Radius.circular(8)), glassPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(rightBeaker, const Radius.circular(8)), glassPaint);

    // Liquids
    final znSolution = Paint()..color = const Color(0xFF38BDF8).withValues(alpha: 0.15);
    final cuSolution = Paint()..color = const Color(0xFF0284C7).withValues(alpha: 0.35);
    canvas.drawRect(Rect.fromLTWH(cx - 128, cy - 10, 106, 88), znSolution);
    canvas.drawRect(Rect.fromLTWH(cx + 22, cy - 10, 106, 88), cuSolution);

    // Porous Pot in between
    final potPaint = Paint()..color = const Color(0xFFF59E0B).withValues(alpha: 0.5)..strokeWidth = 4;
    canvas.drawLine(Offset(cx - 15, cy - 10), Offset(cx - 15, cy + 80), potPaint);

    // Electrodes
    final znPlate = Paint()..color = const Color(0xFF94A3B8);
    final cuPlate = Paint()..color = const Color(0xFFEA580C);
    canvas.drawRect(Rect.fromLTWH(cx - 95, cy - 45, 18, 100), znPlate);
    canvas.drawRect(Rect.fromLTWH(cx + 77, cy - 45, 18, 100), cuPlate);

    // Wire & Light bulb
    final wirePaint = Paint()..color = const Color(0xFFFBBF24)..strokeWidth = 2..style = PaintingStyle.stroke;
    final wirePath = Path()
      ..moveTo(cx - 86, cy - 45)
      ..lineTo(cx - 86, cy - 75)
      ..lineTo(cx, cy - 75)
      ..lineTo(cx + 86, cy - 75)
      ..lineTo(cx + 86, cy - 45);
    canvas.drawPath(wirePath, wirePaint);

    // Bulb in center of wire
    final bulbPaint = Paint()..color = isConnected ? const Color(0xFFFBBF24) : Colors.white24;
    canvas.drawCircle(Offset(cx, cy - 75), 8, bulbPaint);

    // Flowing electrons
    if (isConnected) {
      final ePaint = Paint()..color = const Color(0xFF38BDF8);
      final eX = (cx - 86) + (172 * progress);
      canvas.drawCircle(Offset(eX, cy - 75), 3, ePaint);
    }

    // Text labels
    _drawText(canvas, '(-) 亜鉛板 Zn', Offset(cx - 120, cy + 85), const Color(0xFF94A3B8));
    _drawText(canvas, '(+) 銅板 Cu', Offset(cx + 35, cy + 85), const Color(0xFFEA580C));
    _drawText(canvas, '素焼き板', Offset(cx - 28, cy - 25), const Color(0xFFF59E0B));
  }

  void _drawText(Canvas canvas, String text, Offset offset, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: 9.5, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _CellPainter oldDelegate) => true;
}
