import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/question_service.dart';
import '../screens/practice_screen.dart';
import '../screens/flashcard_screen.dart';
import '../screens/challenge_mode_screen.dart';

class RoadmapNode {
  final int id;
  final String title;
  final String subject;
  final String subjectId;
  final String description;
  final IconData icon;
  final Color color;
  final int requiredLevel;
  final String actionType; // 'practice' | 'flashcard' | 'challenge'

  const RoadmapNode({
    required this.id,
    required this.title,
    required this.subject,
    required this.subjectId,
    required this.description,
    required this.icon,
    required this.color,
    required this.requiredLevel,
    this.actionType = 'practice',
  });
}

class LearningRoadmapWidget extends StatelessWidget {
  final UserProfile profile;

  const LearningRoadmapWidget({super.key, required this.profile});

  static const List<RoadmapNode> nodes = [
    RoadmapNode(
      id: 1,
      title: 'ターゲット1900 基本単語',
      subject: '英語',
      subjectId: 'english',
      description: '入試最頻出の基本800単語を固める',
      icon: Icons.menu_book,
      color: Color(0xFF38BDF8),
      requiredLevel: 1,
      actionType: 'flashcard',
    ),
    RoadmapNode(
      id: 2,
      title: '高校数学 微分・極値',
      subject: '高校数学',
      subjectId: 'math',
      description: '導関数・接線の傾き・増減表をマスター',
      icon: Icons.show_chart,
      color: Color(0xFF818CF8),
      requiredLevel: 2,
      actionType: 'challenge',
    ),
    RoadmapNode(
      id: 3,
      title: '物理 運動方程式・等加速度',
      subject: '物理',
      subjectId: 'physics',
      description: 'ma=F の立式とv-tグラフの完全理解',
      icon: Icons.bolt,
      color: Color(0xFFF59E0B),
      requiredLevel: 3,
      actionType: 'practice',
    ),
    RoadmapNode(
      id: 4,
      title: '化学 酸化還元・滴定pH',
      subject: '化学',
      subjectId: 'chemistry',
      description: '電子の授受とpH曲線の変色域を速読',
      icon: Icons.science,
      color: Color(0xFFEC4899),
      requiredLevel: 4,
      actionType: 'practice',
    ),
    RoadmapNode(
      id: 5,
      title: '高校数学 積分・面積公式',
      subject: '高校数学',
      subjectId: 'math',
      description: '1/6公式・放物線と直線の瞬殺積分',
      icon: Icons.calculate,
      color: Color(0xFF38BDF8),
      requiredLevel: 5,
      actionType: 'challenge',
    ),
    RoadmapNode(
      id: 6,
      title: '古文 助動詞識別マスター',
      subject: '国語',
      subjectId: 'japanese',
      description: '「る・らる」「む」「なり」の文脈識別',
      icon: Icons.history_edu,
      color: Color(0xFFA855F7),
      requiredLevel: 6,
      actionType: 'practice',
    ),
    RoadmapNode(
      id: 7,
      title: '生物 遺伝・セントラルドグマ',
      subject: '生物',
      subjectId: 'biology',
      description: 'DNAからRNA転写とコドン翻訳のメカニズム',
      icon: Icons.biotech,
      color: Color(0xFF10B981),
      requiredLevel: 7,
      actionType: 'practice',
    ),
    RoadmapNode(
      id: 8,
      title: '情報I 2進数・論理回路',
      subject: '情報',
      subjectId: 'information',
      description: '基数変換・真理値表・論理ゲートの即答特訓',
      icon: Icons.terminal,
      color: Color(0xFF06B6D4),
      requiredLevel: 8,
      actionType: 'practice',
    ),
    RoadmapNode(
      id: 9,
      title: '歴史 転換点・近代立憲',
      subject: '社会',
      subjectId: 'social',
      description: '承久の乱・三権分立・憲法三大原則',
      icon: Icons.public,
      color: Color(0xFFEAB308),
      requiredLevel: 9,
      actionType: 'practice',
    ),
    RoadmapNode(
      id: 10,
      title: '難関突破 NEXUS クラウン',
      subject: '全教科',
      subjectId: 'math',
      description: '東大・京大・医学部レベルの総合演習',
      icon: Icons.workspace_premium,
      color: Color(0xFFFBBF24),
      requiredLevel: 10,
      actionType: 'challenge',
    ),
  ];

