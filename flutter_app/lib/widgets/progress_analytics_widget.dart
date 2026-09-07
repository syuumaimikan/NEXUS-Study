import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ProgressAnalyticsWidget extends StatefulWidget {
  final int totalAttempts;
  final int totalCorrect;
  final int level;
  final int currentXp;
  final int nextLevelXp;
  final String targetUniversity;
  final double targetDeviation;

  const ProgressAnalyticsWidget({
    super.key,
    required this.totalAttempts,
    required this.totalCorrect,
    required this.level,
    required this.currentXp,
    required this.nextLevelXp,
    required this.targetUniversity,
    this.targetDeviation = 65.0,
  });

  @override
  State<ProgressAnalyticsWidget> createState() => _ProgressAnalyticsWidgetState();
}

class _ProgressAnalyticsWidgetState extends State<ProgressAnalyticsWidget> {
  List<Map<String, dynamic>> _weeklyData = [];
  Map<String, double> _subjectMasteries = {
    'math': 0.0,
    'science': 0.0,
    'english': 0.0,
    'japanese': 0.0,
    'social': 0.0,
  };

  @override
  void initState() {
    super.initState();
    _loadWeeklyActivity();
    _loadSubjectMasteries();
  }

  void _loadWeeklyActivity() async {
    final list = await StorageService().getWeeklyActivity();
    if (mounted) {
      setState(() {
        _weeklyData = list;
      });
    }
  }

  void _loadSubjectMasteries() async {
    final map = await StorageService().getSubjectMasteries();
    if (mounted) {
      setState(() {
        _subjectMasteries = map;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final accuracy = widget.totalAttempts > 0
        ? ((widget.totalCorrect / widget.totalAttempts) * 100).round()
        : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Weekly Activity Bar Chart
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
              const Row(
                children: [
                  Icon(Icons.bar_chart, color: Color(0xFF38BDF8), size: 18),
                  SizedBox(width: 8),
                  Text(
                    '週間学習アクティビティ (過去7日間)',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                width: double.infinity,
                child: CustomPaint(
                  painter: _WeeklyBarChartPainter(weeklyData: _weeklyData),
                  size: Size.infinite,
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  '毎日の継続演習が学力定着の鍵です',
                  style: TextStyle(fontSize: 10, color: Colors.white38),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 2. Accuracy & Mastery by Subject Group (Dynamic / Starts at 0%)
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.analytics_outlined, color: Color(0xFF10B981), size: 18),
                      SizedBox(width: 8),
                      Text(
                        '教科別習熟度・正答率',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  Text(
                    '全体正答率: $accuracy%',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildSubjectBar('数学（I/A/II/B/C/III）', _subjectMasteries['math'] ?? 0.0, const Color(0xFF38BDF8)),
              const SizedBox(height: 10),
              _buildSubjectBar('理科（物理・化学・生物・地学）', _subjectMasteries['science'] ?? 0.0, const Color(0xFFF59E0B)),
              const SizedBox(height: 10),
              _buildSubjectBar('英語（文法・読解・語彙）', _subjectMasteries['english'] ?? 0.0, const Color(0xFF10B981)),
              const SizedBox(height: 10),
              _buildSubjectBar('国語（現代文・古文・漢文）', _subjectMasteries['japanese'] ?? 0.0, const Color(0xFFA855F7)),
              const SizedBox(height: 10),
              _buildSubjectBar('地歴・公民（歴史・地理・倫政）', _subjectMasteries['social'] ?? 0.0, const Color(0xFFF43F5E)),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 3. Target Exam Deviation & Progress Gauge
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF818CF8).withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: CustomPaint(
                  painter: _GaugePainter(
                    ratio: (widget.currentXp / math.max(1, widget.nextLevelXp)).clamp(0.0, 1.0),
                    color: const Color(0xFF818CF8),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level ${widget.level} 学習ステータス',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '目標志望校: ${widget.targetUniversity.isEmpty ? '未設定' : widget.targetUniversity}',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF818CF8), fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '目標偏差値: ${widget.targetDeviation.toStringAsFixed(1)} (推定値: ${math.min(78, 48 + (widget.level * 1.5) + (accuracy * 0.15)).toStringAsFixed(1)})',
                      style: const TextStyle(fontSize: 11, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectBar(String title, double ratio, Color color) {
    final pct = (ratio * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 11, color: Colors.white70)),
            Text(
              ratio > 0 ? '$pct%' : '未着手 (0%)',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ratio > 0 ? color : Colors.white38),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: ratio.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: Colors.white.withValues(alpha: 0.08),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _WeeklyBarChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> weeklyData;

  _WeeklyBarChartPainter({required this.weeklyData});

  @override
  void paint(Canvas canvas, Size size) {
    if (weeklyData.isEmpty) return;

    final barWidth = size.width / (weeklyData.length * 2);
    int maxCount = 10;
    for (final d in weeklyData) {
      final c = (d['count'] as num?)?.toInt() ?? 0;
      if (c > maxCount) maxCount = c;
    }

    final chartHeight = size.height - 24;

    for (int i = 0; i < weeklyData.length; i++) {
      final d = weeklyData[i];
      final count = (d['count'] as num?)?.toInt() ?? 0;
      final day = d['day'] as String? ?? '';

      final x = (i * 2 + 0.5) * barWidth;
      final h = maxCount > 0 ? (count / maxCount) * chartHeight : 0.0;
      final y = chartHeight - h;

      // Draw background pillar
      final bgPaint = Paint()..color = Colors.white.withValues(alpha: 0.05);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, 0, barWidth, chartHeight), const Radius.circular(4)),
        bgPaint,
      );

      // Draw active bar
      if (count > 0) {
        final barPaint = Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFF38BDF8), Color(0xFF3B82F6)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ).createShader(Rect.fromLTWH(x, y, barWidth, h));

        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(x, y, barWidth, h), const Radius.circular(4)),
          barPaint,
        );

        // Value text
        final valPainter = TextPainter(
          text: TextSpan(text: '$count', style: const TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold)),
          textDirection: TextDirection.ltr,
        )..layout();
        valPainter.paint(canvas, Offset(x + (barWidth - valPainter.width) / 2, y - 12));
      }

      // Day label
      final dayPainter = TextPainter(
        text: TextSpan(text: day, style: const TextStyle(fontSize: 9, color: Colors.white60)),
        textDirection: TextDirection.ltr,
      )..layout();
      dayPainter.paint(canvas, Offset(x + (barWidth - dayPainter.width) / 2, size.height - 16));
    }
  }

  @override
  bool shouldRepaint(covariant _WeeklyBarChartPainter oldDelegate) => true;
}

class _GaugePainter extends CustomPainter {
  final double ratio;
  final Color color;

  _GaugePainter({required this.ratio, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, bgPaint);

    final fgPaint = Paint()
      ..color = color
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * ratio,
      false,
      fgPaint,
    );

    final text = '${(ratio * 100).round()}%';
    final tp = TextPainter(
      text: TextSpan(text: text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.ratio != ratio || oldDelegate.color != color;
}
