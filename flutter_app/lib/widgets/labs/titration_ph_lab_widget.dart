import 'dart:math' as math;
import 'package:flutter/material.dart';

class TitrationPhLabWidget extends StatefulWidget {
  const TitrationPhLabWidget({super.key});

  @override
  State<TitrationPhLabWidget> createState() => _TitrationPhLabWidgetState();
}

class _TitrationPhLabWidgetState extends State<TitrationPhLabWidget> {
  // 0: 強酸×強塩基 (HCl + NaOH), 1: 弱酸×強塩基 (CH3COOH + NaOH), 2: 強酸×弱塩基 (HCl + NH3)
  int _titrationType = 0;
  double _addedVolume = 10.0; // 0 to 25 mL, equivalence point at 10.0 mL
  String _selectedIndicator = 'フェノールフタレイン'; // or 'メチルオレンジ'

  // Compute pH given added volume (0 to 25 mL)
  double _calculatePh(double v) {
    if (_titrationType == 0) {
      // Strong acid + Strong base: 10mL of 0.1M HCl titrated with 0.1M NaOH
      if (v < 9.9) {
        // [H+] = (10 - v)*0.1 / (10 + v)
        final hConc = ((10.0 - v) * 0.1) / (10.0 + v);
        return (-math.log(hConc) / math.ln10).clamp(1.0, 7.0);
      } else if (v <= 10.1) {
        // Steep jump around 10
        return 1.0 + (13.0 - 1.0) * ((v - 9.0) / 2.0).clamp(0.0, 1.0);
      } else {
        // [OH-] = (v - 10)*0.1 / (10 + v)
        final ohConc = ((v - 10.0) * 0.1) / (10.0 + v);
        final poh = (-math.log(ohConc) / math.ln10).clamp(1.0, 7.0);
        return (14.0 - poh).clamp(7.0, 13.0);
      }
    } else if (_titrationType == 1) {
      // Weak acid (CH3COOH, pKa=4.76) + Strong base (NaOH)
      if (v <= 0.1) {
        return 2.88; // Initial weak acid pH
      } else if (v < 9.9) {
        // Henderson-Hasselbalch: pH = 4.76 + log(v / (10 - v))
        final ratio = v / (10.0 - v);
        return (4.76 + (math.log(ratio) / math.ln10)).clamp(2.9, 8.0);
      } else if (v <= 10.1) {
        return 8.7; // Equivalence point pH (basic salt)
      } else {
        final ohConc = ((v - 10.0) * 0.1) / (10.0 + v);
        final poh = (-math.log(ohConc) / math.ln10).clamp(1.0, 7.0);
        return (14.0 - poh).clamp(8.7, 13.0);
      }
    } else {
      // Strong acid + Weak base (NH3, pKb=4.76)
      if (v < 9.9) {
        final hConc = ((10.0 - v) * 0.1) / (10.0 + v);
        return (-math.log(hConc) / math.ln10).clamp(1.0, 5.0);
      } else if (v <= 10.1) {
        return 5.3; // Equivalence point pH (acidic salt)
      } else {
        // Buffer NH4+ / NH3
        final excess = v - 10.0;
        final ratio = excess / 10.0;
        return (9.25 + (math.log(ratio) / math.ln10)).clamp(5.3, 11.2);
      }
    }
  }

  Color _getIndicatorColor(double ph) {
    if (_selectedIndicator == 'フェノールフタレイン') {
      if (ph < 8.0) return const Color(0x3338BDF8); // almost clear/water
      if (ph > 9.8) return const Color(0xFFF43F5E); // vivid red-violet
      final t = (ph - 8.0) / 1.8;
      return Color.lerp(const Color(0x3338BDF8), const Color(0xFFF43F5E), t)!;
    } else {
      // Methyl Orange (3.1 Red - 4.4 Yellow)
      if (ph < 3.1) return const Color(0xFFEF4444); // red
      if (ph > 4.4) return const Color(0xFFFACC15); // yellow
      final t = (ph - 3.1) / 1.3;
      return Color.lerp(const Color(0xFFEF4444), const Color(0xFFFACC15), t)!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPh = _calculatePh(_addedVolume);
    final liquidColor = _getIndicatorColor(currentPh);

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
                  child: const Icon(Icons.science, color: Color(0xFF10B981), size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '中和滴定pH曲線＆指示薬シミュレーター',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '滴下量とpHジャンプ、フェノールフタレイン／メチルオレンジの変色域をリアルタイム検証',
                        style: TextStyle(fontSize: 11, color: Colors.white60),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Titration Type Selector
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('強酸×強塩基', style: TextStyle(fontSize: 11))),
              ButtonSegment(value: 1, label: Text('弱酸×強塩基', style: TextStyle(fontSize: 11))),
              ButtonSegment(value: 2, label: Text('強酸×弱塩基', style: TextStyle(fontSize: 11))),
            ],
            selected: {_titrationType},
            onSelectionChanged: (val) {
              setState(() {
                _titrationType = val.first;
              });
            },
          ),

