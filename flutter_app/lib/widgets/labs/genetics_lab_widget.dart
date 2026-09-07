import 'package:flutter/material.dart';

class GeneticsLabWidget extends StatefulWidget {
  const GeneticsLabWidget({super.key});

  @override
  State<GeneticsLabWidget> createState() => _GeneticsLabWidgetState();
}

class _GeneticsLabWidgetState extends State<GeneticsLabWidget> {
  // Gametes for RrYy
  final List<String> _p1Gametes = ['RY', 'Ry', 'rY', 'ry'];
  final List<String> _p2Gametes = ['RY', 'Ry', 'rY', 'ry'];

  @override
  Widget build(BuildContext context) {
    // Calculate 16 combinations
    int roundYellow = 0; // R_Y_
    int roundGreen = 0; // R_yy
    int wrinkledYellow = 0; // rrY_
    int wrinkledGreen = 0; // rryy

    final grid = <List<String>>[];
    for (final g1 in _p1Gametes) {
      final row = <String>[];
      for (final g2 in _p2Gametes) {
        // Combine alleles: R/r and Y/y
        final rAlleles = [g1[0], g2[0]]..sort(); // uppercase first if sorted reverse, let's format
        final rStr = (rAlleles.contains('R') && rAlleles.contains('r')) ? 'Rr' : (rAlleles[0] + rAlleles[1]);
        final yAlleles = [g1[1], g2[1]]..sort();
        final yStr = (yAlleles.contains('Y') && yAlleles.contains('y')) ? 'Yy' : (yAlleles[0] + yAlleles[1]);

        final genotype = '$rStr$yStr';
        row.add(genotype);

        final isRound = genotype.contains('R');
        final isYellow = genotype.contains('Y');

        if (isRound && isYellow) {
          roundYellow++;
        } else if (isRound && !isYellow) {
          roundGreen++;
        } else if (!isRound && isYellow) {
          wrinkledYellow++;
        } else {
          wrinkledGreen++;
        }
      }
      grid.add(row);
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
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.biotech, color: Color(0xFF10B981), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'メンデルの独立の法則 (二遺伝子交配)',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  '親の交配: RrYy (丸・黄) × RrYy (丸・黄)\n配偶子: RY, Ry, rY, ry (各25%)',
                  style: TextStyle(fontSize: 11, color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Phenotype Ratio Cards
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '表現型の出現比率 (理論比 9 : 3 : 3 : 1)',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8)),
                ),
                const SizedBox(height: 12),
                _buildPhenotypeRow('丸・黄 [R_Y_]', roundYellow, 16, const Color(0xFFF59E0B)),
                const SizedBox(height: 8),
                _buildPhenotypeRow('丸・緑 [R_yy]', roundGreen, 16, const Color(0xFF10B981)),
                const SizedBox(height: 8),
                _buildPhenotypeRow('しわ・黄 [rrY_]', wrinkledYellow, 16, const Color(0xFFEAB308)),
                const SizedBox(height: 8),
                _buildPhenotypeRow('しわ・緑 [rryy]', wrinkledGreen, 16, const Color(0xFF64748B)),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 4x4 Punnett Square Table
          const Text(
            'プネット平方 (4×4 配偶子マトリクス)',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white70),
          ),
          const SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Table(
              border: TableBorder.all(color: const Color(0xFF1E293B)),
              children: [
                // Table Header
                TableRow(
                  decoration: const BoxDecoration(color: Color(0xFF1E293B)),
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Center(
                        child: Text(
                          '母＼父',
                          style: TextStyle(fontSize: 10, color: Colors.white54, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    ..._p2Gametes.map((g) => Padding(
                          padding: const EdgeInsets.all(8),
                          child: Center(
                            child: Text(
                              g,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8)),
                            ),
                          ),
                        )),
                  ],
                ),
                // Rows
                ...List.generate(4, (r) {
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Center(
                          child: Text(
                            _p1Gametes[r],
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF818CF8)),
                          ),
                        ),
                      ),
                      ...List.generate(4, (c) {
                        final geno = grid[r][c];
                        final isRound = geno.contains('R');
                        final isYellow = geno.contains('Y');

                        Color badgeColor;
                        if (isRound && isYellow) {
                          badgeColor = const Color(0xFFF59E0B);
                        } else if (isRound && !isYellow) {
                          badgeColor = const Color(0xFF10B981);
                        } else if (!isRound && isYellow) {
                          badgeColor = const Color(0xFFEAB308);
                        } else {
                          badgeColor = const Color(0xFF64748B);
                        }

                        return Padding(
                          padding: const EdgeInsets.all(6),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                              decoration: BoxDecoration(
                                color: badgeColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: badgeColor.withValues(alpha: 0.5)),
                              ),
                              child: Text(
                                geno,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: badgeColor,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhenotypeRow(String label, int count, int total, Color color) {
    final pct = (count / total);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.white)),
            Text(
              '$count / $total (${(pct * 100).toStringAsFixed(1)}%)',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
