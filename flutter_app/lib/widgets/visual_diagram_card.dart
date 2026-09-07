import 'dart:math' as math;
import 'package:flutter/material.dart';

enum DiagramType {
  quadratic,
  trigCircle,
  physicsIncline,
  physicsVtGraph,
  chemistryBohr,
  generalConcept,
}

class VisualDiagramCard extends StatefulWidget {
  final String subjectId;
  final String questionText;
  final String explanation;

  const VisualDiagramCard({
    super.key,
    required this.subjectId,
    required this.questionText,
    required this.explanation,
  });

  @override
  State<VisualDiagramCard> createState() => _VisualDiagramCardState();
}

class _VisualDiagramCardState extends State<VisualDiagramCard> {
  bool _showLabels = true;
  bool _showGrid = true;

  DiagramType _detectType() {
    final text = '${widget.questionText} ${widget.explanation}'.toLowerCase();
    if (widget.subjectId == 'math') {
      if (text.contains('sin') || text.contains('cos') || text.contains('tan') || text.contains('三角') || text.contains('単位円')) {
        return DiagramType.trigCircle;
      }
      return DiagramType.quadratic;
    }
    if (widget.subjectId == 'physics') {
      if (text.contains('v-t') || text.contains('速度') || text.contains('加速度') || text.contains('等加速度')) {
        return DiagramType.physicsVtGraph;
      }
      return DiagramType.physicsIncline;
    }
    if (widget.subjectId == 'chemistry') {
      return DiagramType.chemistryBohr;
    }
    return DiagramType.generalConcept;
  }

  @override
  Widget build(BuildContext context) {
    final type = _detectType();

    String title;
    IconData icon;
    switch (type) {
      case DiagramType.quadratic:
        title = '数式・放物線グラフ可視化';
        icon = Icons.show_chart;
        break;
      case DiagramType.trigCircle:
        title = '三角比・単位円モデル可視化';
        icon = Icons.radio_button_checked;
        break;
      case DiagramType.physicsIncline:
        title = '力学・斜面ベクトル分解図';
        icon = Icons.trending_down;
        break;
      case DiagramType.physicsVtGraph:
        title = '等加速度直線運動 v-t グラフ';
        icon = Icons.timeline;
        break;
      case DiagramType.chemistryBohr:
        title = '原子構造・電子殻モデル';
        icon = Icons.blur_circular;
        break;
      case DiagramType.generalConcept:
        title = '論理構造・概念ダイアグラム';
        icon = Icons.hub;
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF38BDF8), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF38BDF8),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Toggle Grid
                IconButton(
                  icon: Icon(
                    _showGrid ? Icons.grid_on : Icons.grid_off,
                    size: 18,
                    color: _showGrid ? const Color(0xFF38BDF8) : Colors.white38,
                  ),
                  tooltip: 'グリッド切替',
                  visualDensity: VisualDensity.compact,
                  onPressed: () => setState(() => _showGrid = !_showGrid),
                ),
                // Toggle Labels
                IconButton(
                  icon: Icon(
                    _showLabels ? Icons.label : Icons.label_off,
                    size: 18,
                    color: _showLabels ? const Color(0xFF38BDF8) : Colors.white38,
                  ),
                  tooltip: 'ラベル切替',
                  visualDensity: VisualDensity.compact,
                  onPressed: () => setState(() => _showLabels = !_showLabels),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFF1E293B)),

          // Canvas Area
          Container(
            height: 180,
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomPaint(
                painter: _DiagramPainter(
                  type: type,
                  showGrid: _showGrid,
                  showLabels: _showLabels,
                ),
                size: Size.infinite,
              ),
            ),
          ),

          // Caption explanation
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
            child: Text(
              _getCaption(type),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCaption(DiagramType type) {
    switch (type) {
      case DiagramType.quadratic:
        return '【図解】関数 y = ax² + bx + c の頂点 (p, q) および x 軸との交点（解）の配置関係です。軸を基準に対称性を持ちます。';
      case DiagramType.trigCircle:
        return '【図解】単位円 (半径1) において、点 P の x 座標が cosθ、y 座標が sinθ、直線の傾きが tanθ に対応します。';
      case DiagramType.physicsIncline:
        return '【図解】斜面上の物体に働く重力 mg は、斜面平行成分 mg sinθ と斜面垂直成分 mg cosθ に直交分解されます。垂直抗力 N と釣り合います。';
      case DiagramType.physicsVtGraph:
        return '【図解】v-t グラフの傾きは加速度 a を表し、グラフと t 軸で囲まれた台形の面積が移動距離 x に等しくなります。';
      case DiagramType.chemistryBohr:
        return '【図解】ボーアの原子模型。中心の原子核周囲を、内側から K 殻 (最大2個)、L 殻 (最大8個)、M 殻が取り囲む電子配置モデルです。';
      case DiagramType.generalConcept:
        return '【概念図】前提条件から論理的な推論を経て導かれる結論の構造関係を示しています。';
    }
  }
}

