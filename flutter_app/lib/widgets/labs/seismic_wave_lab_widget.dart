import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class SeismicWaveLabWidget extends StatefulWidget {
  const SeismicWaveLabWidget({super.key});

  @override
  State<SeismicWaveLabWidget> createState() => _SeismicWaveLabWidgetState();
}

class _SeismicWaveLabWidgetState extends State<SeismicWaveLabWidget> {
  double _distanceKm = 120.0; // 30 to 250 km
  double _elapsedSeconds = 0.0;
  bool _isRunning = false;
  Timer? _timer;

  // Speeds in crust
  static const double _vP = 6.5; // km/s (Primary wave)
  static const double _vS = 3.8; // km/s (Secondary wave)

  // Omori coefficient k = (vp * vs) / (vp - vs)
  double get _kConstant => (_vP * _vS) / (_vP - _vS);
  double get _pArrivalTime => _distanceKm / _vP;
  double get _sArrivalTime => _distanceKm / _vS;
  double get _initialTremorDuration => _sArrivalTime - _pArrivalTime;

  @override
  void initState() {
    super.initState();
    _startWave();
  }

  void _startWave() {
    _timer?.cancel();
    _elapsedSeconds = 0.0;
    _isRunning = true;
    _timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (!_isRunning) return;
      setState(() {
        _elapsedSeconds += 0.25; // 0.25s per tick
        if (_elapsedSeconds > 45.0) {
          _elapsedSeconds = 0.0;
        }
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
    final pDist = _elapsedSeconds * _vP;
    final sDist = _elapsedSeconds * _vS;

    final hasPArrived = _elapsedSeconds >= _pArrivalTime;
    final hasSArrived = _elapsedSeconds >= _sArrivalTime;

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
              border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.public, color: Color(0xFF10B981), size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '地震波伝播＆大森公式シミュレーター (地学/理科)',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'P波（縦波）とS波（横波）の速度差、初期微動継続時間 d = kt (大森公式) の伝播アニメーション',
                        style: TextStyle(fontSize: 11, color: Colors.white60),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Hypocenter Distance Slider
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
                      '観測地点の震源距離: ${_distanceKm.toStringAsFixed(0)} km',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                    ),
                    IconButton(
                      icon: Icon(_isRunning ? Icons.pause_circle : Icons.play_circle, color: const Color(0xFF10B981), size: 28),
                      onPressed: () {
                        setState(() {
                          _isRunning = !_isRunning;
                        });
                      },
                    ),
                  ],
                ),
                Slider(
                  value: _distanceKm,
                  min: 40.0,
                  max: 200.0,
                  divisions: 16,
                  activeColor: const Color(0xFF10B981),
                  label: '${_distanceKm.toStringAsFixed(0)} km',
                  onChanged: (val) {
                    setState(() {
                      _distanceKm = val;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard('P波到達時刻', '${_pArrivalTime.toStringAsFixed(1)} 秒', '縦波 (Vp=6.5km/s)', const Color(0xFF38BDF8)),
                    _buildStatCard('S波到達時刻', '${_sArrivalTime.toStringAsFixed(1)} 秒', '横波 (Vs=3.8km/s)', const Color(0xFFF43F5E)),
                    _buildStatCard('初期微動継続時間', '${_initialTremorDuration.toStringAsFixed(1)} 秒', '大森公式 k≒${_kConstant.toStringAsFixed(1)}', const Color(0xFFFBBF24)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Seismic Wave Animation Canvas
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CustomPaint(
                painter: _SeismicWavePainter(
                  distanceKm: _distanceKm,
                  elapsedSeconds: _elapsedSeconds,
                  pDist: pDist,
                  sDist: sDist,
                  hasPArrived: hasPArrived,
                  hasSArrived: hasSArrived,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Seismograph Waveform Simulation
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('観測地点の地震計波形', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text(
                      !hasPArrived
                          ? '静穏期 (未到達)'
                          : !hasSArrived
                              ? '初期微動 (P波による小さな揺れ)'
                              : '主要動 (S波による大きな揺れ)',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: !hasPArrived
                            ? Colors.white38
                            : !hasSArrived
                                ? const Color(0xFF38BDF8)
                                : const Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 60,
                  child: CustomPaint(
                    painter: _SeismogramWaveformPainter(
                      elapsedSeconds: _elapsedSeconds,
                      pArrivalTime: _pArrivalTime,
                      sArrivalTime: _sArrivalTime,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String val, String sub, Color color) {
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

class _SeismicWavePainter extends CustomPainter {
  final double distanceKm;
  final double elapsedSeconds;
  final double pDist;
  final double sDist;
  final bool hasPArrived;
  final bool hasSArrived;

  _SeismicWavePainter({
    required this.distanceKm,
    required this.elapsedSeconds,
    required this.pDist,
    required this.sDist,
    required this.hasPArrived,
    required this.hasSArrived,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final hypocenter = Offset(30.0, size.height / 2);
    final scale = (size.width - 80) / 220.0; // px per km
    final stationX = hypocenter.dx + distanceKm * scale;

    // Draw Ground Line
    final groundPaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), groundPaint);

    // Draw P Wave expanding circle
    final pRadius = pDist * scale;
    final pPaint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(hypocenter, pRadius, pPaint);

    // Draw S Wave expanding circle
    final sRadius = sDist * scale;
    final sPaint = Paint()
      ..color = const Color(0xFFF43F5E).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(hypocenter, sRadius, sPaint);

    // Draw Hypocenter (Star / Red dot)
    final hypoPaint = Paint()..color = const Color(0xFFEF4444);
    canvas.drawCircle(hypocenter, 7.0, hypoPaint);
    final hypoText = TextPainter(
      text: const TextSpan(text: '震源', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    hypoText.paint(canvas, Offset(hypocenter.dx - hypoText.width / 2, hypocenter.dy + 10));

    // Draw Observation Station
    final stationPaint = Paint()
      ..color = hasSArrived
          ? const Color(0xFFEF4444)
          : hasPArrived
              ? const Color(0xFF38BDF8)
              : const Color(0xFF10B981);
    canvas.drawRect(Rect.fromCenter(center: Offset(stationX, size.height / 2), width: 14, height: 14), stationPaint);

    final stationText = TextPainter(
      text: TextSpan(
        text: '観測点 (${distanceKm.toInt()}km)',
        style: TextStyle(color: stationPaint.color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    stationText.paint(canvas, Offset(stationX - stationText.width / 2, size.height / 2 - 20));
  }

  @override
  bool shouldRepaint(covariant _SeismicWavePainter oldDelegate) => true;
}

class _SeismogramWaveformPainter extends CustomPainter {
  final double elapsedSeconds;
  final double pArrivalTime;
  final double sArrivalTime;

  _SeismogramWaveformPainter({
    required this.elapsedSeconds,
    required this.pArrivalTime,
    required this.sArrivalTime,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final path = Path();
    final wavePaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    final maxT = 40.0;
    final w = size.width;

    path.moveTo(0, centerY);

    for (double t = 0; t <= elapsedSeconds && t <= maxT; t += 0.2) {
      final x = (t / maxT) * w;
      double amp = 0.0;
      if (t >= sArrivalTime) {
        // Large S-wave oscillations
        amp = 18.0 * math.sin((t - sArrivalTime) * 8.0);
      } else if (t >= pArrivalTime) {
        // Small P-wave oscillations
        amp = 4.0 * math.sin((t - pArrivalTime) * 12.0);
      }
      path.lineTo(x, centerY + amp);
    }

    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(covariant _SeismogramWaveformPainter oldDelegate) => true;
}
