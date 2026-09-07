import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/storage_service.dart';
import '../widgets/progress_analytics_widget.dart';
import 'reward_shop_screen.dart';

class ProfileScreen extends StatefulWidget {
  final UserProfile profile;
  final Function(UserProfile) onProfileUpdated;
  final VoidCallback onResetRequested;

  const ProfileScreen({
    super.key,
    required this.profile,
    required this.onProfileUpdated,
    required this.onResetRequested,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _univCtrl;
  Map<String, int> _stats = {'attempts': 0, 'correct': 0};

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.profile.username);
    _univCtrl = TextEditingController(text: widget.profile.targetUniversity);
    _loadStats();
  }

  void _loadStats() async {
    final s = await StorageService().getStats();
    setState(() {
      _stats = s;
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _univCtrl.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    final updated = widget.profile.copyWith(
      username: _nameCtrl.text.trim().isEmpty ? widget.profile.username : _nameCtrl.text.trim(),
      targetUniversity: _univCtrl.text.trim().isEmpty ? widget.profile.targetUniversity : _univCtrl.text.trim(),
    );
    await StorageService().saveProfile(updated);
    widget.onProfileUpdated(updated);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('プロフィールを更新しました'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    }
  }

  void _confirmReset() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF131B2E),
        title: const Text('データの初期化', style: TextStyle(color: Colors.white, fontSize: 16)),
        content: const Text(
          '学習データとプロファイルを初期化し、初期設定ウィザードを再起動しますか？',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('キャンセル', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await StorageService().resetProfile();
              widget.onResetRequested();
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF43F5E)),
            child: const Text('初期化する', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final attempts = _stats['attempts'] ?? 0;
    final correct = _stats['correct'] ?? 0;
    final accuracy = attempts > 0 ? ((correct / attempts) * 100).round() : 0;

    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        title: const Text('マイページ・設定', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF131B2E),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.profile.avatarFrame == 'gold'
                            ? const Color(0xFFFBBF24)
                            : widget.profile.avatarFrame == 'purple'
                                ? const Color(0xFFA855F7)
                                : widget.profile.avatarFrame == 'emerald'
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFF38BDF8),
                        width: 2.5,
                      ),
                    ),
                    child: const Icon(Icons.school, color: Color(0xFF38BDF8), size: 28),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBBF24).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFBBF24).withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      widget.profile.title,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFFBBF24)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.profile.username,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.profile.schoolGrade} • Level ${widget.profile.level}',
                    style: const TextStyle(fontSize: 12, color: Colors.white60),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.flag_outlined, size: 16, color: Color(0xFF38BDF8)),
                        const SizedBox(width: 8),
                        Text(
                          widget.profile.targetUniversity.isEmpty ? '志望校未設定' : widget.profile.targetUniversity,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Stats row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('総解答数', '$attempts 問', Icons.edit_note, const Color(0xFF38BDF8)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatCard('正答率', '$accuracy %', Icons.check_circle_outline, const Color(0xFF34D399)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatCard(
                    '総問題数',
                    widget.profile.isJuniorHigh ? '1,000問' : '2,800問',
                    Icons.layers_outlined,
                    const Color(0xFFFBBF24),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Motivation Reward Shop Card
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RewardShopScreen(
                      profile: widget.profile,
                      onProfileUpdated: widget.onProfileUpdated,
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E1B4B), Color(0xFF0F172A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFFBBF24).withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBBF24).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.storefront, color: Color(0xFFFBBF24), size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'NEXUS コイン交換所',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFBBF24).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '所持: ${widget.profile.coins} G',
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFFBBF24)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            '微積マスターなどの限定称号・ネオンフレーム・保険証を解放',
                            style: TextStyle(fontSize: 11, color: Colors.white60),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white60),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Mode Switcher Card (中学生モード ⇄ 高校生モード)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.profile.isJuniorHigh ? Icons.school_outlined : Icons.account_balance,
                    color: const Color(0xFF38BDF8),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.profile.isJuniorHigh ? '中学生モード (高校受験)' : '高校生モード (大学受験)',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.profile.isJuniorHigh ? '中学5教科・1,000問演習' : '高校14科目・2,800問演習',
                          style: const TextStyle(fontSize: 11, color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final newStage = widget.profile.isJuniorHigh ? 'high_school' : 'junior_high';
                      final updated = widget.profile.copyWith(
                        educationStage: newStage,
                        schoolGrade: newStage == 'junior_high' ? '中学3年生' : '高校2年生',
                      );
                      await StorageService().saveProfile(updated);
                      widget.onProfileUpdated(updated);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            newStage == 'junior_high' ? '中学生モードに切り替えました' : '高校生モードに切り替えました',
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          duration: const Duration(milliseconds: 1200),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: const Color(0xFF38BDF8),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF38BDF8),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('切替', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Progress Analytics & Charts
            ProgressAnalyticsWidget(
              totalAttempts: attempts,
              totalCorrect: correct,
              level: widget.profile.level,
              currentXp: widget.profile.currentXp,
              nextLevelXp: widget.profile.nextLevelXp,
              targetUniversity: widget.profile.targetUniversity,
            ),

            const SizedBox(height: 24),

            // Profile Edit Form
            const Text('プロフィール変更', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            TextField(
              controller: _nameCtrl,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                labelText: 'ニックネーム',
                labelStyle: const TextStyle(color: Colors.white60, fontSize: 12),
                filled: true,
                fillColor: const Color(0xFF131B2E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _univCtrl,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                labelText: '第一志望校',
                labelStyle: const TextStyle(color: Colors.white60, fontSize: 12),
                filled: true,
                fillColor: const Color(0xFF131B2E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _saveProfile,
              icon: const Icon(Icons.save_outlined, size: 16),
              label: const Text('変更を保存'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF38BDF8),
                foregroundColor: const Color(0xFF090D16),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 32),

            // Reset Button
            OutlinedButton.icon(
              onPressed: _confirmReset,
              icon: const Icon(Icons.restart_alt, size: 16, color: Color(0xFFF43F5E)),
              label: const Text('全学習データを初期化・新規スタート', style: TextStyle(fontSize: 12, color: Color(0xFFF43F5E))),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFF43F5E)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.white54)),
        ],
      ),
    );
  }
}
