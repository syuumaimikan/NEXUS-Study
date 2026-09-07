import 'package:flutter/material.dart';

class CentralDogmaLabWidget extends StatefulWidget {
  const CentralDogmaLabWidget({super.key});

  @override
  State<CentralDogmaLabWidget> createState() => _CentralDogmaLabWidgetState();
}

class _CentralDogmaLabWidgetState extends State<CentralDogmaLabWidget> {
  // DNA template presets
  final List<String> _dnaPresets = [
    'TACAAATGCGATACT', // AUG-UUU-ACG-CUA-UGA -> Met-Phe-Thr-Leu-[Stop]
    'TACCGGTTTGCAATT', // AUG-GCC-AAA-CGU-UAA -> Met-Ala-Lys-Arg-[Stop]
    'TACGTAGCTCTAACT', // AUG-CAU-CGA-GAU-UGA -> Met-His-Arg-Asp-[Stop]
  ];
  int _selectedPreset = 0;

  static const Map<String, String> _codonTable = {
    'AUG': 'Met (開始)',
    'UUU': 'Phe',
    'UUC': 'Phe',
    'UUA': 'Leu',
    'UUG': 'Leu',
    'CUU': 'Leu',
    'CUC': 'Leu',
    'CUA': 'Leu',
    'CUG': 'Leu',
    'AUU': 'Ile',
    'AUC': 'Ile',
    'AUA': 'Ile',
    'GUU': 'Val',
    'GUC': 'Val',
    'GUA': 'Val',
    'GUG': 'Val',
    'UCU': 'Ser',
    'UCC': 'Ser',
    'UCA': 'Ser',
    'UCG': 'Ser',
    'CCU': 'Pro',
    'CCC': 'Pro',
    'CCA': 'Pro',
    'CCG': 'Pro',
    'ACU': 'Thr',
    'ACC': 'Thr',
    'ACA': 'Thr',
    'ACG': 'Thr',
    'GCU': 'Ala',
    'GCC': 'Ala',
    'GCA': 'Ala',
    'GCG': 'Ala',
    'UAU': 'Tyr',
    'UAC': 'Tyr',
    'UAA': '終止 (Stop)',
    'UAG': '終止 (Stop)',
    'UGA': '終止 (Stop)',
    'CAU': 'His',
    'CAC': 'His',
    'CAA': 'Gln',
    'CAG': 'Gln',
    'AAU': 'Asn',
    'AAC': 'Asn',
    'AAA': 'Lys',
    'AAG': 'Lys',
    'GAU': 'Asp',
    'GAC': 'Asp',
    'GAA': 'Glu',
    'GAG': 'Glu',
    'UGU': 'Cys',
    'UGC': 'Cys',
    'UGG': 'Trp',
    'CGU': 'Arg',
    'CGC': 'Arg',
    'CGA': 'Arg',
    'CGG': 'Arg',
    'AGU': 'Ser',
    'AGC': 'Ser',
    'AGA': 'Arg',
    'AGG': 'Arg',
    'GGU': 'Gly',
    'GGC': 'Gly',
    'GGA': 'Gly',
    'GGG': 'Gly',
  };

  String _transcribe(String dna) {
    final buffer = StringBuffer();
    for (int i = 0; i < dna.length; i++) {
      final base = dna[i];
      if (base == 'T') {
        buffer.write('A');
      } else if (base == 'A') {
        buffer.write('U');
      } else if (base == 'C') {
        buffer.write('G');
      } else if (base == 'G') {
        buffer.write('C');
      }
    }
    return buffer.toString();
  }

  List<String> _translate(String mrna) {
    final aminoAcids = <String>[];
    for (int i = 0; i + 2 < mrna.length; i += 3) {
      final codon = mrna.substring(i, i + 3);
      final aa = _codonTable[codon] ?? '???';
      aminoAcids.add(aa);
    }
    return aminoAcids;
  }

