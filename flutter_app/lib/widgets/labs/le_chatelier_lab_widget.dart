import 'dart:math';
import 'package:flutter/material.dart';

class LeChatelierLabWidget extends StatefulWidget {
  const LeChatelierLabWidget({super.key});

  @override
  State<LeChatelierLabWidget> createState() => _LeChatelierLabWidgetState();
}

class _LeChatelierLabWidgetState extends State<LeChatelierLabWidget> {
  // Reaction 1: 2NO2 (赤褐色, 2mol) <=> N2O4 (無色, 1mol) + 57 kJ
  double _tempC = 25.0; // 0°C to 100°C
  double _pressureAtm = 1.0; // 0.2 to 5.0 atm

  @override
  Widget build(BuildContext context) {
    // Le Chatelier calculation:
    // Higher T favors endothermic (backward -> more NO2, darker brown).
    // Higher P favors fewer moles (forward -> more N2O4, lighter).
    final tempFactor = (_tempC - 25) / 75.0; // -0.33 to 1.0
    final pressureFactor = log(_pressureAtm) / log(5.0); // -1.0 to 1.0

    // Fraction of NO2 (0.0 to 1.0)
    final no2Fraction = (0.35 + (tempFactor * 0.45) - (pressureFactor * 0.25)).clamp(0.05, 0.95);
    final n2o4Fraction = 1.0 - no2Fraction;

    // Flask color: reddish-brown NO2
    final brownAlpha = (no2Fraction * 255).round().clamp(20, 255);
    final gasColor = Color.fromARGB(brownAlpha, 180, 83, 9); // Amber-brown

    String shiftDirection;
    if (tempFactor > 0.1 || pressureFactor < -0.1) {
      shiftDirection = '左へ移動（逆反応進行：NO₂増加）';
    } else if (tempFactor < -0.1 || pressureFactor > 0.1) {
      shiftDirection = '右へ移動（正反応進行：N₂O₄増加）';
    } else {
      shiftDirection = '標準平衡状態';
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.science, color: Color(0xFFF59E0B), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'ルシャトリエの原理 (化学平衡の移動)',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF090D16),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '2NO₂ (赤褐色・気体2mol) ⇄ N₂O₄ (無色・気体1mol) + 57 kJ',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFFBBF24)),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '温度・圧力を変えると、その変化を和らげる向きに平衡が自発的に移動します。\n・加熱 → 吸熱方向（左・赤褐色が濃くなる）\n・加圧 → 分子数が減る方向（右・色が薄くなる）',
                  style: TextStyle(fontSize: 11, color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Simulation Flask Container
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: const Color(0xFF090D16),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                // Flask Graphic
                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Flask Glass Outer
                        Container(
                          width: 140,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: gasColor,
                            border: Border.all(color: Colors.white60, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: gasColor.withValues(alpha: 0.5),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        // Flask Neck
                        Positioned(
                          top: 15,
                          child: Container(
                            width: 32,
                            height: 40,
                            decoration: BoxDecoration(
                              color: gasColor,
                              border: const Border(
                                left: BorderSide(color: Colors.white60, width: 3),
                                right: BorderSide(color: Colors.white60, width: 3),
                                top: BorderSide(color: Colors.white60, width: 4),
                              ),
                            ),
                          ),
                        ),
                        // Label
                        Positioned(
                          bottom: 40,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              no2Fraction > 0.6 ? '濃い赤褐色' : no2Fraction < 0.25 ? 'ほぼ無色' : '薄い褐色',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Concentration Bar Graphs
                Container(
                  width: 150,
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('平衡組成 (mol%)', style: TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('NO₂ (赤褐色)', style: TextStyle(fontSize: 10, color: Color(0xFFF59E0B))),
                          Text('${(no2Fraction * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: no2Fraction,
                        backgroundColor: Colors.white10,
                        color: const Color(0xFFF59E0B),
                        minHeight: 8,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('N₂O₄ (無色)', style: TextStyle(fontSize: 10, color: Color(0xFF38BDF8))),
                          Text('${(n2o4Fraction * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: n2o4Fraction,
                        backgroundColor: Colors.white10,
                        color: const Color(0xFF38BDF8),
                        minHeight: 8,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Shift status readout
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                const Icon(Icons.sync_alt, color: Color(0xFF38BDF8), size: 18),
                const SizedBox(width: 8),
                const Text('現在の平衡移動: ', style: TextStyle(fontSize: 11, color: Colors.white70)),
                Text(shiftDirection, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8))),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Temperature Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('容器の温度 (加熱 ⇄ 冷却)', style: TextStyle(fontSize: 12, color: Colors.white70)),
              Text('${_tempC.toStringAsFixed(1)} °C', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFF43F5E))),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFF43F5E),
              thumbColor: const Color(0xFFF43F5E),
            ),
            child: Slider(
              value: _tempC,
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: (val) => setState(() => _tempC = val),
            ),
          ),

          // Pressure Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('容器の全圧 (加圧・体積圧縮 ⇄ 減圧)', style: TextStyle(fontSize: 12, color: Colors.white70)),
              Text('${_pressureAtm.toStringAsFixed(2)} atm', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8))),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF38BDF8),
              thumbColor: const Color(0xFF38BDF8),
            ),
            child: Slider(
              value: _pressureAtm,
              min: 0.2,
              max: 5.0,
              divisions: 48,
              onChanged: (val) => setState(() => _pressureAtm = val),
            ),
          ),

          const SizedBox(height: 12),

          // Quick Presets
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPresetBtn('氷水で冷却 (0°C)', 0, 1.0),
              _buildPresetBtn('常温常圧 (25°C, 1atm)', 25, 1.0),
              _buildPresetBtn('熱湯で加熱 (100°C)', 100, 1.0),
              _buildPresetBtn('超高圧 (5atm)', 25, 5.0),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetBtn(String label, double temp, double pres) {
    final isSel = (_tempC - temp).abs() < 1 && (_pressureAtm - pres).abs() < 0.1;
    return OutlinedButton(
      onPressed: () => setState(() {
        _tempC = temp;
        _pressureAtm = pres;
      }),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSel ? const Color(0xFFF59E0B).withValues(alpha: 0.2) : Colors.transparent,
        foregroundColor: isSel ? const Color(0xFFFBBF24) : Colors.white70,
        side: BorderSide(color: isSel ? const Color(0xFFFBBF24) : Colors.white24),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label, style: const TextStyle(fontSize: 10)),
    );
  }
}
