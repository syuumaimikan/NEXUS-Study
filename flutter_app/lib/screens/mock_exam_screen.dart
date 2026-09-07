import 'dart:async';
import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/question_service.dart';
import '../services/storage_service.dart';
import '../widgets/scratchpad_canvas.dart';

class MockExamScreen extends StatefulWidget {
  const MockExamScreen({super.key});

  @override
  State<MockExamScreen> createState() => _MockExamScreenState();
}

class _MockExamScreenState extends State<MockExamScreen> {
  List<Question> _questions = [];
  bool _isLoading = true;
  bool _isExamStarted = false;
  int _currentIndex = 0;
  final Map<int, int> _answers = {}; // questionIndex -> choiceIndex
  int _secondsRemaining = 1800; // 30 minutes
  Timer? _timer;
  bool _isSubmitted = false;
  bool _isScratchpadOpen = false;

  @override
  void initState() {
    super.initState();
    _loadExamQuestions();
  }

  void _loadExamQuestions() async {
    final qs = await QuestionService().getMockExamQuestions();
    setState(() {
      _questions = qs;
      _isLoading = false;
    });
  }

  void _startExam() {
    setState(() {
      _isExamStarted = true;
      _secondsRemaining = 1800;
      _currentIndex = 0;
      _answers.clear();
      _isSubmitted = false;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();
        _submitExam();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _submitExam() {
    _timer?.cancel();
    int earnedXp = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_answers[i] == _questions[i].correctAnswerIndex) {
        earnedXp += _questions[i].baseXp;
      }
    }

    StorageService().recordAttempt(true, earnedXp + 200);

    setState(() {
      _isSubmitted = true;
      _isScratchpadOpen = false;
    });
  }

  String _formatTime(int totalSec) {
    final min = totalSec ~/ 60;
    final sec = totalSec % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF090D16),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF38BDF8))),
      );
    }

    if (!_isExamStarted) {
      return _buildLobbyScreen();
    }

    if (_isSubmitted) {
      return _buildResultScreen();
    }

    final q = _questions[_currentIndex];
    final selectedChoice = _answers[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.timer, color: Color(0xFFF43F5E), size: 18),
            const SizedBox(width: 8),
            Text(
              _formatTime(_secondsRemaining),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFDA4AF)),
            ),
          ],
        ),
        actions: [
          // Scratchpad Canvas Toggle Button
          TextButton.icon(
            onPressed: () {
              setState(() {
                _isScratchpadOpen = !_isScratchpadOpen;
              });
            },
            icon: Icon(
              Icons.draw,
              size: 16,
              color: _isScratchpadOpen ? const Color(0xFFFBBF24) : const Color(0xFF38BDF8),
            ),
            label: Text(
              _isScratchpadOpen ? '閉じる' : '手書きメモ',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: _isScratchpadOpen ? const Color(0xFFFBBF24) : const Color(0xFF38BDF8),
              ),
            ),
          ),
          // Submit Button
          TextButton(
            onPressed: _submitExam,
            child: const Text('採点・提出', style: TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Question Palette
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_questions.length, (idx) {
                    final isCurrent = idx == _currentIndex;
                    final isAnswered = _answers.containsKey(idx);

                    return GestureDetector(
                      onTap: () => setState(() => _currentIndex = idx),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? const Color(0xFF38BDF8)
                              : isAnswered
                                  ? const Color(0xFF10B981).withValues(alpha: 0.2)
                                  : const Color(0xFF1E293B),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isCurrent ? Colors.white : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${idx + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isCurrent ? const Color(0xFF090D16) : Colors.white,
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 16),

                // Question Box
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131B2E),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              q.subjectName,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(q.unit, style: const TextStyle(fontSize: 11, color: Colors.white60)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        q.questionBody,
                        style: const TextStyle(fontSize: 15, height: 1.6, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Choices
                ...List.generate(q.choices.length, (idx) {
                  final choice = q.choices[idx];
                  final isSelected = selectedChoice == idx;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _answers[_currentIndex] = idx;
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF38BDF8).withValues(alpha: 0.15) : const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF38BDF8) : Colors.white10,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? const Color(0xFF38BDF8) : Colors.white12,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${idx + 1}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? const Color(0xFF090D16) : Colors.white70,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                choice,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isSelected ? Colors.white : Colors.white70,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 20),

                // Next / Prev navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentIndex > 0)
                      OutlinedButton.icon(
                        onPressed: () => setState(() => _currentIndex--),
                        icon: const Icon(Icons.arrow_back, size: 16),
                        label: const Text('前の問題'),
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.white70),
                      )
                    else
                      const SizedBox(),
                    if (_currentIndex < _questions.length - 1)
                      ElevatedButton.icon(
                        onPressed: () => setState(() => _currentIndex++),
                        icon: const Icon(Icons.arrow_forward, size: 16),
                        label: const Text('次の問題'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF38BDF8),
                          foregroundColor: const Color(0xFF090D16),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom Scratchpad Canvas
          if (_isScratchpadOpen)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ScratchpadCanvas(
                onClose: () => setState(() => _isScratchpadOpen = false),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    int correctCount = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_answers[i] == _questions[i].correctAnswerIndex) {
        correctCount++;
      }
    }
    final score = (_questions.isNotEmpty ? (correctCount / _questions.length) * 100 : 0).round();
    final deviation = (50 + (score - 60) * 0.4).clamp(40.0, 75.0).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        title: const Text('模試結果・採点レポート'),
        backgroundColor: const Color(0xFF0F172A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.emoji_events, color: Color(0xFFFBBF24), size: 48),
                  const SizedBox(height: 12),
                  Text(
                    '$score 点',
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '推定偏差値 $deviation (正答数: $correctCount / ${_questions.length})',
                    style: const TextStyle(fontSize: 13, color: Color(0xFF38BDF8), fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              '問題別振り返りと解説',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),

            const SizedBox(height: 12),

            ...List.generate(_questions.length, (idx) {
              final q = _questions[idx];
              final userAnswer = _answers[idx];
              final isCorrect = userAnswer == q.correctAnswerIndex;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF131B2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isCorrect ? const Color(0xFF10B981) : const Color(0xFFF43F5E), width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isCorrect ? Icons.check_circle : Icons.cancel,
                          color: isCorrect ? const Color(0xFF10B981) : const Color(0xFFF43F5E),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '第${idx + 1}問: ${q.subjectName} (${q.unit})',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      q.questionBody,
                      style: const TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '解説: ${q.explanation}',
                        style: const TextStyle(fontSize: 11, color: Colors.white60, height: 1.4),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              icon: const Icon(Icons.replay, size: 18),
              onPressed: () {
                setState(() {
                  _isExamStarted = false;
                  _isSubmitted = false;
                  _loadExamQuestions();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF38BDF8),
                foregroundColor: const Color(0xFF090D16),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              label: const Text('模試ロビーに戻る', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLobbyScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.timer_outlined, color: Color(0xFFF43F5E), size: 20),
            SizedBox(width: 8),
            Text(
              '共通テスト型 演習模試',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero card
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4C0519), Color(0xFF1E1B4B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFF43F5E).withValues(alpha: 0.4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF43F5E).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFF43F5E)),
                    ),
                    child: const Icon(Icons.assignment, color: Color(0xFFFDA4AF), size: 28),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    '大学入学共通テスト型 演習模試',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '5教科総合実力判定・制限時間タイマー対応',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Rules & features
            _buildLobbyInfoTile(
              icon: Icons.access_time_filled,
              iconColor: const Color(0xFFF59E0B),
              title: '制限時間 30分（1,800秒）',
              subtitle: '「模試を開始する」をタップした瞬間にカウントダウンが始動します。',
            ),
            const SizedBox(height: 10),
            _buildLobbyInfoTile(
              icon: Icons.quiz,
              iconColor: const Color(0xFF38BDF8),
              title: '全15問・5教科横断出題',
              subtitle: '数学・物理・化学・英語・国語・社会の頻出単元から総合出題。',
            ),
            const SizedBox(height: 10),
            _buildLobbyInfoTile(
              icon: Icons.draw,
              iconColor: const Color(0xFF34D399),
              title: '手書き計算メモ完備',
              subtitle: '画面上部の「手書きメモ」から、いつでも計算用紙を展開・伸縮できます。',
            ),
            const SizedBox(height: 10),
            _buildLobbyInfoTile(
              icon: Icons.auto_graph,
              iconColor: const Color(0xFFA855F7),
              title: '推定偏差値＆判定を即時算出',
              subtitle: '解答提出後、獲得スコアと推定偏差値を自動診断します。',
            ),

            const SizedBox(height: 28),

            // Start Button
            ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow, size: 22),
              label: const Text('模試を開始する', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 4,
              ),
              onPressed: _startExam,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLobbyInfoTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.white60, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
