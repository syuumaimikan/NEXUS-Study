import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class StudyTask {
  final String id;
  final String title;
  final String subject;
  final String time;
  bool isCompleted;

  StudyTask({
    required this.id,
    required this.title,
    required this.subject,
    required this.time,
    this.isCompleted = false,
  });
}

class StudyScheduleScreen extends StatefulWidget {
  const StudyScheduleScreen({super.key});

  @override
  State<StudyScheduleScreen> createState() => _StudyScheduleScreenState();
}

class _StudyScheduleScreenState extends State<StudyScheduleScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _morningTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _eveningTime = const TimeOfDay(hour: 21, minute: 0);
  bool _morningAlertEnabled = true;
  bool _eveningAlertEnabled = true;

  final Set<int> _activeDays = {1, 2, 3, 4, 5, 6, 7}; // Mon to Sun

  final Map<String, List<StudyTask>> _scheduledTasks = {
    _formatDateKey(DateTime.now()): [
      StudyTask(id: 't1', title: 'ターゲット1900 セクション1 (100語)', subject: '英語', time: '07:30', isCompleted: true),
      StudyTask(id: 't2', title: '微積千本ノック チャレンジ (60秒)', subject: '数学', time: '17:00'),
      StudyTask(id: 't3', title: '共通テスト過去問演習・解説確認', subject: '国公立総合', time: '21:30'),
    ],
  };

  static String _formatDateKey(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  void _syncWithGoogleCalendar(StudyTask task) async {
    final date = _selectedDate;
    final year = date.year;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    
    final startTime = '$year$month${day}T090000Z';
    final endTime = '$year$month${day}T100000Z';
    final title = Uri.encodeComponent('【NEXUS学習】${task.title} (${task.subject})');
    final details = Uri.encodeComponent('NEXUS Study 学習スケジュール連携\n教科: ${task.subject}\n予定時刻: ${task.time}');

    final url = 'https://calendar.google.com/calendar/render?action=TEMPLATE&text=$title&dates=$startTime/$endTime&details=$details';

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _copyIcs(task);
      }
    } catch (_) {
      _copyIcs(task);
    }
  }

  void _copyIcs(StudyTask task) {
    final icsText = '''BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//NEXUS Study//Learning Schedule//JA
BEGIN:VEVENT
SUMMARY:【NEXUS学習】${task.title}
DESCRIPTION:${task.subject}の計画学習
DTSTART:${_formatDateKey(_selectedDate).replaceAll('-', '')}T090000Z
DTEND:${_formatDateKey(_selectedDate).replaceAll('-', '')}T100000Z
END:VEVENT
END:VCALENDAR''';

    Clipboard.setData(ClipboardData(text: icsText));
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.calendar_today, color: Color(0xFF38BDF8), size: 16),
            SizedBox(width: 8),
            Text('カレンダー予定データをコピーしました'),
          ],
        ),
        duration: Duration(milliseconds: 1200),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF131B2E),
      ),
    );
  }

  void _addNewTaskDialog() {
    final titleCtrl = TextEditingController();
    String subject = '数学';
    final timeCtrl = TextEditingController(text: '19:00');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) => AlertDialog(
          backgroundColor: const Color(0xFF131B2E),
          title: const Row(
            children: [
              Icon(Icons.add_task, color: Color(0xFF38BDF8), size: 20),
              SizedBox(width: 8),
              Text('新しい学習予定を追加', style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  labelText: '学習内容 (例: 微分計算演習20問)',
                  labelStyle: const TextStyle(color: Colors.white60, fontSize: 12),
                  filled: true,
                  fillColor: const Color(0xFF0F172A),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: subject,
                dropdownColor: const Color(0xFF0F172A),
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  labelText: '教科',
                  labelStyle: const TextStyle(color: Colors.white60, fontSize: 12),
                  filled: true,
                  fillColor: const Color(0xFF0F172A),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                items: ['数学', '英語', '物理', '化学', '生物', '国語', '歴史', '地理', '情報']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => setDlgState(() => subject = val ?? '数学'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: timeCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  labelText: '目標時刻 (例: 20:00)',
                  labelStyle: const TextStyle(color: Colors.white60, fontSize: 12),
                  filled: true,
                  fillColor: const Color(0xFF0F172A),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('キャンセル', style: TextStyle(color: Colors.white60)),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty) return;
                final key = _formatDateKey(_selectedDate);
                final newTask = StudyTask(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleCtrl.text.trim(),
                  subject: subject,
                  time: timeCtrl.text.trim(),
                );
                setState(() {
                  _scheduledTasks.putIfAbsent(key, () => []).add(newTask);
                });
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF38BDF8)),
              child: const Text('追加', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final key = _formatDateKey(_selectedDate);
    final tasksForDay = _scheduledTasks[key] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.calendar_month, color: Color(0xFF38BDF8), size: 20),
            SizedBox(width: 8),
            Text(
              '学習スケジュール＆カレンダー連携',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Calendar Month Widget
            _buildCalendarCard(),

            const SizedBox(height: 16),

            // Daily Tasks Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.assignment, color: Color(0xFF38BDF8), size: 18),
                    const SizedBox(width: 6),
                    Text(
                      '${_selectedDate.month}月${_selectedDate.day}日の学習予定 (${tasksForDay.length}件)',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _addNewTaskDialog,
                  icon: const Icon(Icons.add, size: 14),
                  label: const Text('予定追加'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38BDF8),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Tasks List
            if (tasksForDay.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF131B2E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.event_available, color: Colors.white24, size: 36),
                      const SizedBox(height: 8),
                      const Text(
                        'この日の学習予定はありません',
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: _addNewTaskDialog,
                        icon: const Icon(Icons.add, size: 14),
                        label: const Text('目標を設定する'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF38BDF8),
                          side: const BorderSide(color: Color(0xFF38BDF8)),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...tasksForDay.map((task) => _buildTaskItem(task)),

            const SizedBox(height: 24),

            // Notification & Reminder Settings Card
            _buildNotificationCard(),

            const SizedBox(height: 20),

            // Daily Routine Card
            _buildRoutineCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(_selectedDate.year, _selectedDate.month);
    final firstDayOfWeek = DateTime(_selectedDate.year, _selectedDate.month, 1).weekday; // 1 = Mon

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white70),
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
                  });
                },
              ),
              Text(
                '${_selectedDate.year}年 ${_selectedDate.month}月',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white70),
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Day header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['月', '火', '水', '木', '金', '土', '日'].map((day) {
              final isWeekend = day == '土' || day == '日';
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isWeekend ? const Color(0xFF38BDF8) : Colors.white60,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          // Day Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (firstDayOfWeek - 1) + daysInMonth,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, idx) {
              if (idx < firstDayOfWeek - 1) {
                return const SizedBox.shrink();
              }
              final dayNum = idx - (firstDayOfWeek - 1) + 1;
              final isToday = now.year == _selectedDate.year && now.month == _selectedDate.month && now.day == dayNum;
              final isSelected = _selectedDate.day == dayNum;
              final dKey = '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${dayNum.toString().padLeft(2, '0')}';
              final hasTasks = _scheduledTasks.containsKey(dKey) && _scheduledTasks[dKey]!.isNotEmpty;

              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, dayNum);
                  });
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF38BDF8)
                        : isToday
                            ? const Color(0xFF38BDF8).withValues(alpha: 0.2)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: isToday && !isSelected
                        ? Border.all(color: const Color(0xFF38BDF8), width: 1.5)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$dayNum',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.black : Colors.white,
                        ),
                      ),
                      if (hasTasks)
                        Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.only(top: 2),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.black : const Color(0xFF34D399),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(StudyTask task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: task.isCompleted ? const Color(0xFF34D399).withValues(alpha: 0.4) : Colors.white10),
      ),
      child: Row(
        children: [
          Checkbox(
            value: task.isCompleted,
            activeColor: const Color(0xFF34D399),
            onChanged: (val) {
              setState(() {
                task.isCompleted = val ?? false;
              });
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: task.isCompleted ? Colors.white54 : Colors.white,
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(task.subject, style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 10)),
                    ),
                    const SizedBox(width: 8),
                    Text(task.time, style: const TextStyle(color: Colors.white54, fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today, size: 16, color: Color(0xFF38BDF8)),
            tooltip: 'Googleカレンダーに追加',
            onPressed: () => _syncWithGoogleCalendar(task),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
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
              Icon(Icons.alarm, color: Color(0xFFFBBF24), size: 18),
              SizedBox(width: 8),
              Text(
                'リマインダー通知設定',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Morning
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('朝活学習リマインダー', style: TextStyle(color: Colors.white, fontSize: 13)),
            subtitle: Text('設定時刻: ${_morningTime.format(context)}', style: const TextStyle(color: Colors.white60, fontSize: 11)),
            value: _morningAlertEnabled,
            activeTrackColor: const Color(0xFF38BDF8),
            onChanged: (val) => setState(() => _morningAlertEnabled = val),
            secondary: IconButton(
              icon: const Icon(Icons.access_time, color: Color(0xFF38BDF8), size: 18),
              onPressed: () async {
                final picked = await showTimePicker(context: context, initialTime: _morningTime);
                if (picked != null) setState(() => _morningTime = picked);
              },
            ),
          ),
          const Divider(height: 1, color: Colors.white10),
          // Evening
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('夜の復習・演習リマインダー', style: TextStyle(color: Colors.white, fontSize: 13)),
            subtitle: Text('設定時刻: ${_eveningTime.format(context)}', style: const TextStyle(color: Colors.white60, fontSize: 11)),
            value: _eveningAlertEnabled,
            activeTrackColor: const Color(0xFF38BDF8),
            onChanged: (val) => setState(() => _eveningAlertEnabled = val),
            secondary: IconButton(
              icon: const Icon(Icons.access_time, color: Color(0xFF38BDF8), size: 18),
              onPressed: () async {
                final picked = await showTimePicker(context: context, initialTime: _eveningTime);
                if (picked != null) setState(() => _eveningTime = picked);
              },
            ),
          ),
          const SizedBox(height: 8),
          // Day repetition
          const Text('通知する曜日:', style: TextStyle(fontSize: 11, color: Colors.white60)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDayToggle(1, '月'),
              _buildDayToggle(2, '火'),
              _buildDayToggle(3, '水'),
              _buildDayToggle(4, '木'),
              _buildDayToggle(5, '金'),
              _buildDayToggle(6, '土'),
              _buildDayToggle(7, '日'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayToggle(int dayIdx, String label) {
    final isSel = _activeDays.contains(dayIdx);
    return InkWell(
      onTap: () {
        setState(() {
          if (isSel) {
            _activeDays.remove(dayIdx);
          } else {
            _activeDays.add(dayIdx);
          }
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 38,
        height: 32,
        decoration: BoxDecoration(
          color: isSel ? const Color(0xFF38BDF8) : const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSel ? const Color(0xFF38BDF8) : Colors.white24),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSel ? Colors.black : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoutineCard() {
    return Container(
      padding: const EdgeInsets.all(16),
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
              Icon(Icons.repeat, color: Color(0xFF34D399), size: 18),
              SizedBox(width: 8),
              Text(
                '日々の推奨学習ルーティーン',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildRoutineItem('朝活 ターゲット1900 暗記 (30分)', '起きてすぐの英単語反復で記憶を定着', Icons.light_mode, const Color(0xFFFBBF24)),
          const SizedBox(height: 8),
          _buildRoutineItem('通学スキマ時間 リスニング＆古文 (20分)', '移動時間を活用して耳と目で基礎固め', Icons.train, const Color(0xFF38BDF8)),
          const SizedBox(height: 8),
          _buildRoutineItem('夜の集中問題演習＆微積ノック (90分)', '集中力が高まる時間に実戦問題演習', Icons.nightlight_round, const Color(0xFFA855F7)),
        ],
      ),
    );
  }

  Widget _buildRoutineItem(String title, String desc, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                Text(desc, style: const TextStyle(color: Colors.white54, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