          const SizedBox(height: 14),

          // Indicator Selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const Text('指示薬選択:', style: TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text('フェノールフタレイン (8.0〜9.8)'),
                  selected: _selectedIndicator == 'フェノールフタレイン',
                  selectedColor: const Color(0xFFF43F5E).withValues(alpha: 0.3),
                  labelStyle: TextStyle(
                    color: _selectedIndicator == 'フェノールフタレイン' ? const Color(0xFFFDA4AF) : Colors.white60,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedIndicator = 'フェノールフタレイン');
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('メチルオレンジ (3.1〜4.4)'),
                  selected: _selectedIndicator == 'メチルオレンジ',
                  selectedColor: const Color(0xFFEAB308).withValues(alpha: 0.3),
                  labelStyle: TextStyle(
                    color: _selectedIndicator == 'メチルオレンジ' ? const Color(0xFFFACC15) : Colors.white60,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedIndicator = 'メチルオレンジ');
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Beaker & pH display card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: [
                // Beaker illustration
                Container(
                  width: 90,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border.all(color: Colors.white30, width: 2),
                  ),
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    height: (40 + (_addedVolume / 25.0) * 55).clamp(20.0, 100.0),
                    decoration: BoxDecoration(
                      color: liquidColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(14),
                        bottomRight: Radius.circular(14),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${_addedVolume.toStringAsFixed(1)} mL',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                // Numerical readout
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('現在のpH: ', style: TextStyle(fontSize: 13, color: Colors.white70)),
                          Text(
                            currentPh.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: currentPh < 6.5
                                  ? const Color(0xFFEF4444)
                                  : currentPh > 7.5
                                      ? const Color(0xFF38BDF8)
                                      : const Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentPh < 6.5
                            ? '酸性 (pH < 7)'
                            : currentPh > 7.5
                                ? '塩基性 (pH > 7)'
                                : '中性 (pH = 7.00)',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white60),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _addedVolume == 10.0
                            ? '【中和点・当量点に到達！】'
                            : _addedVolume < 10.0
                                ? '中和点まで あと ${(10.0 - _addedVolume).toStringAsFixed(1)} mL'
                                : '塩基が過剰に滴下されています (+${(_addedVolume - 10.0).toStringAsFixed(1)} mL)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _addedVolume == 10.0 ? const Color(0xFFF59E0B) : Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Slider for Titrant addition
          Row(
            children: [
              const Text('滴下量: ', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
              Expanded(
                child: Slider(
                  value: _addedVolume,
                  min: 0.0,
                  max: 20.0,
                  divisions: 200,
                  activeColor: const Color(0xFF38BDF8),
                  label: '${_addedVolume.toStringAsFixed(1)} mL',
                  onChanged: (val) {
                    setState(() {
                      _addedVolume = val;
                    });
                  },
                ),
              ),
              Text(
                '${_addedVolume.toStringAsFixed(1)} mL',
                style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Titration Curve Canvas
          Container(
            height: 220,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
            ),
            child: CustomPaint(
              painter: _TitrationCurvePainter(
                titrationType: _titrationType,
                addedVolume: _addedVolume,
                indicator: _selectedIndicator,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TitrationCurvePainter extends CustomPainter {
  final int titrationType;
  final double addedVolume;
  final String indicator;

  _TitrationCurvePainter({
    required this.titrationType,
    required this.addedVolume,
    required this.indicator,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const leftMargin = 32.0;
    const bottomMargin = 24.0;
    final plotW = size.width - leftMargin - 16;
    final plotH = size.height - bottomMargin - 16;

    // Draw Grid & Axes
    final axisPaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(leftMargin, 16), Offset(leftMargin, 16 + plotH), axisPaint);
    canvas.drawLine(Offset(leftMargin, 16 + plotH), Offset(leftMargin + plotW, 16 + plotH), axisPaint);

    // Indicator transition zone highlight
    final zonePaint = Paint()..style = PaintingStyle.fill;
    if (indicator == 'フェノールフタレイン') {
      final yTop = 16 + plotH * (1.0 - 9.8 / 14.0);
      final yBottom = 16 + plotH * (1.0 - 8.0 / 14.0);
      zonePaint.color = const Color(0xFFF43F5E).withValues(alpha: 0.15);
      canvas.drawRect(Rect.fromLTRB(leftMargin, yTop, leftMargin + plotW, yBottom), zonePaint);
    } else {
      final yTop = 16 + plotH * (1.0 - 4.4 / 14.0);
      final yBottom = 16 + plotH * (1.0 - 3.1 / 14.0);
      zonePaint.color = const Color(0xFFEAB308).withValues(alpha: 0.15);
      canvas.drawRect(Rect.fromLTRB(leftMargin, yTop, leftMargin + plotW, yBottom), zonePaint);
    }

    // Y Axis labels (pH 0, 7, 14)
    for (final ph in [0, 7, 14]) {
      final y = 16 + plotH * (1.0 - ph / 14.0);
      final tp = TextPainter(
        text: TextSpan(text: '$ph', style: const TextStyle(color: Colors.white54, fontSize: 9)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(leftMargin - tp.width - 6, y - tp.height / 2));
    }

    // Draw pH Curve
    final curvePath = Path();
    final curvePaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    Offset? currentPoint;

    for (int i = 0; i <= 200; i++) {
      final v = (i / 200.0) * 20.0;
      double ph;
      if (titrationType == 0) {
        if (v < 9.9) {
          final hConc = ((10.0 - v) * 0.1) / (10.0 + v);
          ph = (-math.log(hConc) / math.ln10).clamp(1.0, 7.0);
        } else if (v <= 10.1) {
          ph = 1.0 + (13.0 - 1.0) * ((v - 9.0) / 2.0).clamp(0.0, 1.0);
        } else {
          final ohConc = ((v - 10.0) * 0.1) / (10.0 + v);
          final poh = (-math.log(ohConc) / math.ln10).clamp(1.0, 7.0);
          ph = (14.0 - poh).clamp(7.0, 13.0);
        }
      } else if (titrationType == 1) {
        if (v <= 0.1) {
          ph = 2.88;
        } else if (v < 9.9) {
          final ratio = v / (10.0 - v);
          ph = (4.76 + (math.log(ratio) / math.ln10)).clamp(2.9, 8.0);
        } else if (v <= 10.1) {
          ph = 8.7;
        } else {
          final ohConc = ((v - 10.0) * 0.1) / (10.0 + v);
          final poh = (-math.log(ohConc) / math.ln10).clamp(1.0, 7.0);
          ph = (14.0 - poh).clamp(8.7, 13.0);
        }
      } else {
        if (v < 9.9) {
          final hConc = ((10.0 - v) * 0.1) / (10.0 + v);
          ph = (-math.log(hConc) / math.ln10).clamp(1.0, 5.0);
        } else if (v <= 10.1) {
          ph = 5.3;
        } else {
          final excess = v - 10.0;
          final ratio = excess / 10.0;
          ph = (9.25 + (math.log(ratio) / math.ln10)).clamp(5.3, 11.2);
        }
      }

      final x = leftMargin + (v / 20.0) * plotW;
      final y = 16 + plotH * (1.0 - (ph / 14.0).clamp(0.0, 1.0));

      if (i == 0) {
        curvePath.moveTo(x, y);
      } else {
        curvePath.lineTo(x, y);
      }

      if ((v - addedVolume).abs() < 0.1) {
        currentPoint = Offset(x, y);
      }
    }

    canvas.drawPath(curvePath, curvePaint);

    // Current pointer dot
    if (currentPoint != null) {
      final pointPaint = Paint()..color = const Color(0xFFFBBF24);
      canvas.drawCircle(currentPoint, 6.0, pointPaint);
      canvas.drawCircle(
        currentPoint,
        10.0,
        Paint()
          ..color = const Color(0xFFFBBF24).withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TitrationCurvePainter oldDelegate) =>
      oldDelegate.titrationType != titrationType ||
      oldDelegate.addedVolume != addedVolume ||
      oldDelegate.indicator != indicator;
}