class _DiagramPainter extends CustomPainter {
  final DiagramType type;
  final bool showGrid;
  final bool showLabels;

  _DiagramPainter({
    required this.type,
    required this.showGrid,
    required this.showLabels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFF0B1120);
    canvas.drawRect(Offset.zero & size, bgPaint);

    if (showGrid) {
      _drawGrid(canvas, size);
    }

    switch (type) {
      case DiagramType.quadratic:
        _drawQuadratic(canvas, size);
        break;
      case DiagramType.trigCircle:
        _drawTrigCircle(canvas, size);
        break;
      case DiagramType.physicsIncline:
        _drawPhysicsIncline(canvas, size);
        break;
      case DiagramType.physicsVtGraph:
        _drawPhysicsVt(canvas, size);
        break;
      case DiagramType.chemistryBohr:
        _drawChemistryBohr(canvas, size);
        break;
      case DiagramType.generalConcept:
        _drawGeneralConcept(canvas, size);
        break;
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFF1E293B).withValues(alpha: 0.6)
      ..strokeWidth = 1;

    const step = 25.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _drawAxes(Canvas canvas, Size size, Offset center, {String xLabel = 'x', String yLabel = 'y'}) {
    final axisPaint = Paint()
      ..color = Colors.white54
      ..strokeWidth = 1.5;

    // X axis
    canvas.drawLine(Offset(10, center.dy), Offset(size.width - 10, center.dy), axisPaint);
    // Y axis
    canvas.drawLine(Offset(center.dx, size.height - 10), Offset(center.dx, 10), axisPaint);

    if (showLabels) {
      _drawText(canvas, xLabel, Offset(size.width - 20, center.dy + 4), color: Colors.white70);
      _drawText(canvas, yLabel, Offset(center.dx + 6, 8), color: Colors.white70);
      _drawText(canvas, 'O', Offset(center.dx - 12, center.dy + 4), color: Colors.white54);
    }
  }

  void _drawQuadratic(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.45, size.height * 0.65);
    _drawAxes(canvas, size, center);

    // Parabola y = a(x - p)^2 + q
    final curvePaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    const double a = 0.015;
    const double p = 20.0;
    const double q = -40.0; // In inverted screen coordinates

    bool first = true;
    for (double sx = 20; sx < size.width - 20; sx += 2) {
      final dx = sx - center.dx;
      final dy = a * (dx - p) * (dx - p) + q;
      final sy = center.dy + dy;
      if (first) {
        path.moveTo(sx, sy);
        first = false;
      } else {
        path.lineTo(sx, sy);
      }
    }
    canvas.drawPath(path, curvePaint);

    // Vertex
    final vertex = Offset(center.dx + p, center.dy + q);
    final dotPaint = Paint()..color = const Color(0xFFF59E0B);
    canvas.drawCircle(vertex, 4, dotPaint);

    // Axis of symmetry
    final symPaint = Paint()
      ..color = const Color(0xFFF59E0B).withValues(alpha: 0.5)
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(vertex.dx, 15), Offset(vertex.dx, size.height - 15), symPaint);

