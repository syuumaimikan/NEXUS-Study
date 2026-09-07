import 'package:flutter/material.dart';

class EnzymeKineticsLabWidget extends StatefulWidget {
  const EnzymeKineticsLabWidget({super.key});

  @override
  State<EnzymeKineticsLabWidget> createState() => _EnzymeKineticsLabWidgetState();
}

class _EnzymeKineticsLabWidgetState extends State<EnzymeKineticsLabWidget> {
  double _substrateConcentration = 15.0; // mM [S]
  final double _vMax = 100.0; // Vmax
  final double _km = 10.0; // Km constant
  bool _hasInhibitor = false;

  @override
  Widget build(BuildContext context) {
    // Michaelis-Menten Equation: v = (Vmax * [S]) / (Km + [S])
    final effectiveKm = _hasInhibitor ? _km * 2.5 : _km; // Competitive inhibition increases apparent Km
    final velocity = (_vMax * _substrateConcentration) / (effectiveKm + _substrateConcentration);

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
                    Icon(Icons.biotech, color: Color(0xFF38BDF8), size: 18),
                    SizedBox(width: 8),
                    Text('酵素反応速度論 (ミカエリス・メンテン)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '反応速度 v = (V_max [S]) / (K_m + [S])\n現在速度: v = ${velocity.toStringAsFixed(1)} μmol/min  (最大速度 V_max の ${(velocity / _vMax * 100).toStringAsFixed(1)}%)',
                  style: const TextStyle(fontSize: 11, color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Kinetics Curve Canvas
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
                painter: _EnzymeCurvePainter(
                  substrate: _substrateConcentration,
                  vMax: _vMax,
                  km: effectiveKm,
                  currentV: velocity,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text('基質濃度 [S]: ${_substrateConcentration.toStringAsFixed(1)} mM', style: const TextStyle(color: Colors.white70, fontSize: 11)),
          Slider(
            value: _substrateConcentration,
            min: 1.0,
            max: 50.0,
            divisions: 49,
            activeColor: const Color(0xFF38BDF8),
            onChanged: (v) => setState(() => _substrateConcentration = v),
          ),

          // Inhibitor toggle
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('競合阻害剤 (インヒビター) を添加', style: TextStyle(color: Colors.white, fontSize: 13)),
            subtitle: const Text('見かけの Km が上昇し、同等の速度達成により多くの基質が必要になります', style: TextStyle(color: Colors.white60, fontSize: 10.5)),
            value: _hasInhibitor,
            activeTrackColor: const Color(0xFFF43F5E),
            onChanged: (v) => setState(() => _hasInhibitor = v),
          ),
        ],
      ),
    );
  }
}

class _EnzymeCurvePainter extends CustomPainter {
  final double substrate;
  final double vMax;
  final double km;
  final double currentV;

  _EnzymeCurvePainter({
    required this.substrate,
    required this.vMax,
    required this.km,
    required this.currentV,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final ox = 35.0;
    final oy = size.height - 30.0;
    final w = size.width - 60.0;
    final h = size.height - 50.0;

    // Axes
    final axisPaint = Paint()..color = Colors.white24..strokeWidth = 1.0;
    canvas.drawLine(Offset(ox, oy), Offset(ox + w, oy), axisPaint);
    canvas.drawLine(Offset(ox, oy), Offset(ox, oy - h), axisPaint);

    // Vmax asymptote
    final vmaxPaint = Paint()..color = const Color(0xFFF43F5E).withValues(alpha: 0.5)..strokeWidth = 1;
    canvas.drawLine(Offset(ox, oy - h), Offset(ox + w, oy - h), vmaxPaint);

    // Curve
    final curvePaint = Paint()..color = const Color(0xFF34D399)..strokeWidth = 2.5..style = PaintingStyle.stroke;
    final path = Path();

    const maxS = 50.0;
    for (int i = 0; i <= 50; i++) {
      final s = i.toDouble();
      final v = (vMax * s) / (km + s);
      final px = ox + (s / maxS) * w;
      final py = oy - (v / vMax) * h;

      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }
    canvas.drawPath(path, curvePaint);

    // Current point
    final curPx = ox + (substrate / maxS) * w;
    final curPy = oy - (currentV / vMax) * h;

    final dotPaint = Paint()..color = const Color(0xFFFBBF24);
    canvas.drawCircle(Offset(curPx, curPy), 4.5, dotPaint);

    // Drop lines
    final dropPaint = Paint()..color = Colors.white24..strokeWidth = 1;
    canvas.drawLine(Offset(curPx, oy), Offset(curPx, curPy), dropPaint);
    canvas.drawLine(Offset(ox, curPy), Offset(curPx, curPy), dropPaint);

    _drawText(canvas, 'V_max', Offset(ox - 30, oy - h - 6), const Color(0xFFF43F5E));
    _drawText(canvas, '基質濃度 [S]', Offset(ox + w - 50, oy + 8), Colors.white60);
    _drawText(canvas, '反応速度 v', Offset(ox + 6, oy - h - 14), const Color(0xFF34D399));
  }

  void _drawText(Canvas canvas, String text, Offset offset, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _EnzymeCurvePainter oldDelegate) => true;
}
