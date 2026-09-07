import 'package:flutter/material.dart';
import '../services/question_service.dart';
import '../services/storage_service.dart';
import 'practice_screen.dart';
import 'lab_screen.dart';

class SubjectListScreen extends StatefulWidget {
  const SubjectListScreen({super.key});

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  String _selectedStage = 'high_school'; // 'high_school' or 'junior_high'
  String _selectedCategory = 'すべて';

  final List<String> _hsCategories = ['すべて', '理系・共通', '理科', '国語', '語学', '地歴・社会', '公民'];
  final List<String> _jhCategories = ['すべて', '数理', '語学', '国語', '理科', '社会'];

  List<String> get _currentCategories => _selectedStage == 'junior_high' ? _jhCategories : _hsCategories;

  @override
  void initState() {
    super.initState();
    _loadStagePreference();
  }

  void _loadStagePreference() async {
    final profile = await StorageService().loadProfile();
    if (mounted) {
      setState(() {
        _selectedStage = profile.educationStage;
      });
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'calculate':
        return Icons.calculate;
      case 'bolt':
        return Icons.bolt;
      case 'science':
        return Icons.science;
      case 'biotech':
        return Icons.biotech;
      case 'public':
        return Icons.public;
      case 'terminal':
        return Icons.terminal;
      case 'language':
        return Icons.language;
      case 'menu_book':
        return Icons.menu_book;
      case 'history_edu':
        return Icons.history_edu;
      case 'auto_stories':
        return Icons.auto_stories;
      case 'account_balance':
        return Icons.account_balance;
      case 'travel_explore':
        return Icons.travel_explore;
      case 'map':
        return Icons.map;
      case 'gavel':
        return Icons.gavel;
      default:
        return Icons.school;
    }
  }

  void _openSubject(SubjectInfo subject) async {
    // Show progress dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final questions = await QuestionService().getQuestionsForSubject(subject.id);
    if (!mounted) return;
    Navigator.pop(context); // close progress

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PracticeScreen(
          questions: questions,
          title: subject.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stageSubjects = QuestionService.getSubjectsForStage(_selectedStage);
    final filtered = _selectedCategory == 'すべて'
        ? stageSubjects
        : stageSubjects.where((s) => s.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.library_books, color: Color(0xFF38BDF8), size: 20),
            const SizedBox(width: 8),
            Text(
              _selectedStage == 'junior_high' ? '中学5教科演習 (高校入試対応)' : '教科・科目別演習 (高校全範囲)',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Mode Toggle (High School vs Junior High)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFF0F172A),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedStage = 'high_school';
                          _selectedCategory = 'すべて';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: _selectedStage == 'high_school' ? const Color(0xFF38BDF8) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.school,
                                size: 16,
                                color: _selectedStage == 'high_school' ? Colors.black : Colors.white60,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '高校生モード (14教科)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _selectedStage == 'high_school' ? Colors.black : Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedStage = 'junior_high';
                          _selectedCategory = 'すべて';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: _selectedStage == 'junior_high' ? const Color(0xFF10B981) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.menu_book,
                                size: 16,
                                color: _selectedStage == 'junior_high' ? Colors.black : Colors.white60,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '中学生モード (5教科)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _selectedStage == 'junior_high' ? Colors.black : Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Category chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFF0F172A),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _currentCategories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  final accentColor = _selectedStage == 'junior_high' ? const Color(0xFF10B981) : const Color(0xFF38BDF8);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) setState(() => _selectedCategory = cat);
                      },
                      selectedColor: accentColor.withValues(alpha: 0.25),
                      labelStyle: TextStyle(
                        color: isSelected ? accentColor : Colors.white60,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Subject Grid
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, idx) {
                final sub = filtered[idx];
                final icon = _getIconData(sub.iconName);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131B2E),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: InkWell(
                    onTap: () => _openSubject(sub),
                    borderRadius: BorderRadius.circular(18),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
                            ),
                            child: Icon(icon, color: const Color(0xFF38BDF8), size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      sub.name,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.08),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        sub.category,
                                        style: const TextStyle(fontSize: 10, color: Colors.white70),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  sub.description,
                                  style: const TextStyle(fontSize: 11, color: Colors.white54, height: 1.3),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                                ),
                                child: const Text(
                                  '200問収録',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF34D399),
                                  ),
                                ),
                              ),
                              if (_hasLab(sub.id)) ...[
                                const SizedBox(height: 6),
                                InkWell(
                                  onTap: () {
                                    final tabIdx = _getLabTabIndex(sub.id);
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => LabScreen(initialTabIndex: tabIdx)));
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.4)),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.biotech, size: 11, color: Color(0xFF38BDF8)),
                                        SizedBox(width: 2),
                                        Text(
                                          '実験室',
                                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 6),
                              const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white38),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _hasLab(String id) => ['math', 'physics', 'chemistry', 'biology', 'information'].contains(id);

  int _getLabTabIndex(String id) {
    switch (id) {
      case 'math':
        return 0;
      case 'physics':
        return 1;
      case 'chemistry':
        return 2;
      case 'biology':
        return 3;
      case 'information':
        return 4;
      default:
        return 0;
    }
  }
}
