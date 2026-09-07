import 'dart:math' as math;
import 'package:flutter/material.dart';

class AcCircuitLabWidget extends StatefulWidget {
  const AcCircuitLabWidget({super.key});

  @override
  State<AcCircuitLabWidget> createState() => _AcCircuitLabWidgetState();
}

class _AcCircuitLabWidgetState extends State<AcCircuitLabWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _frequency = 50.0; // Hz
  double _resistance = 20.0; // Ohm
  final double _inductance = 0.1; // H
  final double _capacitance = 100.0; // micro F

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final omega = 2 * math.pi * _frequency;
    final cFarad = _capacitance * 1e-6;
    final xl = omega * _inductance;
    final xc = 1 / (omega * cFarad);
    final z = math.sqrt(_resistance * _resistance + (xl - xc) * (xl - xc));
    final fResonance = 1 / (2 * math.pi * math.sqrt(_inductance * cFarad));
    final phaseRad = math.atan2(xl - xc, _resistance);
    final phaseDeg = phaseRad * 180 / math.pi;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final phase = _controller.value * 2 * math.pi;

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
                        Icon(Icons.bolt, color: Color(0xFF38BDF8), size: 18),
                        SizedBox(width: 8),
                        Text('交流RLC直列回路＆共振周波数', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'インピーダンス: Z = √(R² + (ωL - 1/ωC)²) = ${z.toStringAsFixed(1)} Ω\n共振周波数: f₀ = 1/(2π√(LC)) = ${fResonance.toStringAsFixed(1)} Hz (Zが最小＝電流最大)',
                      style: const TextStyle(fontSize: 11, color: Colors.white70, height: 1.4),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Oscilloscope Waveform Canvas
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFF030712),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: CustomPaint(
                    painter: _AcWavePainter(phase: phase, phaseShift: phaseRad),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Readouts
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFF131B2E), borderRadius: BorderRadius.circular(14)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildParam('誘導リアクタンス X_L', '${xl.toStringAsFixed(1)} Ω', const Color(0xFF34D399)),
                    _buildParam('容量リアクタンス X_C', '${xc.toStringAsFixed(1)} Ω', const Color(0xFFFBBF24)),
                    _buildParam('位相差 θ', '${phaseDeg.toStringAsFixed(1)}°', const Color(0xFF38BDF8)),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Text('電源周波数 f: ${_frequency.toStringAsFixed(0)} Hz', style: const TextStyle(color: Colors.white70, fontSize: 11)),
              Slider(
                value: _frequency,
                min: 10.0,
                max: 150.0,
                divisions: 28,
                activeColor: const Color(0xFF38BDF8),
                onChanged: (v) => setState(() => _frequency = v),
              ),

              Text('抵抗 R: ${_resistance.toStringAsFixed(0)} Ω', style: const TextStyle(color: Colors.white70, fontSize: 11)),
              Slider(
                value: _resistance,
                min: 5.0,
                max: 100.0,
                divisions: 19,
                activeColor: const Color(0xFFF43F5E),
                onChanged: (v) => setState(() => _resistance = v),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildParam(String label, String val, Color col) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 9)),
        const SizedBox(height: 2),
        Text(val, style: TextStyle(color: col, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _AcWavePainter extends CustomPainter {
  final double phase;
  final double phaseShift;

  _AcWavePainter({required this.phase, required this.phaseShift});

  @override
  void paint(Canvas canvas, Size size) {
    final cy = size.height / 2;

    // Grid line
    final gridPaint = Paint()..color = Colors.white12..strokeWidth = 1;
    canvas.drawLine(Offset(0, cy), Offset(size.width, cy), gridPaint);

    final vPaint = Paint()..color = const Color(0xFF38BDF8)..strokeWidth = 2.0..style = PaintingStyle.stroke;
    final iPaint = Paint()..color = const Color(0xFFFBBF24)..strokeWidth = 2.0..style = PaintingStyle.stroke;

    final vPath = Path();
    final iPath = Path();

    const points = 100;
    for (int i = 0; i <= points; i++) {
      final x = (i / points) * size.width;
      final rad = (i / points) * 4 * math.pi + phase;
      final vy = cy - 50 * math.sin(rad);
      final iy = cy - 40 * math.sin(rad - phaseShift);

      if (i == 0) {
        vPath.moveTo(x, vy);
        iPath.moveTo(x, iy);
      } else {
        vPath.lineTo(x, vy);
        iPath.lineTo(x, iy);
      }
    }

    canvas.drawPath(vPath, vPaint);
    canvas.drawPath(iPath, iPaint);

    // Labels
    final tp = TextPainter(
      text: const TextSpan(text: '電圧 V (青)  /  電流 I (黄)', style: TextStyle(color: Colors.white70, fontSize: 10)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, const Offset(12, 12));
  }

  @override
  bool shouldRepaint(covariant _AcWavePainter oldDelegate) => true;
}
