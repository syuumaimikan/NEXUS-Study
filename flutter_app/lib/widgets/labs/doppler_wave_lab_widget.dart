import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class DopplerWaveLabWidget extends StatefulWidget {
  const DopplerWaveLabWidget({super.key});

  @override
  State<DopplerWaveLabWidget> createState() => _DopplerWaveLabWidgetState();
}

class _DopplerWaveLabWidgetState extends State<DopplerWaveLabWidget> {
  double _mach = 0.5; // 0.0 to 1.4 Mach
  double _sourceX = 100.0;
  bool _isPlaying = true;
  Timer? _timer;
  final List<_Wavefront> _wavefronts = [];
  int _tickCount = 0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!_isPlaying) return;
      setState(() {
        _tickCount++;
        // Move source to the right
        _sourceX += _mach * 3.0;
        if (_sourceX > 320) {
          _sourceX = 40.0;
          _wavefronts.clear();
        }

        // Emit new wave every 8 ticks
        if (_tickCount % 8 == 0) {
          _wavefronts.add(_Wavefront(center: Offset(_sourceX, 100.0), radius: 0.0));
        }

        // Expand existing wavefronts at sound speed (e.g. 3.0 px/tick)
        for (final w in _wavefronts) {
          w.radius += 3.0;
        }

        // Remove old wavefronts
        _wavefronts.removeWhere((w) => w.radius > 260);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vSound = 340.0; // m/s
    final vSource = _mach * vSound;
    final f0 = 440.0; // Hz (A4)
    // Observed frequency in front: f_front = f0 * v / (v - vs)
    final fFront = _mach < 1.0 ? (f0 * vSound / (vSound - vSource)).round() : 9999;
    // Observed frequency behind: f_back = f0 * v / (v + vs)
    final fBack = (f0 * vSound / (vSound + vSource)).round();

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
                  child: const Icon(Icons.bolt, color: Color(0xFF38BDF8), size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ドップラー効果＆音波波面シミュレーター',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '音源の移動速度（マッハ数）に応じた波面圧縮・周波数変化・超音速衝撃波（マッハ錐）の可視化',
                        style: TextStyle(fontSize: 11, color: Colors.white60),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Mach Slider & Controls
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
                      '音源速度: マッハ ${_mach.toStringAsFixed(2)} (${vSource.toStringAsFixed(0)} m/s)',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                    ),
                    IconButton(
                      icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle, color: const Color(0xFF38BDF8), size: 28),
                      onPressed: () {
                        setState(() {
                          _isPlaying = !_isPlaying;
                        });
                      },
                    ),
                  ],
                ),
                Slider(
                  value: _mach,
                  min: 0.0,
                  max: 1.4,
                  divisions: 28,
                  activeColor: _mach >= 1.0 ? const Color(0xFFEF4444) : const Color(0xFF38BDF8),
                  label: 'Mach ${_mach.toStringAsFixed(2)}',
                  onChanged: (val) {
                    setState(() {
                      _mach = val;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildFreqBadge('後方観測周波数', '$fBack Hz', '低音 (波長伸長)', const Color(0xFF38BDF8)),
                    _buildFreqBadge(
                      '前方観測周波数',
                      _mach < 1.0 ? '$fFront Hz' : '衝撃波 (マッハ錐)',
                      _mach < 1.0 ? '高音 (波長圧縮)' : '超音速ソニックブーム',
                      _mach >= 1.0 ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Wavefront CustomPainter Canvas
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CustomPaint(
                painter: _DopplerWavePainter(
                  sourceX: _sourceX,
                  wavefronts: _wavefronts,
                  mach: _mach,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFreqBadge(String label, String value, String sub, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
          Text(sub, style: TextStyle(fontSize: 9, color: color.withValues(alpha: 0.8))),
        ],
      ),
    );
  }
}

class _Wavefront {
  final Offset center;
  double radius;
  _Wavefront({required this.center, required this.radius});
}

class _DopplerWavePainter extends CustomPainter {
  final double sourceX;
  final List<_Wavefront> wavefronts;
  final double mach;

  _DopplerWavePainter({
    required this.sourceX,
    required this.wavefronts,
    required this.mach,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.white10
      ..strokeWidth = 0.8;
    canvas.drawLine(Offset(0, centerY), Offset(size.width, centerY), gridPaint);

    // Draw all wavefronts
    for (final w in wavefronts) {
      final alpha = ((1.0 - (w.radius / 260.0)).clamp(0.1, 0.8));
      final wavePaint = Paint()
        ..color = (mach >= 1.0 ? const Color(0xFFEF4444) : const Color(0xFF38BDF8)).withValues(alpha: alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(Offset(w.center.dx, centerY), w.radius, wavePaint);
    }

    // Mach Cone lines if supersonic (Mach >= 1.0)
    if (mach >= 1.0) {
      final machAngle = math.asin(1.0 / mach);
      final conePaint = Paint()
        ..color = const Color(0xFFFACC15)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      final len = 200.0;
      final dx = len * math.cos(math.pi - machAngle);
      final dy = len * math.sin(machAngle);

      canvas.drawLine(Offset(sourceX, centerY), Offset(sourceX + dx, centerY - dy), conePaint);
      canvas.drawLine(Offset(sourceX, centerY), Offset(sourceX + dx, centerY + dy), conePaint);
    }

    // Draw Sound Source (Ambulance / Aircraft)
    final sourcePaint = Paint()..color = mach >= 1.0 ? const Color(0xFFEF4444) : const Color(0xFFFBBF24);
    canvas.drawCircle(Offset(sourceX, centerY), 7.0, sourcePaint);
    canvas.drawCircle(
      Offset(sourceX, centerY),
      12.0,
      Paint()
        ..color = sourcePaint.color.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _DopplerWavePainter oldDelegate) => true;
}
