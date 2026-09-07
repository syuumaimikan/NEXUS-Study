import 'dart:math' as math;
import 'package:flutter/material.dart';

class GasLawsLabWidget extends StatefulWidget {
  const GasLawsLabWidget({super.key});

  @override
  State<GasLawsLabWidget> createState() => _GasLawsLabWidgetState();
}

class _GasLawsLabWidgetState extends State<GasLawsLabWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _temperature = 300.0; // K
  double _volume = 22.4; // L
  final double _mol = 1.0; // mol
  final double _r = 8.314; // J/(mol*K)

  final math.Random _rng = math.Random(42);
  late List<Offset> _particles;
  late List<Offset> _velocities;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 50))..repeat();

    _particles = List.generate(40, (_) => Offset(40 + _rng.nextDouble() * 120, 30 + _rng.nextDouble() * 100));
    _velocities = List.generate(40, (_) => Offset((_rng.nextDouble() - 0.5) * 4, (_rng.nextDouble() - 0.5) * 4));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // PV = nRT -> P = nRT / V (kPa)
    final pressureKPa = (_mol * _r * _temperature) / _volume;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final speedFactor = math.sqrt(_temperature / 300.0);

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
                        Icon(Icons.compress, color: Color(0xFF38BDF8), size: 18),
                        SizedBox(width: 8),
                        Text('理想気体の状態方程式＆分子熱運動', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '状態方程式: PV = nRT (R = 8.31 J/(mol・K))\n気体圧力 P = ${pressureKPa.toStringAsFixed(1)} kPa (分子の器壁への衝突頻度と力に対応)',
                      style: const TextStyle(fontSize: 11, color: Colors.white70, height: 1.4),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Piston Simulation Canvas
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
                    painter: _PistonPainter(
                      volume: _volume,
                      speedFactor: speedFactor,
                      particles: _particles,
                      velocities: _velocities,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Text('絶対温度 T: ${_temperature.toStringAsFixed(0)} K (${(_temperature - 273.15).toStringAsFixed(0)}°C)', style: const TextStyle(color: Colors.white70, fontSize: 11)),
              Slider(
                value: _temperature,
                min: 150.0,
                max: 600.0,
                divisions: 18,
                activeColor: const Color(0xFFF43F5E),
                onChanged: (v) => setState(() => _temperature = v),
              ),

              Text('容器体積 V: ${_volume.toStringAsFixed(1)} L', style: const TextStyle(color: Colors.white70, fontSize: 11)),
              Slider(
                value: _volume,
                min: 10.0,
                max: 45.0,
                divisions: 35,
                activeColor: const Color(0xFF38BDF8),
                onChanged: (v) => setState(() => _volume = v),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PistonPainter extends CustomPainter {
  final double volume;
  final double speedFactor;
  final List<Offset> particles;
  final List<Offset> velocities;

  _PistonPainter({
    required this.volume,
    required this.speedFactor,
    required this.particles,
    required this.velocities,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final pistonRight = cx - 100 + (volume / 45.0) * 200;
    final cylinder = Rect.fromLTWH(cx - 100, cy - 60, (pistonRight - (cx - 100)), 120);

    // Cylinder walls
    final wallPaint = Paint()..color = Colors.white24..strokeWidth = 2.5..style = PaintingStyle.stroke;
    canvas.drawRect(Rect.fromLTWH(cx - 100, cy - 60, 210, 120), wallPaint);

    // Piston Head
    final pistonPaint = Paint()..color = const Color(0xFFF59E0B);
    canvas.drawRect(Rect.fromLTWH(pistonRight - 8, cy - 58, 16, 116), pistonPaint);

    // Gas background
    canvas.drawRect(cylinder, Paint()..color = const Color(0xFF38BDF8).withValues(alpha: 0.1));

    // Gas Particles
    final pPaint = Paint()..color = const Color(0xFF38BDF8);
    for (int i = 0; i < particles.length; i++) {
      var p = particles[i];
      var v = velocities[i] * speedFactor;

      var nx = p.dx + v.dx;
      var ny = p.dy + v.dy;

      // Bounce
      if (nx <= cx - 96 || nx >= pistonRight - 12) {
        velocities[i] = Offset(-velocities[i].dx, velocities[i].dy);
        nx = nx.clamp(cx - 96, pistonRight - 12);
      }
      if (ny <= cy - 56 || ny >= cy + 56) {
        velocities[i] = Offset(velocities[i].dx, -velocities[i].dy);
        ny = ny.clamp(cy - 56, cy + 56);
      }

      particles[i] = Offset(nx, ny);
      canvas.drawCircle(particles[i], 3.0, pPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PistonPainter oldDelegate) => true;
}
