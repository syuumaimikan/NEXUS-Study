import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/storage_service.dart';
import '../widgets/scratchpad_canvas.dart';
import '../widgets/visual_diagram_card.dart';

class PracticeScreen extends StatefulWidget {
  final List<Question> questions;
  final String title;
  final int initialIndex;

  const PracticeScreen({
    super.key,
    required this.questions,
    this.title = '演習モード',
    this.initialIndex = 0,
  });

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  late int _currentIndex;
  int? _selectedChoiceIndex;
  bool _isAnswered = false;
  bool _showExplanation = false;
  bool _showHint = false;
  bool _isScratchpadOpen = false;
  int _streak = 0;
  String _deviationFilter = 'すべて';
  String _unitFilter = '全分野';
  DateTime? _questionStartTime;
  bool _isSpeedBonus = false;

  List<String> get _availableUnits {
    final set = <String>{};
    for (var q in widget.questions) {
      if (q.unit.isNotEmpty) set.add(q.unit);
    }
    final sorted = set.toList()..sort();
    return ['全分野', ...sorted];
  }

  List<Question> get _filteredQuestions {
    return widget.questions.where((q) {
      bool matchesDev = true;
      if (_deviationFilter == '基礎 (~50)') {
        matchesDev = q.estimatedDeviation <= 50;
      } else if (_deviationFilter == '標準 (51~60)') {
        matchesDev = q.estimatedDeviation > 50 && q.estimatedDeviation <= 60;
      } else if (_deviationFilter == '難関 (61~68)') {
        matchesDev = q.estimatedDeviation > 60 && q.estimatedDeviation <= 68;
      } else if (_deviationFilter == '最難関 (69+)') {
        matchesDev = q.estimatedDeviation > 68;
      }

      bool matchesUnit = true;
      if (_unitFilter != '全分野') {
        matchesUnit = q.unit == _unitFilter;
      }

      return matchesDev && matchesUnit;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.questions.isNotEmpty ? widget.questions.length - 1 : 0);
    _questionStartTime = DateTime.now();
  }

  void _handleChoiceSelected(int index) {
    if (_isAnswered) return;

    final currentQuestions = _filteredQuestions;
    if (currentQuestions.isEmpty) return;
    final q = currentQuestions[_currentIndex.clamp(0, currentQuestions.length - 1)];
    final isCorrect = index == q.correctAnswerIndex;

    final elapsedSec = _questionStartTime != null ? DateTime.now().difference(_questionStartTime!).inSeconds : 10;
    final speedBonus = isCorrect && elapsedSec <= 5;

    setState(() {
      _selectedChoiceIndex = index;
      _isAnswered = true;
      _showExplanation = true;
      _isSpeedBonus = speedBonus;
      if (isCorrect) {
        _streak++;
      } else {
        _streak = 0;
      }
    });

    int extraCoins = 0;
    if (speedBonus) {
      extraCoins += 15;
    }
    if (_streak >= 5) {
      extraCoins += 25;
    } else if (_streak >= 3) {
      extraCoins += 10;
    }

    // Record stats in Storage
    StorageService().recordAttempt(
      isCorrect,
      isCorrect ? (q.baseXp + (speedBonus ? 50 : 0)) : 10,
      bonusCoins: extraCoins,
    );
  }

  void _nextQuestion() {
    final currentQuestions = _filteredQuestions;
    if (currentQuestions.isEmpty) return;
    setState(() {
      _selectedChoiceIndex = null;
      _isAnswered = false;
      _showExplanation = false;
      _showHint = false;
      _isSpeedBonus = false;
      _questionStartTime = DateTime.now();
      _currentIndex = (_currentIndex + 1) % currentQuestions.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestions = _filteredQuestions;

    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
            if (currentQuestions.isNotEmpty)
              Text(
                '問 ${_currentIndex + 1} / ${currentQuestions.length} (${currentQuestions[_currentIndex.clamp(0, currentQuestions.length - 1)].course})',
                style: const TextStyle(fontSize: 11, color: Color(0xFF38BDF8)),
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
              _isScratchpadOpen ? 'メモを閉じる' : '手書きメモ',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: _isScratchpadOpen ? const Color(0xFFFBBF24) : const Color(0xFF38BDF8),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(_availableUnits.length > 2 ? 74 : 38),
          child: Container(
            color: const Color(0xFF0F172A),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Deviation filter row
                Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.tune, size: 13, color: Color(0xFF38BDF8)),
                      const SizedBox(width: 4),
                      const Text('偏差値:', style: TextStyle(fontSize: 10, color: Colors.white70)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: ['すべて', '基礎 (~50)', '標準 (51~60)', '難関 (61~68)', '最難関 (69+)'].map((filter) {
                              final isSel = _deviationFilter == filter;
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: InkWell(
                                  onTap: () {
                                    if (_deviationFilter != filter) {
                                      setState(() {
                                        _deviationFilter = filter;
                                        _currentIndex = 0;
                                        _selectedChoiceIndex = null;
                                        _isAnswered = false;
                                        _showExplanation = false;
                                        _showHint = false;
                                      });
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isSel ? const Color(0xFF38BDF8).withValues(alpha: 0.25) : Colors.white10,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: isSel ? const Color(0xFF38BDF8) : Colors.transparent),
                                    ),
                                    child: Text(
                                      filter,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                        color: isSel ? const Color(0xFF38BDF8) : Colors.white70,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Unit / Topic filter row
                if (_availableUnits.length > 2)
                  Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: Color(0xFF1E293B))),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.category, size: 13, color: Color(0xFF818CF8)),
                        const SizedBox(width: 4),
                        const Text('分野:', style: TextStyle(fontSize: 10, color: Colors.white70)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: _availableUnits.map((unit) {
                                final isSel = _unitFilter == unit;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: InkWell(
                                    onTap: () {
                                      if (_unitFilter != unit) {
                                        setState(() {
                                          _unitFilter = unit;
                                          _currentIndex = 0;
                                          _selectedChoiceIndex = null;
                                          _isAnswered = false;
                                          _showExplanation = false;
                                          _showHint = false;
                                        });
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: isSel ? const Color(0xFF818CF8).withValues(alpha: 0.25) : Colors.white10,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: isSel ? const Color(0xFF818CF8) : Colors.transparent),
                                      ),
                                      child: Text(
                                        unit,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                          color: isSel ? const Color(0xFFA5B4FC) : Colors.white70,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      body: currentQuestions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.filter_alt_off, size: 48, color: Colors.white38),
                  const SizedBox(height: 12),
                  Text(
                    '該当する難易度・分野の問題がありません\n(偏差値: $_deviationFilter / 分野: $_unitFilter)',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _deviationFilter = 'すべて';
                        _unitFilter = '全分野';
                        _currentIndex = 0;
                      });
                    },
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('絞り込みを解除'),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF38BDF8), foregroundColor: Colors.black),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                // Scrollable problem & choices
                Builder(
                  builder: (context) {
                    final q = currentQuestions[_currentIndex.clamp(0, currentQuestions.length - 1)];
                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                // Info badges row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        '難易度 ${q.difficulty}',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '推定偏差値 ${q.estimatedDeviation}',
                        style: const TextStyle(fontSize: 10, color: Colors.white70),
                      ),
                    ),
                    const Spacer(),
                    if (_isSpeedBonus) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBBF24).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFBBF24)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.bolt, color: Color(0xFFFBBF24), size: 14),
                            SizedBox(width: 2),
                            Text(
                              '神速ボーナス! +15G',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFFBBF24)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    if (_streak > 1)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFF59E0B)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.local_fire_department, color: Color(0xFFF59E0B), size: 14),
                            const SizedBox(width: 2),
                            Text(
                              '$_streak 連勝!',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B)),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                // Question Card
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
                          const Icon(Icons.quiz_outlined, size: 16, color: Color(0xFF38BDF8)),
                          const SizedBox(width: 6),
                          Text(
                            q.unit,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        q.questionBody,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Hint Accordion
                if (q.hints.isNotEmpty)
                  GestureDetector(
                    onTap: () => setState(() => _showHint = !_showHint),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFFBBF24).withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.lightbulb_outline, size: 16, color: Color(0xFFFBBF24)),
                              const SizedBox(width: 8),
                              const Text(
                                'ヒントを見る',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFFBBF24)),
                              ),
                              const Spacer(),
                              Icon(
                                _showHint ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                size: 18,
                                color: const Color(0xFFFBBF24),
                              ),
                            ],
                          ),
                          if (_showHint) ...[
                            const SizedBox(height: 8),
                            ...q.hints.map((h) => Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    '• $h',
                                    style: const TextStyle(fontSize: 12, color: Colors.white70, height: 1.4),
                                  ),
                                )),
                          ],
                        ],
                      ),
                    ),
                  ),

                // Choices
                ...List.generate(q.choices.length, (idx) {
                  final choice = q.choices[idx];
                  final isSelected = _selectedChoiceIndex == idx;
                  final isCorrect = idx == q.correctAnswerIndex;

                  Color bgColor = const Color(0xFF0F172A);
                  Color borderColor = Colors.white12;
                  Color textColor = Colors.white;
                  IconData? statusIcon;

                  if (_isAnswered) {
                    if (isCorrect) {
                      bgColor = const Color(0xFF064E3B).withValues(alpha: 0.5);
                      borderColor = const Color(0xFF10B981);
                      textColor = const Color(0xFF6EE7B7);
                      statusIcon = Icons.check_circle_outline;
                    } else if (isSelected) {
                      bgColor = const Color(0xFF881337).withValues(alpha: 0.5);
                      borderColor = const Color(0xFFF43F5E);
                      textColor = const Color(0xFFFDA4AF);
                      statusIcon = Icons.cancel_outlined;
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () => _handleChoiceSelected(idx),
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor, width: isSelected || (_isAnswered && isCorrect) ? 1.8 : 1),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${idx + 1}',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white70),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                choice,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                  height: 1.4,
                                ),
                              ),
                            ),
                            if (statusIcon != null)
                              Icon(statusIcon, color: borderColor, size: 20),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                // Detailed Explanation Card (appears after answering)
                if (_showExplanation) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF131B2E),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _selectedChoiceIndex == q.correctAnswerIndex
                                  ? Icons.check_circle
                                  : Icons.info_outline,
                              size: 18,
                              color: _selectedChoiceIndex == q.correctAnswerIndex
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFF38BDF8),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _selectedChoiceIndex == q.correctAnswerIndex
                                  ? '正解！解説'
                                  : '不正解・解説',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: _selectedChoiceIndex == q.correctAnswerIndex
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFF38BDF8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          q.explanation,
                          style: const TextStyle(fontSize: 13, height: 1.6, color: Colors.white70),
                        ),
                        // Dynamic Visualization Diagram
                        VisualDiagramCard(
                          subjectId: q.subjectId,
                          questionText: q.questionBody,
                          explanation: q.explanation,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _nextQuestion,
                          icon: const Icon(Icons.arrow_forward, size: 16),
                          label: const Text('次の問題へ進む'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF38BDF8),
                            foregroundColor: const Color(0xFF090D16),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            minimumSize: const Size(double.infinity, 44),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),

          // Bottom Handwriting Scratchpad
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
}
