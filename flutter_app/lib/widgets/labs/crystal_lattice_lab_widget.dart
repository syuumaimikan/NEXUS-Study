import 'dart:math';
import 'package:flutter/material.dart';

class CrystalLatticeLabWidget extends StatefulWidget {
  const CrystalLatticeLabWidget({super.key});

  @override
  State<CrystalLatticeLabWidget> createState() => _CrystalLatticeLabWidgetState();
}

class _CrystalLatticeLabWidgetState extends State<CrystalLatticeLabWidget> {
  int _selectedType = 0; // 0: BCC, 1: FCC, 2: NaCl
  double _rotX = 0.4;
  double _rotY = 0.6;

  @override
  Widget build(BuildContext context) {
    String name;
    String count;
    String coord;
    String packing;
    String relation;
    String examples;

    if (_selectedType == 0) {
      name = '体心立方格子 (BCC)';
      count = '2 個 (頂点 1/8×8 + 中心 1)';
      coord = '8 (最も近い隣接原子数)';
      packing = '68 % (π√3 / 8)';
      relation = '√3 a = 4r  (r = √3/4 a)';
      examples = 'Fe (α鉄), Na, K, Ba';
    } else if (_selectedType == 1) {
      name = '面心立方格子 (FCC)';
      count = '4 個 (頂点 1/8×8 + 各面心 1/2×6)';
      coord = '12 (立方最密構造)';
      packing = '74 % (π√2 / 6)';
      relation = '√2 a = 4r  (r = √2/4 a)';
      examples = 'Cu, Al, Ag, Au, Fe (γ鉄)';
    } else {
      name = '塩化ナトリウム型 (NaCl)';
      count = 'Na⁺: 4個, Cl⁻: 4個';
      coord = '6 : 6 (正八面体配位)';
      packing = 'イオン結晶標準型';
      relation = 'a = 2(r₊ + r₋)';
      examples = 'NaCl, KCl, AgCl, MgO';
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.view_in_ar, color: Color(0xFF34D399), size: 20),
                    SizedBox(width: 8),
                    Text(
                      '結晶格子3D立体構造＆充填率シミュレータ',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '体心立方・面心立方・NaCl型の立体単位格子を360°回転して観察。\n格子定数 a と原子半径 r の関係、配位数、充填率の導出公式を完全網羅！',
                  style: TextStyle(fontSize: 11, color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Lattice Selector Chips
          Row(
            children: [
              _buildTypeChip(0, '体心立方 (BCC)'),
              const SizedBox(width: 8),
              _buildTypeChip(1, '面心立方 (FCC)'),
              const SizedBox(width: 8),
              _buildTypeChip(2, 'NaCl 型'),
            ],
          ),

          const SizedBox(height: 14),

          // 3D Canvas
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _rotY += details.delta.dx * 0.01;
                _rotX -= details.delta.dy * 0.01;
              });
            },
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                color: const Color(0xFF030712),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _Lattice3DPainter(
                        latticeType: _selectedType,
                        rotX: _rotX,
                        rotY: _rotY,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.touch_app, size: 12, color: Colors.white60),
                          SizedBox(width: 4),
                          Text('ドラッグして360°回転', style: TextStyle(fontSize: 10, color: Colors.white60)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Data table card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF34D399))),
                const SizedBox(height: 12),
                _buildDataRow('単位格子中の粒子数:', count),
                _buildDataRow('配位数 (最隣接原子数):', coord),
                _buildDataRow('空間充填率:', packing),
                _buildDataRow('原子半径 r と格子定数 a:', relation),
                _buildDataRow('代表的な物質:', examples),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Density Formula Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('密度計算公式 (入試最重要)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8))),
                SizedBox(height: 6),
                Text(
                  '密度 d [g/cm³] = (n × M) / (N_A × a³)\n(n: 粒子数, M: モル質量, N_A: アボガドロ定数 6.02×10²³, a: 格子定数 cm)',
                  style: TextStyle(fontSize: 11, color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(int type, String label) {
    final isSel = _selectedType == type;
    return Expanded(
      child: ChoiceChip(
        label: Center(child: Text(label)),
        selected: isSel,
        selectedColor: const Color(0xFF10B981),
        backgroundColor: const Color(0xFF131B2E),
        labelStyle: TextStyle(
          fontSize: 11,
          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
          color: isSel ? Colors.black : Colors.white70,
        ),
        onSelected: (_) => setState(() => _selectedType = type),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: const TextStyle(fontSize: 11, color: Colors.white60)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _Point3D {
  final double x, y, z;
  final Color color;
  final double radius;

  _Point3D(this.x, this.y, this.z, {required this.color, this.radius = 12});
}

class _Lattice3DPainter extends CustomPainter {
  final int latticeType;
  final double rotX;
  final double rotY;

  _Lattice3DPainter({
    required this.latticeType,
    required this.rotX,
    required this.rotY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    const l = 70.0; // Half-side length

    // Cube vertices
    final corners = [
      _Point3D(-l, -l, -l, color: const Color(0xFF38BDF8)),
      _Point3D(l, -l, -l, color: const Color(0xFF38BDF8)),
      _Point3D(l, l, -l, color: const Color(0xFF38BDF8)),
      _Point3D(-l, l, -l, color: const Color(0xFF38BDF8)),
      _Point3D(-l, -l, l, color: const Color(0xFF38BDF8)),
      _Point3D(l, -l, l, color: const Color(0xFF38BDF8)),
      _Point3D(l, l, l, color: const Color(0xFF38BDF8)),
      _Point3D(-l, l, l, color: const Color(0xFF38BDF8)),
    ];

    final atoms = <_Point3D>[...corners];

    if (latticeType == 0) {
      // BCC: Center atom
      atoms.add(_Point3D(0, 0, 0, color: const Color(0xFFFBBF24), radius: 16));
    } else if (latticeType == 1) {
      // FCC: 6 Face-center atoms
      atoms.addAll([
        _Point3D(0, 0, -l, color: const Color(0xFF34D399), radius: 14),
        _Point3D(0, 0, l, color: const Color(0xFF34D399), radius: 14),
        _Point3D(0, -l, 0, color: const Color(0xFF34D399), radius: 14),
        _Point3D(0, l, 0, color: const Color(0xFF34D399), radius: 14),
        _Point3D(-l, 0, 0, color: const Color(0xFF34D399), radius: 14),
        _Point3D(l, 0, 0, color: const Color(0xFF34D399), radius: 14),
      ]);
    } else {
      // NaCl: Na+ (center and 12 edge centers), Cl- (corners and 6 face centers)
      atoms.add(_Point3D(0, 0, 0, color: const Color(0xFFEC4899), radius: 10)); // Na+ center
      // Edge centers (Na+)
      atoms.addAll([
        _Point3D(l, 0, -l, color: const Color(0xFFEC4899), radius: 10),
        _Point3D(-l, 0, -l, color: const Color(0xFFEC4899), radius: 10),
        _Point3D(0, l, -l, color: const Color(0xFFEC4899), radius: 10),
        _Point3D(0, -l, -l, color: const Color(0xFFEC4899), radius: 10),
      ]);
    }

    // 3D rotation projection helper
    Offset project(_Point3D p, outZ) {
      // Rotate around Y axis
      final x1 = p.x * cos(rotY) + p.z * sin(rotY);
      final z1 = -p.x * sin(rotY) + p.z * cos(rotY);
      // Rotate around X axis
      final y2 = p.y * cos(rotX) - z1 * sin(rotX);
      final z2 = p.y * sin(rotX) + z1 * cos(rotX);

      const d = 400.0;
      final f = d / (d + z2);
      return Offset(cx + x1 * f, cy + y2 * f);
    }

    // Draw Unit Cell Wireframe edges
    final edges = [
      [0, 1], [1, 2], [2, 3], [3, 0], // back
      [4, 5], [5, 6], [6, 7], [7, 4], // front
      [0, 4], [1, 5], [2, 6], [3, 7], // connecting
    ];

    final wirePaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1.5;

    for (final e in edges) {
      final p1 = project(corners[e[0]], 0);
      final p2 = project(corners[e[1]], 0);
      canvas.drawLine(p1, p2, wirePaint);
    }

    // Sort atoms by depth (Z) for painter's algorithm
    final projectedAtoms = atoms.map((a) {
      final x1 = a.x * cos(rotY) + a.z * sin(rotY);
      final z1 = -a.x * sin(rotY) + a.z * cos(rotY);
      final y2 = a.y * cos(rotX) - z1 * sin(rotX);
      final z2 = a.y * sin(rotX) + z1 * cos(rotX);
      const d = 400.0;
      final f = d / (d + z2);
      return {
        'pt': Offset(cx + x1 * f, cy + y2 * f),
        'z': z2,
        'r': a.radius * f,
        'color': a.color,
      };
    }).toList()
      ..sort((a, b) => (b['z'] as double).compareTo(a['z'] as double));

    // Draw Spheres
    for (final pa in projectedAtoms) {
      final pt = pa['pt'] as Offset;
      final r = pa['r'] as double;
      final color = pa['color'] as Color;

      // Glow & ball
      final spherePaint = Paint()
        ..shader = RadialGradient(
          colors: [Colors.white, color, color.withValues(alpha: 0.8)],
          stops: const [0.0, 0.4, 1.0],
        ).createShader(Rect.fromCircle(center: pt, radius: r));

      canvas.drawCircle(pt, r, spherePaint);
      canvas.drawCircle(pt, r, Paint()..color = Colors.white38..style = PaintingStyle.stroke..strokeWidth = 1);
    }
  }

  @override
  bool shouldRepaint(covariant _Lattice3DPainter oldDelegate) =>
      oldDelegate.latticeType != latticeType ||
      oldDelegate.rotX != rotX ||
      oldDelegate.rotY != rotY;
}
