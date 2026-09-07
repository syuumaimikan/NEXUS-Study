import 'package:flutter/material.dart';

class LensOpticsLabWidget extends StatefulWidget {
  const LensOpticsLabWidget({super.key});

  @override
  State<LensOpticsLabWidget> createState() => _LensOpticsLabWidgetState();
}

class _LensOpticsLabWidgetState extends State<LensOpticsLabWidget> {
  double _focalLength = 80; // mm
  double _objectDistance = 160; // mm (at 2f initially)
  final double _objectHeight = 40; // mm

  @override
  Widget build(BuildContext context) {
    final a = _objectDistance;
    final f = _focalLength;
    final isInfinite = (a - f).abs() < 1;
    final b = isInfinite ? double.infinity : (a * f) / (a - f);
    final magnification = isInfinite ? 0.0 : (b / a).abs();
    final isVirtual = b < 0;

    String imageType;
    if (isInfinite) {
      imageType = '像はできない (無限遠)';
    } else if (isVirtual) {
      imageType = '虚像・正立・拡大 (虫眼鏡効果)';
    } else if ((a - 2 * f).abs() < 2) {
      imageType = '実像・倒立・等大 (a = 2f)';
    } else if (a > 2 * f) {
      imageType = '実像・倒立・縮小 (カメラ・目の原理)';
    } else {
      imageType = '実像・倒立・拡大 (映写機・プロジェクタ)';
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.camera, color: Color(0xFF38BDF8), size: 20),
                    SizedBox(width: 8),
                    Text(
                      '凸レンズの結像公式＆光線追跡シミュレータ',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '写像公式: 1/a + 1/b = 1/f,  倍率 m = |b|/a\n物体の位置 a を動かして、実像・虚像の光線経路と像の変化を直感観察！',
                  style: TextStyle(fontSize: 11, color: Colors.white70, height: 1.4),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131B2E),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isVirtual ? const Color(0xFFA855F7) : const Color(0xFF34D399)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isVirtual ? Icons.visibility : Icons.lens,
                        size: 16,
                        color: isVirtual ? const Color(0xFFA855F7) : const Color(0xFF34D399),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '像の性質: $imageType',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isVirtual ? const Color(0xFFD8B4FE) : const Color(0xFF6EE7B7),
                          ),
                        ),
                      ),
                      Text(
                        isInfinite ? 'm = ∞' : '倍率: ${magnification.toStringAsFixed(2)}倍',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Optics Canvas
          Container(
            height: 240,
            decoration: BoxDecoration(
              color: const Color(0xFF030712),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CustomPaint(
                painter: _OpticsRayPainter(
                  focalLength: f,
                  objectDistance: a,
                  objectHeight: _objectHeight,
                  imageDistance: b,
                  isVirtual: isVirtual,
                  isInfinite: isInfinite,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Numerical Readouts
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildValueColumn('物体距離 a', '${a.toStringAsFixed(0)} mm', const Color(0xFF38BDF8)),
                _buildValueColumn('焦点距離 f', '${f.toStringAsFixed(0)} mm', const Color(0xFFFBBF24)),
                _buildValueColumn(
                  '像距離 b',
                  isInfinite ? '∞' : '${b.toStringAsFixed(1)} mm',
                  isVirtual ? const Color(0xFFA855F7) : const Color(0xFF34D399),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Sliders
          Text('物体距離 a: ${a.toStringAsFixed(0)} mm', style: const TextStyle(fontSize: 12, color: Colors.white70)),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF38BDF8),
              thumbColor: const Color(0xFF38BDF8),
            ),
            child: Slider(
              value: _objectDistance,
              min: 30,
              max: 260,
              divisions: 230,
              onChanged: (val) => setState(() => _objectDistance = val),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPresetBtn('a > 2f (縮小実像)', 200),
              _buildPresetBtn('a = 2f (等大実像)', 160),
              _buildPresetBtn('f < a < 2f (拡大)', 110),
              _buildPresetBtn('a < f (虚像)', 50),
            ],
          ),

          const SizedBox(height: 14),

          Text('焦点距離 f: ${f.toStringAsFixed(0)} mm', style: const TextStyle(fontSize: 12, color: Colors.white70)),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFFBBF24),
              thumbColor: const Color(0xFFFBBF24),
            ),
            child: Slider(
              value: _focalLength,
              min: 50,
              max: 120,
              divisions: 70,
              onChanged: (val) => setState(() => _focalLength = val),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetBtn(String label, double dist) {
    final isSel = (_objectDistance - dist).abs() < 5;
    return OutlinedButton(
      onPressed: () => setState(() => _objectDistance = dist),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSel ? const Color(0xFF38BDF8).withValues(alpha: 0.2) : Colors.transparent,
        foregroundColor: isSel ? const Color(0xFF38BDF8) : Colors.white70,
        side: BorderSide(color: isSel ? const Color(0xFF38BDF8) : Colors.white24),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label, style: const TextStyle(fontSize: 10)),
    );
  }

  Widget _buildValueColumn(String label, String value, Color col) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white54)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: col)),
      ],
    );
  }
}