    if (showLabels) {
      _drawText(canvas, '頂点 (p, q)', Offset(vertex.dx + 6, vertex.dy - 16), color: const Color(0xFFF59E0B), isBold: true);
      _drawText(canvas, '軸 x = p', Offset(vertex.dx + 4, 15), color: const Color(0xFFF59E0B));
      _drawText(canvas, 'y = a(x-p)² + q', Offset(25, 20), color: const Color(0xFF38BDF8), isBold: true);
    }
  }

  void _drawTrigCircle(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.45, size.height * 0.5);
    const double radius = 60.0;

    _drawAxes(canvas, size, center);

    // Circle
    final circlePaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, circlePaint);

    const double angle = math.pi / 4; // 45 deg
    final px = center.dx + radius * math.cos(angle);
    final py = center.dy - radius * math.sin(angle);
    final pPoint = Offset(px, py);

    // Radius line (hypotenuse)
    final hypPaint = Paint()
      ..color = const Color(0xFF818CF8)
      ..strokeWidth = 2;
    canvas.drawLine(center, pPoint, hypPaint);

    // Cosine line (base on x axis)
    final cosPaint = Paint()
      ..color = const Color(0xFF10B981)
      ..strokeWidth = 2.5;
    canvas.drawLine(center, Offset(px, center.dy), cosPaint);

    // Sine line (height)
    final sinPaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 2.5;
    canvas.drawLine(Offset(px, center.dy), pPoint, sinPaint);

    // Point P
    canvas.drawCircle(pPoint, 4, Paint()..color = const Color(0xFFF59E0B));

    if (showLabels) {
      _drawText(canvas, 'P(cosθ, sinθ)', Offset(px + 6, py - 14), color: const Color(0xFFF59E0B), isBold: true);
      _drawText(canvas, 'cosθ', Offset(center.dx + radius * 0.3, center.dy + 4), color: const Color(0xFF10B981), isBold: true);
      _drawText(canvas, 'sinθ', Offset(px + 6, center.dy - radius * 0.4), color: const Color(0xFF38BDF8), isBold: true);
      _drawText(canvas, 'θ = 45°', Offset(center.dx + 14, center.dy - 16), color: Colors.white70);
    }
  }

  void _drawPhysicsIncline(Canvas canvas, Size size) {
    final baseStart = Offset(30, size.height - 30);
    final baseEnd = Offset(size.width - 30, size.height - 30);
    final topPoint = Offset(size.width - 30, 40);

    // Incline triangle
    final rampPath = Path()
      ..moveTo(baseStart.dx, baseStart.dy)
      ..lineTo(baseEnd.dx, baseEnd.dy)
      ..lineTo(topPoint.dx, topPoint.dy)
      ..close();

    final rampPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.fill;
    canvas.drawPath(rampPath, rampPaint);

    final linePaint = Paint()
      ..color = Colors.white54
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(rampPath, linePaint);

    // Block on ramp
    final blockCenter = Offset(baseStart.dx + (topPoint.dx - baseStart.dx) * 0.45, baseStart.dy + (topPoint.dy - baseStart.dy) * 0.45 - 12);
    canvas.drawRect(
      Rect.fromCenter(center: blockCenter, width: 32, height: 22),
      Paint()..color = const Color(0xFF38BDF8),
    );

    // Gravity vector mg (down)
    final mgEnd = Offset(blockCenter.dx, blockCenter.dy + 50);
    _drawArrow(canvas, blockCenter, mgEnd, const Color(0xFFF43F5E), 'mg');

    // Normal force N (perpendicular to ramp)
    final nEnd = Offset(blockCenter.dx - 22, blockCenter.dy - 35);
    _drawArrow(canvas, blockCenter, nEnd, const Color(0xFF10B981), 'N');

    // Parallel component mg sinθ
    final mgSinEnd = Offset(blockCenter.dx - 30, blockCenter.dy + 18);
    _drawArrow(canvas, blockCenter, mgSinEnd, const Color(0xFFF59E0B), 'mg sinθ');

    if (showLabels) {
      _drawText(canvas, '傾斜角 θ', Offset(baseStart.dx + 25, baseStart.dy - 16), color: Colors.white70);
    }
  }

  void _drawPhysicsVt(Canvas canvas, Size size) {
    final center = Offset(40, size.height - 30);
    _drawAxes(canvas, size, center, xLabel: 't (s)', yLabel: 'v (m/s)');

    final p0 = Offset(center.dx, center.dy - 30); // v0
    final p1 = Offset(size.width - 50, center.dy - 110); // v1

    // Shaded area under curve (displacement x)
    final areaPath = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(p0.dx, p0.dy)
      ..lineTo(p1.dx, p1.dy)
      ..lineTo(p1.dx, center.dy)
      ..close();

    canvas.drawPath(
      areaPath,
      Paint()..color = const Color(0xFF38BDF8).withValues(alpha: 0.15),
    );

    // Velocity line
    canvas.drawLine(
      p0,
      p1,
      Paint()
        ..color = const Color(0xFF38BDF8)
        ..strokeWidth = 3,
    );

    if (showLabels) {
      _drawText(canvas, '初速 v₀', Offset(10, p0.dy - 6), color: const Color(0xFFF59E0B));
      _drawText(canvas, '傾き = 加速度 a', Offset(size.width * 0.35, p0.dy - 35), color: const Color(0xFF38BDF8), isBold: true);
      _drawText(canvas, '面積 = 移動距離 x', Offset(size.width * 0.45, center.dy - 20), color: const Color(0xFF10B981), isBold: true);
    }
  }

  void _drawChemistryBohr(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.45, size.height * 0.5);

    // Nucleus
    canvas.drawCircle(center, 14, Paint()..color = const Color(0xFFF43F5E));
    _drawText(canvas, '+6', Offset(center.dx - 8, center.dy - 6), color: Colors.white, isBold: true);

    // K Shell
    const double rK = 35.0;
    canvas.drawCircle(center, rK, Paint()..color = Colors.white24..strokeWidth = 1.2..style = PaintingStyle.stroke);
    _drawElectron(canvas, center, rK, 0);
    _drawElectron(canvas, center, rK, math.pi);

    // L Shell
    const double rL = 60.0;
    canvas.drawCircle(center, rL, Paint()..color = Colors.white24..strokeWidth = 1.2..style = PaintingStyle.stroke);
    _drawElectron(canvas, center, rL, 0);
    _drawElectron(canvas, center, rL, math.pi / 2);
    _drawElectron(canvas, center, rL, math.pi);
    _drawElectron(canvas, center, rL, 3 * math.pi / 2);

    if (showLabels) {
      _drawText(canvas, '原子核 (+6: 炭素 C)', Offset(size.width * 0.65, center.dy - 35), color: const Color(0xFFF43F5E), isBold: true);
      _drawText(canvas, 'K殻: 2個 (満杯)', Offset(size.width * 0.65, center.dy - 10), color: const Color(0xFF38BDF8));
      _drawText(canvas, 'L殻: 4個 (最外殻)', Offset(size.width * 0.65, center.dy + 15), color: const Color(0xFF10B981));
    }
  }

  void _drawElectron(Canvas canvas, Offset center, double r, double angle) {
    final pos = Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
    canvas.drawCircle(pos, 4, Paint()..color = const Color(0xFF38BDF8));
  }

  void _drawGeneralConcept(Canvas canvas, Size size) {
    final n1 = Offset(size.width * 0.2, size.height * 0.5);
    final n2 = Offset(size.width * 0.5, size.height * 0.5);
    final n3 = Offset(size.width * 0.8, size.height * 0.5);

    _drawArrow(canvas, n1, n2, const Color(0xFF38BDF8), '適用');
    _drawArrow(canvas, n2, n3, const Color(0xFF10B981), '帰結');

    _drawNode(canvas, n1, '前提条件', const Color(0xFF1E293B), const Color(0xFF38BDF8));
    _drawNode(canvas, n2, '定理・法則', const Color(0xFF1E293B), const Color(0xFFF59E0B));
    _drawNode(canvas, n3, '解の導出', const Color(0xFF1E293B), const Color(0xFF10B981));
  }

  void _drawNode(Canvas canvas, Offset center, String label, Color bg, Color border) {
    final rect = Rect.fromCenter(center: center, width: 70, height: 32);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(8)), Paint()..color = bg);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(8)), Paint()..color = border..strokeWidth = 1.5..style = PaintingStyle.stroke);
    _drawText(canvas, label, Offset(center.dx - 26, center.dy - 6), color: Colors.white, isBold: true, fontSize: 10);
  }

  void _drawArrow(Canvas canvas, Offset from, Offset to, Color color, String label) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;
    canvas.drawLine(from, to, paint);

    // Arrowhead
    final dx = to.dx - from.dx;
    final dy = to.dy - from.dy;
    final angle = math.atan2(dy, dx);
    const arrowSize = 7.0;

    final p1 = Offset(to.dx - arrowSize * math.cos(angle - math.pi / 6), to.dy - arrowSize * math.sin(angle - math.pi / 6));
    final p2 = Offset(to.dx - arrowSize * math.cos(angle + math.pi / 6), to.dy - arrowSize * math.sin(angle + math.pi / 6));

    final arrowPath = Path()
      ..moveTo(to.dx, to.dy)
      ..lineTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..close();
    canvas.drawPath(arrowPath, Paint()..color = color);

    if (showLabels && label.isNotEmpty) {
      final mid = Offset((from.dx + to.dx) / 2, (from.dy + to.dy) / 2 - 12);
      _drawText(canvas, label, mid, color: color, fontSize: 10, isBold: true);
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset, {Color color = Colors.white, double fontSize = 11, bool isBold = false}) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _DiagramPainter oldDelegate) {
    return oldDelegate.type != type || oldDelegate.showGrid != showGrid || oldDelegate.showLabels != showLabels;
  }
}
