import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/widget_service.dart';

class WidgetManagerScreen extends StatefulWidget {
  final UserProfile profile;

  const WidgetManagerScreen({super.key, required this.profile});

  @override
  State<WidgetManagerScreen> createState() => _WidgetManagerScreenState();
}

class _WidgetManagerScreenState extends State<WidgetManagerScreen> {
  int _selectedWidgetIndex = 0;
  bool _isPinSupported = true;
  bool _isUpdating = false;

  final List<Map<String, dynamic>> _widgets = [
    {
      'id': 'vocabulary',
      'title': 'ターゲット1900 英単語＆ストリーク',
      'desc': '毎日ホーム画面で新しい重要英単語と意味を確認。連続学習日数（ストリーク）も一目で把握できます。',
      'icon': Icons.style_outlined,
      'color': Color(0xFF38BDF8),
    },
    {
      'id': 'countdown',
      'title': '入試本番カウントダウン＆目標偏差値',
      'desc': '大学入学共通テストや第一志望校入試までの残り日数を毎日カウントダウン。モチベーションを維持します。',
      'icon': Icons.timer_outlined,
      'color': Color(0xFFFBBF24),
    },
    {
      'id': 'formula',
      'title': '日替わり重要公式・定理フラッシュ',
      'desc': '数学・物理・化学の最頻出公式が日替わりで出現。隙間時間で公式を確実に定着させます。',
      'icon': Icons.functions,
      'color': Color(0xFF10B981),
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkSupport();
    _syncData();
  }

  void _checkSupport() async {
    final supported = await WidgetService().isPinSupported();
    setState(() {
      _isPinSupported = supported;
    });
  }

  void _syncData() async {
    await WidgetService().syncWidgetData(profile: widget.profile);
  }

  void _requestPin() async {
    final current = _widgets[_selectedWidgetIndex];
    final success = await WidgetService().requestPinWidget(current['id'] as String);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ホーム画面への追加リクエストを送信しました: ${current['title']}'),
            backgroundColor: const Color(0xFF0284C7),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ホーム画面の空きスペースを長押し ➔「ウィジェット」➔「NEXUS Study」を選択して配置してください'),
            backgroundColor: Color(0xFF334155),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _forceRefresh() async {
    setState(() => _isUpdating = true);
    await WidgetService().syncWidgetData(
      profile: widget.profile,
      todayWord: 'zealous : 熱心な；熱狂的な',
      formulaSubject: '【物理】本日の重要公式',
      formulaTitle: '単振り子の周期公式',
      formulaBody: 'T = 2π√(L / g)',
    );
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() => _isUpdating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ウィジェットの最新データを更新・同期しました'),
          backgroundColor: Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = _widgets[_selectedWidgetIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.widgets_outlined, color: Color(0xFF38BDF8), size: 22),
            SizedBox(width: 8),
            Text(
              'ホーム画面ウィジェット設定',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: _isUpdating
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF38BDF8)))
                : const Icon(Icons.sync, color: Color(0xFF38BDF8)),
            tooltip: 'ウィジェット即時更新',
            onPressed: _isUpdating ? null : _forceRefresh,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.touch_app, color: Color(0xFF38BDF8), size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'スマホを開くたびに学べるホーム常駐型',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'アプリを開かなくても、日々の英単語・入試残日数・公式がホーム画面に自動表示されます。',
                          style: TextStyle(fontSize: 11, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Widget Selector Tabs
            const Text(
              'ウィジェット種類を選択',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_widgets.length, (idx) {
                  final w = _widgets[idx];
                  final isSel = idx == _selectedWidgetIndex;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      selected: isSel,
                      label: Row(
                        children: [
                          Icon(w['icon'] as IconData, size: 16, color: isSel ? Colors.black : Colors.white70),
                          const SizedBox(width: 6),
                          Text(w['title'] as String),
                        ],
                      ),
                      selectedColor: const Color(0xFF38BDF8),
                      backgroundColor: const Color(0xFF131B2E),
                      labelStyle: TextStyle(
                        color: isSel ? Colors.black : Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _selectedWidgetIndex = idx);
                      },
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),

            // Live Preview Card
            const Text(
              'ホーム画面プレビュー',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF030712),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Mock Phone Home screen background
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: (selected['color'] as Color).withValues(alpha: 0.4)),
                    ),
                    child: _buildWidgetPreview(selected['id'] as String),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    selected['desc'] as String,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Add to Home Screen Button
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _requestPin,
                icon: const Icon(Icons.add_to_home_screen, size: 20),
                label: Text(
                  _isPinSupported
                      ? 'ホーム画面にこのウィジェットを追加'
                      : '手動配置ガイドを確認',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF38BDF8),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Manual Placement Guide
            Container(
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
                      Icon(Icons.help_outline, color: Color(0xFF38BDF8), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'ホーム画面への手動追加手順',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildStepRow(1, '端末のホーム画面（ランチャー）の空いている場所を長押しします。'),
                  _buildStepRow(2, '表示されるメニューから「ウィジェット」または「Widget」をタップします。'),
                  _buildStepRow(3, 'アプリ一覧から「NEXUS Study」を探します。'),
                  _buildStepRow(4, 'お好みのウィジェットを選び、長押ししてホーム画面の好きな位置にドラッグ＆ドロップします。'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepRow(int num, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$num',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 11.5, color: Colors.white70, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetPreview(String id) {
    if (id == 'countdown') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.school, color: Color(0xFF38BDF8), size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                '志望校: ${widget.profile.targetUniversity.isEmpty ? "難関大学・志望校" : widget.profile.targetUniversity}',
                style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF43F5E).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '目標 ${widget.profile.targetDeviation.toStringAsFixed(1)}',
                  style: const TextStyle(color: Color(0xFFFDA4AF), fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            ],
          ),
          const Divider(height: 16, color: Colors.white12),
          const Text('大学入学共通テスト 本番まで', style: TextStyle(color: Colors.white60, fontSize: 10)),
          const SizedBox(height: 2),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('あと ', style: TextStyle(color: Colors.white, fontSize: 13)),
              Text('131', style: TextStyle(color: Color(0xFFFBBF24), fontSize: 24, fontWeight: FontWeight.bold)),
              Text(' 日', style: TextStyle(color: Colors.white, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 4),
          const Text('本日の目標: 英語長文読解と微積10問', style: TextStyle(color: Color(0xFF34D399), fontSize: 10)),
        ],
      );
    } else if (id == 'formula') {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.functions, color: Color(0xFF10B981), size: 20),
              SizedBox(width: 8),
              Text('【数学】本日の重要公式', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 12)),
              Spacer(),
              Text('必修', style: TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.bold, fontSize: 10)),
            ],
          ),
          Divider(height: 16, color: Colors.white12),
          Text('積分の1/6公式 (放物線と直線の面積)', style: TextStyle(color: Colors.white70, fontSize: 11)),
          SizedBox(height: 4),
          Text('S = (|a| / 6) * (β - α)³', style: TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.bold, fontSize: 14)),
          SizedBox(height: 4),
          Text('タップして全教科公式集を開く', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 10)),
        ],
      );
    }

    // Default: Vocabulary
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.menu_book, color: Color(0xFF38BDF8), size: 16),
            ),
            const SizedBox(width: 8),
            const Text('NEXUS Study', style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 12)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '連続 ${widget.profile.streakDays}日達成',
                style: const TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.bold, fontSize: 10),
              ),
            ),
          ],
        ),
        const Divider(height: 16, color: Colors.white12),
        const Text('【公式ターゲット1900】本日の重要単語', style: TextStyle(color: Colors.white60, fontSize: 10)),
        const SizedBox(height: 2),
        const Text('scrutinize : を詳細に調べる', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 6),
        const Text('タップして今日の学習を再開', style: TextStyle(color: Color(0xFF34D399), fontSize: 10)),
      ],
    );
  }
}