  void _onNodeTap(BuildContext context, RoadmapNode node) {
    final isReached = profile.level >= node.requiredLevel;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: node.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: node.color),
                  ),
                  child: Icon(node.icon, color: node.color, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: node.color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              node.subject,
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: node.color),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isReached ? '★ 到達済み' : 'いつでも挑戦可能',
                            style: TextStyle(
                              fontSize: 10,
                              color: isReached ? const Color(0xFF34D399) : const Color(0xFF38BDF8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        node.title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF131B2E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                node.description,
                style: const TextStyle(fontSize: 12, color: Colors.white70, height: 1.4),
              ),
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.check_circle_outline, size: 13, color: Color(0xFF34D399)),
                SizedBox(width: 4),
                Text(
                  'ロードマップの制限なし：いつでもタップして特訓を開始できます',
                  style: TextStyle(fontSize: 10, color: Colors.white54),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(ctx);
                if (node.actionType == 'flashcard') {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const FlashcardScreen()));
                } else if (node.actionType == 'challenge') {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ChallengeModeScreen()));
                } else {
                  final qs = await QuestionService().getQuestionsForSubject(node.subjectId);
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PracticeScreen(questions: qs, title: '${node.subject} - ${node.title}'),
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.play_arrow, size: 18),
              label: Text(
                node.actionType == 'flashcard'
                    ? '暗記カードを学習する'
                    : node.actionType == 'challenge'
                        ? 'チャレンジ特訓を開始'
                        : 'この分野の演習をスタート',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: node.color,
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Roadmap Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.alt_route, color: Color(0xFF38BDF8), size: 20),
                  SizedBox(width: 8),
                  Text(
                    '学習クエスト・ロードマップ',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: Color(0xFFF59E0B), size: 14),
                    const SizedBox(width: 3),
                    Text(
                      '${profile.streakDays}日継続中',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            '全ノードいつでも挑戦可能！進捗と到達度を可視化しています。',
            style: TextStyle(fontSize: 11, color: Colors.white54),
          ),
          const SizedBox(height: 24),

          // Winding Road Nodes
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: nodes.length,
            itemBuilder: (context, index) {
              final node = nodes[index];
              final isReached = profile.level >= node.requiredLevel;
              final isCurrentTarget = profile.level == node.requiredLevel ||
                  (profile.level > nodes.last.requiredLevel && index == nodes.length - 1);

              // Winding alternating alignments: 0: center, 1: right, 2: center, 3: left, etc.
              final alignPattern = index % 4;
              Alignment nodeAlign = Alignment.center;
              if (alignPattern == 1) nodeAlign = const Alignment(0.55, 0.0);
              if (alignPattern == 3) nodeAlign = const Alignment(-0.55, 0.0);

              return Column(
                children: [
                  Align(
                    alignment: nodeAlign,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        // Current milestone marker avatar/flame
                        if (isCurrentTarget)
                          Positioned(
                            top: -18,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF38BDF8),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF38BDF8).withValues(alpha: 0.5),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: const Text(
                                '現在地',
                                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ),
                          ),

                        // Node Circle Button
                        GestureDetector(
                          onTap: () => _onNodeTap(context, node),
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: isReached
                                    ? [node.color, node.color.withValues(alpha: 0.7)]
                                    : [const Color(0xFF1E293B), const Color(0xFF0F172A)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                color: isReached
                                    ? Colors.white
                                    : isCurrentTarget
                                        ? const Color(0xFF38BDF8)
                                        : node.color.withValues(alpha: 0.5),
                                width: isCurrentTarget ? 3 : 2,
                              ),
                              boxShadow: [
                                if (isReached || isCurrentTarget)
                                  BoxShadow(
                                    color: node.color.withValues(alpha: 0.4),
                                    blurRadius: 14,
                                    spreadRadius: 1,
                                  ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                node.icon,
                                color: isReached ? Colors.black : node.color,
                                size: 28,
                              ),
                            ),
                          ),
                        ),

                        // Star badge below node
                        Positioned(
                          bottom: -8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 10,
                                  color: isReached ? const Color(0xFFFBBF24) : Colors.white24,
                                ),
                                Icon(
                                  Icons.star,
                                  size: 10,
                                  color: isReached ? const Color(0xFFFBBF24) : Colors.white24,
                                ),
                                Icon(
                                  Icons.star,
                                  size: 10,
                                  color: isReached && profile.level > node.requiredLevel
                                      ? const Color(0xFFFBBF24)
                                      : Colors.white24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Node title caption
                  const SizedBox(height: 12),
                  Align(
                    alignment: nodeAlign,
                    child: Text(
                      node.title,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isReached ? Colors.white : Colors.white70,
                      ),
                    ),
                  ),

                  // Connecting path line if not last
                  if (index < nodes.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: CustomPaint(
                        size: const Size(40, 24),
                        painter: _ConnectorLinePainter(
                          color: isReached ? const Color(0xFF38BDF8) : Colors.white24,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ConnectorLinePainter extends CustomPainter {
  final Color color;
  _ConnectorLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Draw dotted or smooth line
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ConnectorLinePainter oldDelegate) => oldDelegate.color != color;
}
