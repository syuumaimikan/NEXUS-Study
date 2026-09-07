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

  const ProgressAnalyticsWidget({
    super.key,
    required this.totalAttempts,
    required this.totalCorrect,
    required this.level,
    required this.currentXp,
    required this.nextLevelXp,
    required this.targetUniversity,
  });

  @override
  State<ProgressAnalyticsWidget> createState() => _ProgressAnalyticsWidgetState();
}

class _ProgressAnalyticsWidgetState extends State<ProgressAnalyticsWidget> {
  List<Map<String, dynamic>> _weeklyData = [];

  @override
  void initState() {
    super.initState();
    _loadWeeklyActivity();
  }

  void _loadWeeklyActivity() async {
    final list = await StorageService().getWeeklyActivity();
    setState(() {
      _weeklyData = list;
    });
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

        // 2. Accuracy & Mastery by Subject Group
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
              _buildSubjectBar('数学（I/A/II/B/C/III）', 0.78, const Color(0xFF38BDF8)),
              const SizedBox(height: 10),
              _buildSubjectBar('理科（物理・化学・生物・地学）', 0.84, const Color(0xFFF59E0B)),
              const SizedBox(height: 10),
              _buildSubjectBar('英語（文法・読解・語彙）', 0.88, const Color(0xFF10B981)),
              const SizedBox(height: 10),
              _buildSubjectBar('国語（現代文・古文・漢文）', 0.72, const Color(0xFFA855F7)),
              const SizedBox(height: 10),
              _buildSubjectBar('地歴・公民（歴史・地理・倫政）', 0.80, const Color(0xFFF43F5E)),
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
                      '推定偏差値: ${math.min(75, 52 + (widget.level * 1.5)).toStringAsFixed(1)} (順調に向上中)',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 11, color: Colors.white70)),
            Text('${(ratio * 100).toInt()}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
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
    for (final item in weeklyData) {
      final c = item['count'] as int? ?? 0;
      if (c > maxCount) maxCount = c;
    }

    // Grid baseline
    final linePaint = Paint()
      ..color = Colors.white12
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, size.height - 20), Offset(size.width, size.height - 20), linePaint);

    for (int i = 0; i < weeklyData.length; i++) {
      final item = weeklyData[i];
      final dayLabel = item['day'] as String? ?? '';
      final count = item['count'] as int? ?? 0;
      final isToday = (i == weeklyData.length - 1);

      final centerX = (size.width / weeklyData.length) * (i + 0.5);
      final chartH = size.height - 30;
      final barH = math.max(4.0, (count / maxCount) * chartH);

      final barRect = Rect.fromCenter(
        center: Offset(centerX, (size.height - 20) - barH / 2),
        width: barWidth,
        height: barH,
      );

      final barPaint = Paint()
        ..color = isToday ? const Color(0xFF38BDF8) : const Color(0xFF1E293B);
      canvas.drawRRect(RRect.fromRectAndRadius(barRect, const Radius.circular(4)), barPaint);

      if (isToday) {
        // Glow outline for today
        final glowPaint = Paint()
          ..color = const Color(0xFF38BDF8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
        canvas.drawRRect(RRect.fromRectAndRadius(barRect, const Radius.circular(4)), glowPaint);
      }

      // Day text
      final textPainter = TextPainter(
        text: TextSpan(
          text: dayLabel,
          style: TextStyle(
            color: isToday ? const Color(0xFF38BDF8) : Colors.white54,
            fontSize: 10,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(centerX - textPainter.width / 2, size.height - 16));
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

    // Background track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white12
        ..strokeWidth = 6
        ..style = PaintingStyle.stroke,
    );

    // Active progress arc
    final sweepAngle = 2 * math.pi * ratio;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      Paint()
        ..color = color
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    // Percentage text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${(ratio * 100).toInt()}%',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) => oldDelegate.ratio != ratio;
}
