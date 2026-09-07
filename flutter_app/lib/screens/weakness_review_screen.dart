import 'package:flutter/material.dart';
import '../services/mistake_note_service.dart';

class WeaknessReviewScreen extends StatefulWidget {
  const WeaknessReviewScreen({super.key});

  @override
  State<WeaknessReviewScreen> createState() => _WeaknessReviewScreenState();
}

class _WeaknessReviewScreenState extends State<WeaknessReviewScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<MistakeItem> _mistakes = [];
  bool _isLoading = true;
  String _selectedSubjectFilter = 'すべて';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadMistakes();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadMistakes() async {
    final list = await MistakeNoteService().getMistakes();
    if (mounted) {
      setState(() {
        _mistakes = list;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dueTodayList = _mistakes.where((m) => m.isDueToday).toList();
    final allUnmasteredList = _mistakes.where((m) => !m.isMastered).toList();
    final masteredList = _mistakes.where((m) => m.isMastered).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.auto_stories_outlined, color: Color(0xFFF43F5E), size: 22),
            SizedBox(width: 8),
            Text(
              '弱点克服・復習帳 (ミスノート)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFF43F5E),
          labelColor: const Color(0xFFF43F5E),
          unselectedLabelColor: Colors.white60,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('今日復習'),
                  if (dueTodayList.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF43F5E),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${dueTodayList.length}',
                        style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Tab(text: '未克服 (${allUnmasteredList.length})'),
            Tab(text: '克服済み (${masteredList.length})'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFF43F5E)))
          : Column(
              children: [
                // Subject Filter Bar
                _buildSubjectFilterBar(),

                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildMistakeList(dueTodayList, isDueTab: true),
                      _buildMistakeList(allUnmasteredList),
                      _buildMistakeList(masteredList, isMasteredTab: true),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSubjectFilterBar() {
    final subjects = ['すべて', '数学', '物理', '化学', '生物', '英語', '国語', '情報'];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      color: const Color(0xFF0F172A).withValues(alpha: 0.5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: subjects.map((sub) {
            final isSel = _selectedSubjectFilter == sub;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                selected: isSel,
                label: Text(sub),
                selectedColor: const Color(0xFFF43F5E),
                backgroundColor: const Color(0xFF131B2E),
                labelStyle: TextStyle(
                  color: isSel ? Colors.white : Colors.white70,
                  fontSize: 11,
                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (val) {
                  if (val) setState(() => _selectedSubjectFilter = sub);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMistakeList(List<MistakeItem> list, {bool isDueTab = false, bool isMasteredTab = false}) {
    var filtered = list;
    if (_selectedSubjectFilter != 'すべて') {
      filtered = list.where((m) => m.subjectName.contains(_selectedSubjectFilter)).toList();
    }

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isMasteredTab ? Icons.military_tech_outlined : Icons.check_circle_outline,
              size: 56,
              color: Colors.white24,
            ),
            const SizedBox(height: 12),
            Text(
              isDueTab
                  ? '本日復習すべき問題はありません！順調です。'
                  : isMasteredTab
                      ? '克服済みの問題はまだありません。'
                      : '該当する苦手問題はありません。',
              style: const TextStyle(color: Colors.white60, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        return _buildMistakeCard(item);
      },
    );
  }

  Widget _buildMistakeCard(MistakeItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: item.isDueToday
              ? const Color(0xFFF43F5E).withValues(alpha: 0.6)
              : item.isMastered
                  ? const Color(0xFF10B981).withValues(alpha: 0.4)
                  : Colors.white12,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row
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
                    item.subjectName,
                    style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                if (item.isDueToday)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF43F5E).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFF43F5E)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.alarm, color: Color(0xFFFDA4AF), size: 12),
                        SizedBox(width: 4),
                        Text(
                          '忘却曲線: 本日復習期日',
                          style: TextStyle(color: Color(0xFFFDA4AF), fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                else if (item.isMastered)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '完全克服済み',
                      style: TextStyle(color: Color(0xFF34D399), fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                const Spacer(),
                Text(
                  '復習回数: ${item.reviewCount}回',
                  style: const TextStyle(color: Colors.white54, fontSize: 10.5),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Question Text
            Text(
              item.questionText,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, height: 1.4),
            ),

            const SizedBox(height: 12),

            // Comparison: User Answer vs Correct Answer
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.close, color: Color(0xFFF43F5E), size: 16),
                      const SizedBox(width: 6),
                      const Text('誤答: ', style: TextStyle(color: Color(0xFFFDA4AF), fontSize: 11, fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Text(item.userAnswer, style: const TextStyle(color: Colors.white70, fontSize: 11.5)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check, color: Color(0xFF34D399), size: 16),
                      const SizedBox(width: 6),
                      const Text('正解: ', style: TextStyle(color: Color(0xFF34D399), fontSize: 11, fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Text(item.correctAnswer, style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Explanation
            Text(
              item.explanation,
              style: const TextStyle(fontSize: 11.5, color: Colors.white70, height: 1.4),
            ),

            const SizedBox(height: 10),

            // User Reflection Note
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.edit_note, color: Color(0xFFF59E0B), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.userNote.isEmpty ? 'タップして反省メモ・弱点ポイントを記録' : item.userNote,
                      style: TextStyle(
                        fontSize: 11,
                        color: item.userNote.isEmpty ? Colors.white38 : const Color(0xFFFDE68A),
                        fontStyle: item.userNote.isEmpty ? FontStyle.italic : FontStyle.normal,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 14, color: Color(0xFFF59E0B)),
                    onPressed: () => _showEditNoteDialog(item),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _retestDialog(item),
                    icon: const Icon(Icons.replay, size: 16),
                    label: const Text('解き直し', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF38BDF8),
                      side: const BorderSide(color: Color(0xFF38BDF8)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await MistakeNoteService().toggleMastered(item.id);
                      _loadMistakes();
                    },
                    icon: Icon(item.isMastered ? Icons.undo : Icons.check_circle, size: 16),
                    label: Text(
                      item.isMastered ? '未完了に戻す' : '克服済みにする',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: item.isMastered ? const Color(0xFF334155) : const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditNoteDialog(MistakeItem item) {
    final controller = TextEditingController(text: item.userNote);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.edit_note, color: Color(0xFFF59E0B), size: 22),
            SizedBox(width: 8),
            Text('弱点反省メモ', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: TextField(
          controller: controller,
          maxLines: 4,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            hintText: '例: 係数の見落とし。直角三角形の幾何関係を図示して確認する！',
            hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
            filled: true,
            fillColor: const Color(0xFF131B2E),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('キャンセル', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            onPressed: () async {
              await MistakeNoteService().updateNote(item.id, controller.text);
              if (ctx.mounted) Navigator.pop(ctx);
              _loadMistakes();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: Colors.black,
            ),
            child: const Text('保存', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _retestDialog(MistakeItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.replay, color: Color(0xFF38BDF8), size: 22),
            SizedBox(width: 8),
            Text('即時解き直しテスト', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.questionText, style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4)),
            const SizedBox(height: 16),
            const Text('正解を確認し、頭の中で解法を再現できましたか？', style: TextStyle(color: Colors.white70, fontSize: 11.5)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await MistakeNoteService().markReviewed(item.id, false);
              if (ctx.mounted) Navigator.pop(ctx);
              _loadMistakes();
            },
            child: const Text('まだ不安 (明日再復習)', style: TextStyle(color: Color(0xFFF43F5E), fontSize: 11)),
          ),
          ElevatedButton(
            onPressed: () async {
              await MistakeNoteService().markReviewed(item.id, true);
              if (ctx.mounted) Navigator.pop(ctx);
              _loadMistakes();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
            ),
            child: const Text('解けた！(次回復習間隔を延長)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
