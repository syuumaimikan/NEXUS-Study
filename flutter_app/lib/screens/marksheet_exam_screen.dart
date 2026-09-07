import 'package:flutter/material.dart';

class MarkSheetExamScreen extends StatefulWidget {
  const MarkSheetExamScreen({super.key});

  @override
  State<MarkSheetExamScreen> createState() => _MarkSheetExamScreenState();
}

class _MarkSheetExamScreenState extends State<MarkSheetExamScreen> {
  final int _totalQuestions = 25;
  late List<int?> _markedAnswers;
  late List<int> _correctAnswers;
  bool _isSubmitted = false;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _markedAnswers = List.filled(_totalQuestions, null);
    // Deterministic answer key for testing
    _correctAnswers = List.generate(_totalQuestions, (i) => (i % 4) + 1);
  }

  void _onBubbleTapped(int questionIdx, int bubbleValue) {
    if (_isSubmitted) return;
    setState(() {
      if (_markedAnswers[questionIdx] == bubbleValue) {
        _markedAnswers[questionIdx] = null; // erase
      } else {
        _markedAnswers[questionIdx] = bubbleValue; // fill
      }
    });
  }

  void _submitExam() {
    final unfilled = _markedAnswers.where((a) => a == null).length;
    if (unfilled > 0) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFF59E0B), size: 22),
              SizedBox(width: 8),
              Text('マーク漏れ注意', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text('未記入のマーク欄が $unfilled 箇所あります。このまま採点しますか？', style: const TextStyle(color: Colors.white70, fontSize: 13)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('マークに戻る', style: TextStyle(color: Colors.white60)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                _gradeExam();
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF38BDF8), foregroundColor: Colors.black),
              child: const Text('採点する', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } else {
      _gradeExam();
    }
  }

  void _gradeExam() {
    int correctCount = 0;
    for (int i = 0; i < _totalQuestions; i++) {
      if (_markedAnswers[i] == _correctAnswers[i]) {
        correctCount++;
      }
    }
    setState(() {
      _isSubmitted = true;
      _score = (correctCount * 100 / _totalQuestions).round();
    });
  }

  void _resetSheet() {
    setState(() {
      _markedAnswers = List.filled(_totalQuestions, null);
      _isSubmitted = false;
      _score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filledCount = _markedAnswers.where((a) => a != null).length;

    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.edit_note, color: Color(0xFF38BDF8), size: 22),
            SizedBox(width: 8),
            Text('共通テスト マークシート再現演習', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt, color: Colors.white70),
            tooltip: 'マークシートを消去してリセット',
            onPressed: _resetSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Status Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFF131B2E),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.mode_edit_outline, color: Color(0xFF38BDF8), size: 16),
                    const SizedBox(width: 6),
                    Text(
                      '記入済み: $filledCount / $_totalQuestions 問',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (_isSubmitted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF10B981)),
                    ),
                    child: Text(
                      '得点: $_score 点',
                      style: const TextStyle(color: Color(0xFF34D399), fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  )
                else
                  Text(
                    '未記入: ${_totalQuestions - filledCount} 問',
                    style: TextStyle(
                      color: (_totalQuestions - filledCount) > 0 ? const Color(0xFFF59E0B) : const Color(0xFF34D399),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),

          // Authentic Bubble Sheet Card
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white12),
              ),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _totalQuestions,
                separatorBuilder: (_, _) => const Divider(height: 1, color: Colors.white10),
                itemBuilder: (context, idx) {
                  final qNum = idx + 1;
                  final selected = _markedAnswers[idx];
                  final correct = _correctAnswers[idx];
                  final isCorrect = selected == correct;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        // Question Number Box
                        Container(
                          width: 38,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$qNum',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // 4 Oval Bubbles: ①, ②, ③, ④
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(4, (bIdx) {
                              final bubbleVal = bIdx + 1;
                              final isMarked = selected == bubbleVal;

                              Color bubbleBg = Colors.transparent;
                              Color bubbleBorder = Colors.white38;
                              Color textColor = Colors.white70;

                              if (_isSubmitted) {
                                if (bubbleVal == correct) {
                                  bubbleBg = const Color(0xFF10B981);
                                  bubbleBorder = const Color(0xFF10B981);
                                  textColor = Colors.black;
                                } else if (isMarked && !isCorrect) {
                                  bubbleBg = const Color(0xFFF43F5E);
                                  bubbleBorder = const Color(0xFFF43F5E);
                                  textColor = Colors.white;
                                }
                              } else if (isMarked) {
                                // Authentic HB Pencil Graphite fill
                                bubbleBg = const Color(0xFF22262B);
                                bubbleBorder = const Color(0xFF38BDF8);
                                textColor = const Color(0xFF38BDF8);
                              }

                              return InkWell(
                                onTap: () => _onBubbleTapped(idx, bubbleVal),
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: 44,
                                  height: 28,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: bubbleBg,
                                    borderRadius: BorderRadius.circular(14), // Oval bubble
                                    border: Border.all(
                                      color: isMarked && !_isSubmitted ? const Color(0xFF38BDF8) : bubbleBorder,
                                      width: isMarked ? 2.0 : 1.2,
                                    ),
                                    boxShadow: isMarked && !_isSubmitted
                                        ? [
                                            BoxShadow(
                                              color: const Color(0xFF38BDF8).withValues(alpha: 0.3),
                                              blurRadius: 4,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Text(
                                    '$bubbleVal',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 12,
                                      fontWeight: isMarked ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),

                        // Result Status (If submitted)
                        if (_isSubmitted)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Icon(
                              isCorrect ? Icons.check_circle : Icons.cancel,
                              color: isCorrect ? const Color(0xFF10B981) : const Color(0xFFF43F5E),
                              size: 18,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF0F172A),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isSubmitted ? _resetSheet : _submitExam,
                icon: Icon(_isSubmitted ? Icons.restart_alt : Icons.check_circle_outline, size: 20),
                label: Text(
                  _isSubmitted ? 'もう一度演習する' : 'マークシートを提出して自動採点',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isSubmitted ? const Color(0xFF10B981) : const Color(0xFF38BDF8),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
