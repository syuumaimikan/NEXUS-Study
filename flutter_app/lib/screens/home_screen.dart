import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/question_service.dart';
import 'subject_list_screen.dart';
import 'mock_exam_screen.dart';
import 'flashcard_screen.dart';
import 'practice_screen.dart';
import 'lab_screen.dart';
import 'challenge_mode_screen.dart';
import '../widgets/learning_roadmap_widget.dart';

class HomeScreen extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onProfileTap;
  final VoidCallback? onLabTap;

  const HomeScreen({
    super.key,
    required this.profile,
    required this.onProfileTap,
    this.onLabTap,
  });

  @override
  Widget build(BuildContext context) {
    final xpPercent = (profile.currentXp / profile.nextLevelXp).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Profile Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF38BDF8)),
                          ),
                          child: const Icon(Icons.school, color: Color(0xFF38BDF8), size: 26),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    profile.username,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      profile.schoolGrade,
                                      style: const TextStyle(fontSize: 10, color: Color(0xFF38BDF8), fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '志望校: ${profile.targetUniversity.isEmpty ? '設定してください' : profile.targetUniversity}',
                                style: const TextStyle(fontSize: 11, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        // Streak badge (Material Icon)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.local_fire_department, color: Color(0xFFF59E0B), size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${profile.streakDays}日',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Level & XP Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Level ${profile.level}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8)),
                        ),
                        Text(
                          '${profile.currentXp} / ${profile.nextLevelXp} XP',
                          style: const TextStyle(fontSize: 11, color: Colors.white60),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: xpPercent,
                        minHeight: 6,
                        backgroundColor: Colors.white10,
                        valueColor: const AlwaysStoppedAnimation(Color(0xFF38BDF8)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Mock Exam Banner
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const MockExamScreen()));
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4C0519), Color(0xFF2E1065)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFF43F5E).withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF43F5E).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.timer_outlined, color: Color(0xFFFDA4AF), size: 22),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '大学入学共通テスト型 演習模試',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '制限時間30分・5教科総合判定・手書きメモ対応',
                              style: TextStyle(fontSize: 11, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white60),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // NEXUS Lab Banner (Interactive Visualization)
              InkWell(
                onTap: () {
                  if (onLabTap != null) {
                    onLabTap!();
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const LabScreen()));
                  }
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF064E3B), Color(0xFF0F172A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.biotech, color: Color(0xFF34D399), size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'NEXUS Lab (可視化実験室)',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  '見る・触る',
                                  style: TextStyle(fontSize: 10, color: Color(0xFF34D399), fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 2),
                            Text(
                              '2次関数・単位円・放物運動・周期表・遺伝・ソートを直感操作',
                              style: TextStyle(fontSize: 11, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white60),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Challenge Mode Banner (微積千本ノック・瞬殺特訓)
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ChallengeModeScreen()));
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E1B4B), Color(0xFF31104B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF818CF8).withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF818CF8).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.bolt, color: Color(0xFFA5B4FC), size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '微積しまくるモード ＆ スピード特訓',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  '新登場',
                                  style: TextStyle(fontSize: 10, color: Color(0xFFFBBF24), fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 2),
                            Text(
                              '導関数・不定積分・因数分解・無機沈殿を60秒瞬殺ノック！',
                              style: TextStyle(fontSize: 11, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white60),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Duolingo-style Learning Roadmap
              LearningRoadmapWidget(profile: profile),

              const SizedBox(height: 20),

              // 4 Main Feature Cards (Zero Emojis!)
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      context,
                      title: '全教科演習',
                      subtitle: '2,800問網羅',
                      icon: Icons.menu_book,
                      color: const Color(0xFF38BDF8),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubjectListScreen())),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildActionCard(
                      context,
                      title: '暗記カード',
                      subtitle: '英単語・公式',
                      icon: Icons.style_outlined,
                      color: const Color(0xFF34D399),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FlashcardScreen())),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Subject Quick Shortcuts Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '主要科目から解く',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubjectListScreen())),
                    child: const Text('すべて表示', style: TextStyle(fontSize: 12, color: Color(0xFF38BDF8))),
                  ),
                ],
              ),

              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.1,
                children: [
                  _buildSubjectTile(context, 'math', '高校数学', Icons.calculate, const Color(0xFF38BDF8)),
                  _buildSubjectTile(context, 'physics', '物理', Icons.bolt, const Color(0xFFF59E0B)),
                  _buildSubjectTile(context, 'chemistry', '化学', Icons.science, const Color(0xFFEC4899)),
                  _buildSubjectTile(context, 'biology', '生物', Icons.biotech, const Color(0xFF10B981)),
                  _buildSubjectTile(context, 'information', '情報I/II', Icons.terminal, const Color(0xFF8B5CF6)),
                  _buildSubjectTile(context, 'english', '英語', Icons.language, const Color(0xFF06B6D4)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.white54)),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectTile(
    BuildContext context,
    String subjectId,
    String title,
    IconData icon,
    Color color,
  ) {
    return InkWell(
      onTap: () async {
        final qs = await QuestionService().getQuestionsForSubject(subjectId);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PracticeScreen(questions: qs, title: title),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
