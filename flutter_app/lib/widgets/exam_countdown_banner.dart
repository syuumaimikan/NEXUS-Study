import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class ExamCountdownBanner extends StatefulWidget {
  final UserProfile profile;
  final VoidCallback? onTap;

  const ExamCountdownBanner({super.key, required this.profile, this.onTap});

  @override
  State<ExamCountdownBanner> createState() => _ExamCountdownBannerState();
}

class _ExamCountdownBannerState extends State<ExamCountdownBanner> {
  int _targetExamIndex = 0;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // 1. Common Test: approx Jan 16
    var commonTestDate = DateTime(now.year, 1, 16);
    if (now.isAfter(commonTestDate)) {
      commonTestDate = DateTime(now.year + 1, 1, 16);
    }
    final commonTestDays = commonTestDate.difference(now).inDays + 1;

    // 2. National 2nd Stage: Feb 25
    var national2ndDate = DateTime(now.year, 2, 25);
    if (now.isAfter(national2ndDate)) {
      national2ndDate = DateTime(now.year + 1, 2, 25);
    }
    final national2ndDays = national2ndDate.difference(now).inDays + 1;

    // 3. Private / High School: Feb 1
    var privateDate = DateTime(now.year, 2, 1);
    if (now.isAfter(privateDate)) {
      privateDate = DateTime(now.year + 1, 2, 1);
    }
    final privateDays = privateDate.difference(now).inDays + 1;

    final targets = [
      {
        'title': '大学入学共通テスト 本番',
        'date': '${commonTestDate.year}年1月16日',
        'days': commonTestDays,
        'badge': '共通テスト',
        'color': const Color(0xFF38BDF8),
      },
      {
        'title': '${widget.profile.targetUniversity.isEmpty ? "第一志望校" : widget.profile.targetUniversity} 2次試験',
        'date': '${national2ndDate.year}年2月25日',
        'days': national2ndDays,
        'badge': '目標偏差値 ${widget.profile.targetDeviation.toStringAsFixed(1)}',
        'color': const Color(0xFFF59E0B),
      },
      {
        'title': '私大一般・高校推薦/本番入試',
        'date': '${privateDate.year}年2月1日',
        'days': privateDays,
        'badge': '個別入試',
        'color': const Color(0xFFEC4899),
      },
    ];

    final current = targets[_targetExamIndex % targets.length];
    final days = current['days'] as int;
    final color = current['color'] as Color;

    return InkWell(
      onTap: () {
        setState(() {
          _targetExamIndex = (_targetExamIndex + 1) % targets.length;
        });
        if (widget.onTap != null) widget.onTap!();
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF0F172A),
              color.withValues(alpha: 0.15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withValues(alpha: 0.5)),
              ),
              child: Icon(Icons.timer_outlined, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          current['title'] as String,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          current['badge'] as String,
                          style: TextStyle(fontSize: 9.5, color: color, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '試験期日: ${current['date']} (タップで目標切替)',
                    style: const TextStyle(fontSize: 10.5, color: Colors.white60),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('あと', style: TextStyle(fontSize: 10, color: Colors.white60)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$days',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
                    ),
                    const Text(
                      ' 日',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
