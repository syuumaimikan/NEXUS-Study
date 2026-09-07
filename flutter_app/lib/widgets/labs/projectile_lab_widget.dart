import 'dart:math' as math;
import 'package:flutter/material.dart';

class ProjectileLabWidget extends StatefulWidget {
  const ProjectileLabWidget({super.key});

  @override
  State<ProjectileLabWidget> createState() => _ProjectileLabWidgetState();
}

class _ProjectileLabWidgetState extends State<ProjectileLabWidget> with SingleTickerProviderStateMixin {
  double _v0 = 25.0; // m/s
  double _angleDeg = 45.0; // degrees
  final double _g = 9.8; // m/s^2

  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _launch() {
    _animController.reset();
    _animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final thetaRad = _angleDeg * math.pi / 180.0;
    final vx = _v0 * math.cos(thetaRad);
    final vy0 = _v0 * math.sin(thetaRad);

    final totalTime = (2 * vy0) / _g;
    final maxHeight = (vy0 * vy0) / (2 * _g);
    final totalRange = (math.pow(_v0, 2) * math.sin(2 * thetaRad)) / _g;

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
              border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
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
                painter: _ProjectilePainter(
                  v0: _v0,
                  thetaRad: thetaRad,
                  g: _g,
                  totalTime: totalTime,
                  maxHeight: maxHeight,
                  totalRange: totalRange,
                  animProgress: _animController.value,
                ),
                size: Size.infinite,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Action Launch Row
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(_animController.isAnimating ? Icons.pause : Icons.play_arrow, size: 20),
                  label: Text(
                    _animController.isAnimating ? '飛翔中...' : '発射シミュレーション',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _launch,
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filledTonal(
                icon: const Icon(Icons.replay, size: 18),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  foregroundColor: Colors.white70,
                ),
                onPressed: () {
                  _animController.reset();
                  setState(() {});
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Theoretical Metrics Card
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
                    _buildMetricBox('水平到達距離 R', '${totalRange.toStringAsFixed(1)} m', const Color(0xFF10B981)),
                    _buildMetricBox('最高点 H', '${maxHeight.toStringAsFixed(1)} m', const Color(0xFF38BDF8)),
                  ],
                ),
                const Divider(height: 20, color: Colors.white10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetricBox('滞空時間 T', '${totalTime.toStringAsFixed(2)} s', const Color(0xFFF59E0B)),
                    _buildMetricBox('初速分解 (vx, vy0)', '${vx.toStringAsFixed(1)}, ${vy0.toStringAsFixed(1)} m/s', Colors.white70),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Sliders
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
                    const Text('射出角度 θ', style: TextStyle(fontSize: 12, color: Colors.white70)),
                    Text(
                      '${_angleDeg.toStringAsFixed(0)}° (最大飛距離は45°)',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFF10B981),
                    thumbColor: const Color(0xFF10B981),
                    inactiveTrackColor: Colors.white12,
                    trackHeight: 3,
                  ),
                  child: Slider(
                    value: _angleDeg,
                    min: 15,
                    max: 75,
                    divisions: 60,
                    onChanged: (val) {
                      setState(() => _angleDeg = val);
                      _animController.reset();
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

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
                    const Text('初速度 v₀', style: TextStyle(fontSize: 12, color: Colors.white70)),
                    Text(
                      '${_v0.toStringAsFixed(0)} m/s',
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
                    value: _v0,
                    min: 10,
                    max: 50,
                    divisions: 40,
                    onChanged: (val) {
                      setState(() => _v0 = val);
                      _animController.reset();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBox(String label, String value, Color color) {
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

class _ProjectilePainter extends CustomPainter {
  final double v0;
  final double thetaRad;
  final double g;
  final double totalTime;
  final double maxHeight;
  final double totalRange;
  final double animProgress;

  _ProjectilePainter({
    required this.v0,
    required this.thetaRad,
    required this.g,
    required this.totalTime,
    required this.maxHeight,
    required this.totalRange,
    required this.animProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final groundY = size.height - 30;
    const originX = 35.0;

    // Background Ground line
    final groundPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..strokeWidth = 3;
    canvas.drawLine(Offset(10, groundY), Offset(size.width - 10, groundY), groundPaint);

    // Dynamic Scale calculation to fit within canvas
    final scaleX = (size.width - originX - 40) / math.max(totalRange, 1.0);
    final scaleY = (groundY - 40) / math.max(maxHeight * 1.3, 1.0);

    // Draw theoretical Trajectory curve
    final curvePaint = Paint()
      ..color = const Color(0xFF10B981).withValues(alpha: 0.6)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path()..moveTo(originX, groundY);
    const int steps = 60;
    for (int i = 1; i <= steps; i++) {
      final t = totalTime * (i / steps);
      final x = v0 * math.cos(thetaRad) * t;
      final y = v0 * math.sin(thetaRad) * t - 0.5 * g * t * t;
      final sx = originX + x * scaleX;
      final sy = groundY - y * scaleY;
      path.lineTo(sx, sy);
    }
    canvas.drawPath(path, curvePaint);

    // Apex marker
    final apexX = originX + (totalRange / 2) * scaleX;
    final apexY = groundY - maxHeight * scaleY;
    canvas.drawCircle(Offset(apexX, apexY), 4, Paint()..color = const Color(0xFF38BDF8));

    // Landing marker
    final landX = originX + totalRange * scaleX;
    canvas.drawCircle(Offset(landX, groundY), 4, Paint()..color = const Color(0xFF10B981));

    // Ball animated position
    final currentT = totalTime * animProgress;
    final currentPhysX = v0 * math.cos(thetaRad) * currentT;
    final currentPhysY = math.max(0.0, v0 * math.sin(thetaRad) * currentT - 0.5 * g * currentT * currentT);

    final ballX = originX + currentPhysX * scaleX;
    final ballY = groundY - currentPhysY * scaleY;

    // Draw ball with glow
    canvas.drawCircle(
      Offset(ballX, ballY),
      8,
      Paint()..color = const Color(0xFFF59E0B).withValues(alpha: 0.4),
    );
    canvas.drawCircle(
      Offset(ballX, ballY),
      5,
      Paint()..color = const Color(0xFFF59E0B),
    );

    // Velocity vector from ball
    final currentVy = v0 * math.sin(thetaRad) - g * currentT;
    final currentVx = v0 * math.cos(thetaRad);
    final vecLen = 20.0 / v0;
    canvas.drawLine(
      Offset(ballX, ballY),
      Offset(ballX + currentVx * vecLen, ballY - currentVy * vecLen),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _ProjectilePainter oldDelegate) {
    return oldDelegate.v0 != v0 ||
        oldDelegate.thetaRad != thetaRad ||
        oldDelegate.animProgress != animProgress;
  }
}
