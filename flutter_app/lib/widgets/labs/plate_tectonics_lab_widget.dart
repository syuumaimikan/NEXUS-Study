import 'package:flutter/material.dart';

class PlateTectonicsLabWidget extends StatefulWidget {
  const PlateTectonicsLabWidget({super.key});

  @override
  State<PlateTectonicsLabWidget> createState() => _PlateTectonicsLabWidgetState();
}

class _PlateTectonicsLabWidgetState extends State<PlateTectonicsLabWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
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
                    Icon(Icons.terrain, color: Color(0xFF38BDF8), size: 18),
                    SizedBox(width: 8),
                    Text('プレート沈み込み帯＆海溝・火山フロント', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  '海洋プレート（太平洋プレート等）が大陸プレートの下へ沈み込む境界（海溝）の断面モデルです。\n深さ約100kmで脱水反応によりマグマが発生し、火山フロント（火山帯）を形成します。',
                  style: TextStyle(fontSize: 11, color: Colors.white70, height: 1.45),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Subduction Canvas
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
                  painter: _TectonicsPainter(progress: _controller.value),
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF131B2E), borderRadius: BorderRadius.circular(14)),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('【重要地学ポイント】', style: TextStyle(color: Color(0xFFFBBF24), fontSize: 11, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(
                  '・日本海溝: 太平洋プレートの沈み込み (年間約8〜9cmの移動速度)\n・南海トラフ: フィリピン海プレートの沈み込み\n・和達-ベニオフ帯: 海溝から大陸側に向かって震源が深くなる深発地震面',
                  style: TextStyle(color: Colors.white70, fontSize: 10.5, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TectonicsPainter extends CustomPainter {
  final double progress;

  _TectonicsPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Ocean Water Layer
    final waterPaint = Paint()..color = const Color(0xFF0369A1).withValues(alpha: 0.35);
    canvas.drawRect(Rect.fromLTWH(w * 0.45, 0, w * 0.55, 60), waterPaint);

    // Continental Crust (Left)
    final contPath = Path()
      ..moveTo(0, 50)
      ..lineTo(w * 0.45, 60)
      ..lineTo(w * 0.35, h - 30)
      ..lineTo(0, h - 30)
      ..close();
    final contPaint = Paint()..color = const Color(0xFF78350F).withValues(alpha: 0.6);
    canvas.drawPath(contPath, contPaint);

    // Oceanic Plate (Right, Subducting Left-Down)
    final oceanPlatePath = Path()
      ..moveTo(w * 0.45, 60)
      ..lineTo(w, 60)
      ..lineTo(w, 95)
      ..lineTo(w * 0.45, 95)
      ..lineTo(w * 0.15, h)
      ..lineTo(w * 0.05, h)
      ..lineTo(w * 0.38, 60)
      ..close();
    final platePaint = Paint()..color = const Color(0xFF1E3A8A);
    canvas.drawPath(oceanPlatePath, platePaint);

    // Trench Dip (海溝)
    final trenchX = w * 0.44;
    _drawText(canvas, '海溝 (Trench)', Offset(trenchX - 25, 20), const Color(0xFF38BDF8));

    // Volcano Front on Continental Plate
    final volcanoX = w * 0.22;
    final volcanoPath = Path()
      ..moveTo(volcanoX - 20, 50)
      ..lineTo(volcanoX, 28)
      ..lineTo(volcanoX + 20, 50)
      ..close();
    canvas.drawPath(volcanoPath, Paint()..color = const Color(0xFFDC2626));
    _drawText(canvas, '火山フロント', Offset(volcanoX - 22, 10), const Color(0xFFF87171));

    // Rising Magma bubbles
    final magmaPaint = Paint()..color = const Color(0xFFFBBF24);
    final bubbleY = (h - 50) - (progress * 70);
    canvas.drawCircle(Offset(volcanoX, bubbleY), 3.5, magmaPaint);

    // Subduction arrow
    final arrowPaint = Paint()..color = const Color(0xFF38BDF8)..strokeWidth = 2.0;
    canvas.drawLine(Offset(w * 0.85, 75), Offset(w * 0.70, 75), arrowPaint);
    canvas.drawLine(Offset(w * 0.74, 70), Offset(w * 0.70, 75), arrowPaint);
    canvas.drawLine(Offset(w * 0.74, 80), Offset(w * 0.70, 75), arrowPaint);

    _drawText(canvas, '大陸プレート', Offset(25, 80), Colors.white70);
    _drawText(canvas, '海洋プレート (沈み込み)', Offset(w * 0.60, 105), const Color(0xFF93C5FD));
  }

  void _drawText(Canvas canvas, String text, Offset offset, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: 9.5, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _TectonicsPainter oldDelegate) => true;
}