  @override
  Widget build(BuildContext context) {
    final dna = _dnaPresets[_selectedPreset];
    final mrna = _transcribe(dna);
    final aminoAcids = _translate(mrna);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.biotech, color: Color(0xFF34D399), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'セントラルドグマ・転写翻訳シミュレータ',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'DNA (二重らせん・遺伝暗号) → mRNA (転写) → リボソーム (翻訳・コドン) → タンパク質 (ポリペプチド)\n生命の基本原理「セントラルドグマ」の全情報伝達フローをリアルタイム可視化！',
                  style: TextStyle(fontSize: 11, color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Presets
          Row(
            children: List.generate(_dnaPresets.length, (i) {
              final isSel = _selectedPreset == i;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < _dnaPresets.length - 1 ? 8 : 0),
                  child: ChoiceChip(
                    label: Center(child: Text('配列 ${i + 1}')),
                    selected: isSel,
                    selectedColor: const Color(0xFF10B981),
                    backgroundColor: const Color(0xFF131B2E),
                    labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                      color: isSel ? Colors.black : Colors.white70,
                    ),
                    onSelected: (_) => setState(() => _selectedPreset = i),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 16),

          // Flow Cards
          // 1. DNA Template Strand
          _buildStageCard(
            step: 'Step 1: DNA 鋳型鎖 (核内)',
            icon: Icons.fingerprint,
            color: const Color(0xFF38BDF8),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(dna.length ~/ 3, (i) {
                final triplet = dna.substring(i * 3, i * 3 + 3);
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    triplet,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 2, color: Color(0xFF38BDF8)),
                  ),
                );
              }),
            ),
          ),

          const Center(child: Icon(Icons.arrow_downward, color: Colors.white30, size: 20)),

          // 2. mRNA Transcription
          _buildStageCard(
            step: 'Step 2: mRNA 転写 (RNAポリメラーゼ)',
            icon: Icons.alt_route,
            color: const Color(0xFFFBBF24),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(mrna.length ~/ 3, (i) {
                final codon = mrna.substring(i * 3, i * 3 + 3);
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFBBF24).withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    codon,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 2, color: Color(0xFFFBBF24)),
                  ),
                );
              }),
            ),
          ),

          const Center(child: Icon(Icons.arrow_downward, color: Colors.white30, size: 20)),

          // 3. Ribosome Translation (Amino Acid chain)
          _buildStageCard(
            step: 'Step 3: リボソーム翻訳 (ポリペプチド鎖形成)',
            icon: Icons.hub,
            color: const Color(0xFF34D399),
            content: Wrap(
              spacing: 6,
              runSpacing: 6,
              alignment: WrapAlignment.center,
              children: aminoAcids.map((aa) {
                final isStart = aa.contains('開始');
                final isStop = aa.contains('終止');
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isStart
                        ? const Color(0xFF064E3B)
                        : isStop
                            ? const Color(0xFF4C0519)
                            : const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isStart
                          ? const Color(0xFF10B981)
                          : isStop
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF818CF8),
                    ),
                  ),
                  child: Text(
                    aa,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isStart
                          ? const Color(0xFF6EE7B7)
                          : isStop
                              ? const Color(0xFFFCA5A5)
                              : Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Key Rules Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('重要ポイント (試験頻出)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8))),
                SizedBox(height: 6),
                Text('・塩基の相補性: DNA(A-T, G-C) ⇄ RNA(A-U, G-C)', style: TextStyle(fontSize: 11, color: Colors.white70)),
                Text('・開始コドン: AUG (メチオニンを指定)', style: TextStyle(fontSize: 11, color: Colors.white70)),
                Text('・終止コドン: UAA, UAG, UGA (対応するアミノ酸なし)', style: TextStyle(fontSize: 11, color: Colors.white70)),
                Text('・コドンの重複性: 64種類のコドンで約20種のアミノ酸を指定', style: TextStyle(fontSize: 11, color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageCard({
    required String step,
    required IconData icon,
    required Color color,
    required Widget content,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(step, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }
}