class _OpticsRayPainter extends CustomPainter {
  final double focalLength;
  final double objectDistance;
  final double objectHeight;
  final double imageDistance;
  final bool isVirtual;
  final bool isInfinite;

  _OpticsRayPainter({
    required this.focalLength,
    required this.objectDistance,
    required this.objectHeight,
    required this.imageDistance,
    required this.isVirtual,
    required this.isInfinite,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    const scale = 0.8; // px per mm

    // Principal Axis
    final axisPaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(0, cy), Offset(size.width, cy), axisPaint);

    // Convex Lens in Center
    final lensPaint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.6)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx, cy - 80), Offset(cx, cy + 80), lensPaint);

    // Lens double arrowheads
    canvas.drawLine(Offset(cx - 8, cy - 72), Offset(cx, cy - 80), lensPaint);
    canvas.drawLine(Offset(cx + 8, cy - 72), Offset(cx, cy - 80), lensPaint);
    canvas.drawLine(Offset(cx - 8, cy + 72), Offset(cx, cy + 80), lensPaint);
    canvas.drawLine(Offset(cx + 8, cy + 72), Offset(cx, cy + 80), lensPaint);

    // Focal Points F and F'
    final fPx = focalLength * scale;
    final pointPaint = Paint()..color = const Color(0xFFFBBF24);
    canvas.drawCircle(Offset(cx - fPx, cy), 3.5, pointPaint);
    canvas.drawCircle(Offset(cx + fPx, cy), 3.5, pointPaint);
    canvas.drawCircle(Offset(cx - 2 * fPx, cy), 2.5, pointPaint);
    canvas.drawCircle(Offset(cx + 2 * fPx, cy), 2.5, pointPaint);

    _drawText(canvas, 'F', Offset(cx - fPx - 4, cy + 6), const Color(0xFFFBBF24));
    _drawText(canvas, "F'", Offset(cx + fPx - 4, cy + 6), const Color(0xFFFBBF24));
    _drawText(canvas, '2F', Offset(cx - 2 * fPx - 8, cy + 6), Colors.white38);
    _drawText(canvas, "2F'", Offset(cx + 2 * fPx - 8, cy + 6), Colors.white38);

    // Object Arrow
    final objXPx = cx - objectDistance * scale;
    final objYPx = cy - objectHeight * scale;
    final objPaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 3;
    canvas.drawLine(Offset(objXPx, cy), Offset(objXPx, objYPx), objPaint);
    canvas.drawLine(Offset(objXPx - 5, objYPx + 8), Offset(objXPx, objYPx), objPaint);
    canvas.drawLine(Offset(objXPx + 5, objYPx + 8), Offset(objXPx, objYPx), objPaint);
    _drawText(canvas, '物体', Offset(objXPx - 8, objYPx - 16), const Color(0xFF38BDF8));

    // Ray 1: Parallel to axis -> Through right focal point F'
    final ray1Paint = Paint()
      ..color = const Color(0xFFF43F5E).withValues(alpha: 0.8)
      ..strokeWidth = 1.8;
    canvas.drawLine(Offset(objXPx, objYPx), Offset(cx, objYPx), ray1Paint);
    // Extrapolate past lens through F'
    final slope1 = (cy - objYPx) / fPx;
    final ray1End = Offset(size.width, cy + slope1 * (size.width - cx - fPx));
    canvas.drawLine(Offset(cx, objYPx), ray1End, ray1Paint);

    // Ray 2: Through optical center O
    final ray2Paint = Paint()
      ..color = const Color(0xFF10B981).withValues(alpha: 0.8)
      ..strokeWidth = 1.8;
    final slope2 = (cy - objYPx) / (cx - objXPx);
    final ray2End = Offset(size.width, cy + slope2 * (size.width - cx));
    canvas.drawLine(Offset(objXPx, objYPx), ray2End, ray2Paint);

    // Image Arrow if not infinite
    if (!isInfinite) {
      final imgXPx = cx + imageDistance * scale;
      final m = imageDistance / objectDistance;
      final imgYPx = cy + (objectHeight * scale) * m;

      final imgPaint = Paint()
        ..color = isVirtual ? const Color(0xFFA855F7) : const Color(0xFF34D399)
        ..strokeWidth = 3;

      if (imgXPx > 0 && imgXPx < size.width) {
        canvas.drawLine(Offset(imgXPx, cy), Offset(imgXPx, imgYPx), imgPaint);
        // Arrow head
        final headDir = isVirtual ? 1 : -1;
        canvas.drawLine(Offset(imgXPx - 5, imgYPx + 8 * headDir), Offset(imgXPx, imgYPx), imgPaint);
        canvas.drawLine(Offset(imgXPx + 5, imgYPx + 8 * headDir), Offset(imgXPx, imgYPx), imgPaint);

        _drawText(
          canvas,
          isVirtual ? '虚像' : '実像',
          Offset(imgXPx - 8, imgYPx + (isVirtual ? -16 : 8)),
          isVirtual ? const Color(0xFFA855F7) : const Color(0xFF34D399),
        );
      }
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _OpticsRayPainter oldDelegate) =>
      oldDelegate.focalLength != focalLength ||
      oldDelegate.objectDistance != objectDistance ||
      oldDelegate.objectHeight != objectHeight;
}
