import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/storage_service.dart';

class OnboardingScreen extends StatefulWidget {
  final Function(UserProfile) onCompleted;

  const OnboardingScreen({super.key, required this.onCompleted});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 1;
  String _educationStage = 'high_school'; // 'high_school' | 'junior_high'
  final _nameController = TextEditingController(text: '学習者');
  final _targetUnivController = TextEditingController(text: '難関大学・志望校');
  String _schoolGrade = '高校2年生';
  String _studyTrack = 'science'; // science, humanities, medical, general
  String _avatarIcon = 'school';

  final List<Map<String, dynamic>> _iconOptions = [
    {'name': 'school', 'icon': Icons.school, 'label': '標準'},
    {'name': 'science', 'icon': Icons.science, 'label': '理科'},
    {'name': 'calculate', 'icon': Icons.calculate, 'label': '数学'},
    {'name': 'psychology', 'icon': Icons.psychology, 'label': '思考'},
    {'name': 'menu_book', 'icon': Icons.menu_book, 'label': '文系'},
    {'name': 'bolt', 'icon': Icons.bolt, 'label': '探究'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _targetUnivController.dispose();
    super.dispose();
  }

  void _finishOnboarding() async {
    final profile = UserProfile(
      id: 'student_${DateTime.now().millisecondsSinceEpoch}',
      username: _nameController.text.trim().isEmpty ? '学習者' : _nameController.text.trim(),
      avatarIcon: _avatarIcon,
      schoolGrade: _schoolGrade,
      targetUniversity: _targetUnivController.text.trim().isEmpty ? '志望校設定中' : _targetUnivController.text.trim(),
      studyTrack: _studyTrack,
      educationStage: _educationStage,
      hasCompletedOnboarding: true,
      level: 1,
      currentXp: 0,
      nextLevelXp: 500,
      streakDays: 1,
      coins: 100,
      league: 'Bronze',
    );

    await StorageService().saveProfile(profile);
    widget.onCompleted(profile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 0, maxWidth: 440),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF131B2E),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF38BDF8).withValues(alpha: 0.1),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header with Material Icons
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF38BDF8), Color(0xFF6366F1)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.school, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'NEXUS Study',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '初期プロファイル設定 (Step $_step / 3)',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF38BDF8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Step 1: Name & Avatar Icon
                    // Step 1: Stage, Icon, Name
                    if (_step == 1) ...[
                      const Text(
                        '学習ステージを選択',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ChoiceChip(
                              label: const Center(child: Text('高校生 (大学受験)')),
                              selected: _educationStage == 'high_school',
                              selectedColor: const Color(0xFF38BDF8),
                              backgroundColor: const Color(0xFF0F172A),
                              labelStyle: TextStyle(
                                color: _educationStage == 'high_school' ? Colors.black : Colors.white70,
                                fontWeight: _educationStage == 'high_school' ? FontWeight.bold : FontWeight.normal,
                                fontSize: 12,
                              ),
                              onSelected: (_) => setState(() {
                                _educationStage = 'high_school';
                                _schoolGrade = '高校2年生';
                                _targetUnivController.text = '難関国立大学';
                              }),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ChoiceChip(
                              label: const Center(child: Text('中学生 (高校受験)')),
                              selected: _educationStage == 'junior_high',
                              selectedColor: const Color(0xFF38BDF8),
                              backgroundColor: const Color(0xFF0F172A),
                              labelStyle: TextStyle(
                                color: _educationStage == 'junior_high' ? Colors.black : Colors.white70,
                                fontWeight: _educationStage == 'junior_high' ? FontWeight.bold : FontWeight.normal,
                                fontSize: 12,
                              ),
                              onSelected: (_) => setState(() {
                                _educationStage = 'junior_high';
                                _schoolGrade = '中学3年生';
                                _targetUnivController.text = '公立トップ高・難関私立高';
                              }),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'プロファイルアイコンを選択',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _iconOptions.map((opt) {
                          final isSelected = _avatarIcon == opt['name'];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _avatarIcon = opt['name'] as String;
                              });
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF38BDF8).withValues(alpha: 0.2) : const Color(0xFF0F172A),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF38BDF8) : Colors.white12,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Icon(
                                opt['icon'] as IconData,
                                color: isSelected ? const Color(0xFF38BDF8) : Colors.white60,
                                size: 22,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'ニックネーム / お名前',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: '例: たろう、Sakura',
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: const Color(0xFF0F172A),
                          prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF38BDF8), size: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],

                    // Step 2: Grade & Track
                    if (_step == 2) ...[
                      const Text(
                        '学年を選択',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: (_educationStage == 'junior_high'
                                ? ['中学1年生', '中学2年生', '中学3年生']
                                : ['高校1年生', '高校2年生', '高校3年生', '既卒・高卒生'])
                            .map((grade) {
                          final isSelected = _schoolGrade == grade;
                          return ChoiceChip(
                            label: Text(grade),
                            selected: isSelected,
                            onSelected: (val) {
                              if (val) setState(() => _schoolGrade = grade);
                            },
                            selectedColor: const Color(0xFF38BDF8).withValues(alpha: 0.25),
                            labelStyle: TextStyle(
                              color: isSelected ? const Color(0xFF38BDF8) : Colors.white70,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 12,
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        '志望コース・文理専攻',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: [
                          _buildTrackTile('science', '理系（数学・物理・化学・生物）', Icons.science),
                          _buildTrackTile('humanities', '文系（国語・地歴公民・英語）', Icons.menu_book),
                          _buildTrackTile('medical', '医歯薬・看護系', Icons.medical_services_outlined),
                          _buildTrackTile('general', '総合・共通テスト全般', Icons.public),
                        ],
                      ),
                    ],

                    // Step 3: Target University
                    if (_step == 3) ...[
                      const Text(
                        '第一志望大学・目標',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _targetUnivController,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: '例: 東京大学、京都大学、医学部、難関私立',
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: const Color(0xFF0F172A),
                          prefixIcon: const Icon(Icons.flag_outlined, color: Color(0xFF38BDF8), size: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle_outline, color: Color(0xFF34D399), size: 20),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '高校全14科目の2,800問の解説付き問題バンクと手書き計算メモ機能が準備完了しています。',
                                style: TextStyle(fontSize: 11, color: Colors.white70, height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Navigation buttons
                    Row(
                      children: [
                        if (_step > 1)
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => setState(() => _step--),
                              icon: const Icon(Icons.arrow_back, size: 16),
                              label: const Text('戻る'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white70,
                                side: const BorderSide(color: Colors.white24),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                            ),
                          ),
                        if (_step > 1) const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (_step < 3) {
                                setState(() => _step++);
                              } else {
                                _finishOnboarding();
                              }
                            },
                            icon: Icon(_step == 3 ? Icons.check : Icons.arrow_forward, size: 16),
                            label: Text(_step == 3 ? '学習を開始する' : '次へ進む'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF38BDF8),
                              foregroundColor: const Color(0xFF090D16),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrackTile(String id, String title, IconData icon) {
    final isSelected = _studyTrack == id;
    return GestureDetector(
      onTap: () => setState(() => _studyTrack = id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF38BDF8).withValues(alpha: 0.15) : const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF38BDF8) : Colors.white10,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isSelected ? const Color(0xFF38BDF8) : Colors.white60),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : Colors.white70,
                ),
              ),
            ),
            if (isSelected) const Icon(Icons.check, size: 16, color: Color(0xFF38BDF8)),
          ],
        ),
      ),
    );
  }
}
