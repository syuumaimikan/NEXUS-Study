import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class SortVisualizerLabWidget extends StatefulWidget {
  const SortVisualizerLabWidget({super.key});

  @override
  State<SortVisualizerLabWidget> createState() => _SortVisualizerLabWidgetState();
}

class _SortVisualizerLabWidgetState extends State<SortVisualizerLabWidget> {
  final List<int> _numbers = [];
  final int _count = 12;

  int _currentIndex = -1;
  int _compareIndex = -1;
  final Set<int> _sortedIndices = {};

  int _comparisons = 0;
  int _swaps = 0;
  bool _isRunning = false;
  Timer? _timer;

  int _stepI = 0;
  int _stepJ = 0;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _reset() {
    _timer?.cancel();
    _isRunning = false;
    _comparisons = 0;
    _swaps = 0;
    _stepI = 0;
    _stepJ = 0;
    _currentIndex = -1;
    _compareIndex = -1;
    _sortedIndices.clear();

    final rng = math.Random();
    _numbers.clear();
    for (int i = 0; i < _count; i++) {
      _numbers.add(rng.nextInt(85) + 15);
    }
    setState(() {});
  }

  void _stepBubbleSort() {
    if (_numbers.length < 2) return;

    if (_stepI >= _numbers.length - 1) {
      // Completed
      _timer?.cancel();
      _isRunning = false;
      _sortedIndices.addAll(List.generate(_numbers.length, (i) => i));
      _currentIndex = -1;
      _compareIndex = -1;
      setState(() {});
      return;
    }

    _currentIndex = _stepJ;
    _compareIndex = _stepJ + 1;
    _comparisons++;

    if (_numbers[_stepJ] > _numbers[_stepJ + 1]) {
      final temp = _numbers[_stepJ];
      _numbers[_stepJ] = _numbers[_stepJ + 1];
      _numbers[_stepJ + 1] = temp;
      _swaps++;
    }

    _stepJ++;
    if (_stepJ >= _numbers.length - 1 - _stepI) {
      _sortedIndices.add(_numbers.length - 1 - _stepI);
      _stepJ = 0;
      _stepI++;
    }

    setState(() {});
  }

  void _toggleAutoPlay() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(milliseconds: 250), (timer) {
        if (_stepI >= _numbers.length - 1) {
          timer.cancel();
          setState(() {
            _isRunning = false;
            _sortedIndices.addAll(List.generate(_numbers.length, (i) => i));
            _currentIndex = -1;
            _compareIndex = -1;
          });
        } else {
          _stepBubbleSort();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.terminal, color: Color(0xFF38BDF8), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'バブルソート (隣接交換法) の可視化',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  '隣り合う要素の大小を比較し、順序が逆であれば交換することを繰り返します。計算量: O(n²)',
                  style: TextStyle(fontSize: 11, color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Bar Chart Canvas
          Container(
            height: 220,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0B1120),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_numbers.length, (i) {
                final val = _numbers[i];
                final isComparing = (i == _currentIndex || i == _compareIndex);
                final isSorted = _sortedIndices.contains(i);

                Color barColor;
                if (isComparing) {
                  barColor = const Color(0xFFF43F5E); // Active comparison in Rose
                } else if (isSorted) {
                  barColor = const Color(0xFF10B981); // Sorted in Emerald
                } else {
                  barColor = const Color(0xFF38BDF8); // Unsorted in Cyan
                }

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '$val',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: isComparing ? const Color(0xFFF43F5E) : Colors.white60,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          height: (val / 100.0) * 140,
                          decoration: BoxDecoration(
                            color: barColor,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                            boxShadow: isComparing
                                ? [
                                    BoxShadow(
                                      color: barColor.withValues(alpha: 0.5),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 16),

          // Metrics
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('比較回数', '$_comparisons 回', const Color(0xFF38BDF8)),
                _buildStat('交換回数', '$_swaps 回', const Color(0xFFF43F5E)),
                _buildStat('確定済み', '${_sortedIndices.length} / ${_numbers.length}', const Color(0xFF10B981)),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Controls
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow, size: 20),
                  label: Text(
                    _isRunning ? '一時停止' : '自動実行',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38BDF8),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _toggleAutoPlay,
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.skip_next, size: 18),
                label: const Text('1ステップ', style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isRunning ? null : _stepBubbleSort,
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                icon: const Icon(Icons.shuffle, size: 18),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  foregroundColor: Colors.white70,
                ),
                tooltip: 'シャッフル・リセット',
                onPressed: _reset,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white60)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
