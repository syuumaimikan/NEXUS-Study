import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class PomodoroFocusScreen extends StatefulWidget {
  const PomodoroFocusScreen({super.key});

  @override
  State<PomodoroFocusScreen> createState() => _PomodoroFocusScreenState();
}

class _PomodoroFocusScreenState extends State<PomodoroFocusScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ambientController;
  Timer? _timer;

  int _focusMinutes = 25;
  final int _breakMinutes = 5;
  int _remainingSeconds = 25 * 60;
  bool _isRunning = false;
  bool _isBreak = false;
  int _completedSessions = 0;
  int _totalFocusMinutes = 0;

  int _selectedSoundIndex = 0;
  final List<Map<String, dynamic>> _ambientSounds = [
    {'title': '静寂の図書館', 'sub': '穏やかな集中空間', 'icon': Icons.local_library_outlined, 'color': Color(0xFF38BDF8)},
    {'title': '優しい雨音', 'sub': 'α波を促進するホワイトノイズ', 'icon': Icons.water_drop_outlined, 'color': Color(0xFF06B6D4)},
    {'title': 'カフェのざわめき', 'sub': '適度な環境音で集中', 'icon': Icons.coffee_outlined, 'color': Color(0xFFF59E0B)},
    {'title': '夜の焚き火', 'sub': '1/f ゆらぎのやすらぎ', 'icon': Icons.fireplace_outlined, 'color': Color(0xFFF43F5E)},
  ];

  @override
  void initState() {
    super.initState();
    _ambientController = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
    _remainingSeconds = _focusMinutes * 60;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ambientController.dispose();
    super.dispose();
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          setState(() {
            _remainingSeconds--;
          });
        } else {
          // Switch phase
          timer.cancel();
          _onPhaseCompleted();
        }
      });
    }
  }

  void _onPhaseCompleted() {
    if (!_isBreak) {
      // Completed a focus session
      setState(() {
        _completedSessions++;
        _totalFocusMinutes += _focusMinutes;
        _isBreak = true;
        _remainingSeconds = _breakMinutes * 60;
        _isRunning = false;
      });
      _showPhaseDialog('集中セッション完了！', '5分間の休憩に入りましょう。深呼吸やストレッチを。');
    } else {
      // Completed a break
      setState(() {
        _isBreak = false;
        _remainingSeconds = _focusMinutes * 60;
        _isRunning = false;
      });
      _showPhaseDialog('休憩終了！', '次の集中セッションを開始しましょう。');
    }
  }

  void _showPhaseDialog(String title, String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(_isBreak ? Icons.coffee : Icons.check_circle, color: const Color(0xFF38BDF8), size: 24),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(message, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF38BDF8), foregroundColor: Colors.black),
            child: const Text('了解', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingSeconds = (_isBreak ? _breakMinutes : _focusMinutes) * 60;
    });
  }

  void _changeDuration(int focusM) {
    _timer?.cancel();
    setState(() {
      _focusMinutes = focusM;
      _isRunning = false;
      _isBreak = false;
      _remainingSeconds = focusM * 60;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalSec = (_isBreak ? _breakMinutes : _focusMinutes) * 60;
    final progress = (totalSec - _remainingSeconds) / totalSec;
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    final timeStr = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    final currentSound = _ambientSounds[_selectedSoundIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.hourglass_top, color: Color(0xFF38BDF8), size: 22),
            SizedBox(width: 8),
            Text('ポモドーロ集中タイマー', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Mode Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _isBreak ? const Color(0xFF10B981).withValues(alpha: 0.2) : const Color(0xFF38BDF8).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _isBreak ? const Color(0xFF10B981) : const Color(0xFF38BDF8)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_isBreak ? Icons.coffee : Icons.psychology, color: _isBreak ? const Color(0xFF34D399) : const Color(0xFF38BDF8), size: 16),
                  const SizedBox(width: 6),
                  Text(
                    _isBreak ? 'リフレッシュ休憩モード (5分)' : '超集中学習モード ($_focusMinutes分)',
                    style: TextStyle(
                      color: _isBreak ? const Color(0xFF34D399) : const Color(0xFF38BDF8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Circular Countdown Timer with Ambient Particle Visualizer
            Center(
              child: SizedBox(
                width: 240,
                height: 240,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Dynamic ambient aura
                    AnimatedBuilder(
                      animation: _ambientController,
                      builder: (context, child) {
                        return CustomPaint(
                          size: const Size(240, 240),
                          painter: _AmbientAuraPainter(
                            progress: _ambientController.value,
                            color: currentSound['color'] as Color,
                            isRunning: _isRunning,
                          ),
                        );
                      },
                    ),

                    // Progress Ring
                    SizedBox(
                      width: 210,
                      height: 210,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 10,
                        backgroundColor: Colors.white12,
                        valueColor: AlwaysStoppedAnimation(
                          _isBreak ? const Color(0xFF10B981) : const Color(0xFF38BDF8),
                        ),
                      ),
                    ),

                    // Center Time Display
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          timeStr,
                          style: const TextStyle(
                            fontSize: 46,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isBreak ? '小休憩中' : '集中中',
                          style: TextStyle(
                            fontSize: 12,
                            color: _isBreak ? const Color(0xFF34D399) : const Color(0xFF38BDF8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Duration Presets (25m / 50m / 15m)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDurationChip(15, '15分 (短時間特訓)'),
                const SizedBox(width: 8),
                _buildDurationChip(25, '25分 (標準ポモドーロ)'),
                const SizedBox(width: 8),
                _buildDurationChip(50, '50分 (本番模試形式)'),
              ],
            ),

            const SizedBox(height: 24),

            // Main Play / Pause Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filled(
                  onPressed: _resetTimer,
                  icon: const Icon(Icons.refresh, size: 22),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF1E293B),
                    foregroundColor: Colors.white70,
                    padding: const EdgeInsets.all(14),
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 140,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: _toggleTimer,
                    icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow, size: 24),
                    label: Text(_isRunning ? '一時停止' : 'スタート', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isBreak ? const Color(0xFF10B981) : const Color(0xFF38BDF8),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                IconButton.filled(
                  onPressed: () {
                    // Skip to next phase
                    _onPhaseCompleted();
                  },
                  icon: const Icon(Icons.skip_next, size: 22),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF1E293B),
                    foregroundColor: Colors.white70,
                    padding: const EdgeInsets.all(14),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Ambient Sound Selector Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF131B2E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.headphones, color: Color(0xFF38BDF8), size: 18),
                      SizedBox(width: 8),
                      Text(
                        '集中環境音 (アンビエントサウンド)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: List.generate(_ambientSounds.length, (idx) {
                      final s = _ambientSounds[idx];
                      final isSel = idx == _selectedSoundIndex;
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (s['color'] as Color).withValues(alpha: isSel ? 0.25 : 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(s['icon'] as IconData, color: s['color'] as Color, size: 18),
                        ),
                        title: Text(
                          s['title'] as String,
                          style: TextStyle(
                            color: isSel ? Colors.white : Colors.white70,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12.5,
                          ),
                        ),
                        subtitle: Text(
                          s['sub'] as String,
                          style: const TextStyle(color: Colors.white38, fontSize: 10.5),
                        ),
                        trailing: Icon(
                          isSel ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                          color: isSel ? const Color(0xFF38BDF8) : Colors.white38,
                          size: 20,
                        ),
                        onTap: () => setState(() => _selectedSoundIndex = idx),
                      );
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Session Stats
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text('完了セッション', style: TextStyle(color: Colors.white60, fontSize: 11)),
                      const SizedBox(height: 4),
                      Text('$_completedSessions 回', style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Container(width: 1, height: 32, color: Colors.white12),
                  Column(
                    children: [
                      const Text('本日集中時間', style: TextStyle(color: Colors.white60, fontSize: 11)),
                      const SizedBox(height: 4),
                      Text('$_totalFocusMinutes 分', style: const TextStyle(color: Color(0xFFFBBF24), fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationChip(int minutes, String label) {
    final isSel = _focusMinutes == minutes;
    return InkWell(
      onTap: () => _changeDuration(minutes),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSel ? const Color(0xFF38BDF8).withValues(alpha: 0.2) : const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSel ? const Color(0xFF38BDF8) : Colors.white10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSel ? const Color(0xFF38BDF8) : Colors.white60,
            fontSize: 10.5,
            fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _AmbientAuraPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isRunning;

  _AmbientAuraPainter({required this.progress, required this.color, required this.isRunning});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width / 2 - 16;

    if (isRunning) {
      final waveRadius = baseRadius + 12 * math.sin(progress * 2 * math.pi);
      final auraPaint = Paint()
        ..color = color.withValues(alpha: 0.12 + 0.08 * math.sin(progress * 2 * math.pi))
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, waveRadius, auraPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _AmbientAuraPainter oldDelegate) => true;
}
