import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MistakeItem {
  final String id;
  final String subjectId;
  final String subjectName;
  final String questionText;
  final String explanation;
  final String correctAnswer;
  final String userAnswer;
  final DateTime dateMistaken;
  DateTime nextReviewDate;
  int reviewCount;
  bool isMastered;
  String userNote;

  MistakeItem({
    required this.id,
    required this.subjectId,
    required this.subjectName,
    required this.questionText,
    required this.explanation,
    required this.correctAnswer,
    required this.userAnswer,
    required this.dateMistaken,
    required this.nextReviewDate,
    this.reviewCount = 0,
    this.isMastered = false,
    this.userNote = '',
  });

  bool get isDueToday {
    if (isMastered) return false;
    final now = DateTime.now();
    return now.isAfter(nextReviewDate) ||
        (now.year == nextReviewDate.year &&
            now.month == nextReviewDate.month &&
            now.day == nextReviewDate.day);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'subjectId': subjectId,
        'subjectName': subjectName,
        'questionText': questionText,
        'explanation': explanation,
        'correctAnswer': correctAnswer,
        'userAnswer': userAnswer,
        'dateMistaken': dateMistaken.toIso8601String(),
        'nextReviewDate': nextReviewDate.toIso8601String(),
        'reviewCount': reviewCount,
        'isMastered': isMastered,
        'userNote': userNote,
      };

  factory MistakeItem.fromJson(Map<String, dynamic> json) => MistakeItem(
        id: json['id'] as String,
        subjectId: json['subjectId'] as String,
        subjectName: json['subjectName'] as String,
        questionText: json['questionText'] as String,
        explanation: json['explanation'] as String,
        correctAnswer: json['correctAnswer'] as String,
        userAnswer: json['userAnswer'] as String,
        dateMistaken: DateTime.parse(json['dateMistaken'] as String),
        nextReviewDate: DateTime.parse(json['nextReviewDate'] as String),
        reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
        isMastered: json['isMastered'] as bool? ?? false,
        userNote: json['userNote'] as String? ?? '',
      );
}

class MistakeNoteService {
  static final MistakeNoteService _instance = MistakeNoteService._internal();
  factory MistakeNoteService() => _instance;
  MistakeNoteService._internal();

  static const String _prefKey = 'nexus_mistake_notes_v1';
  List<MistakeItem>? _cachedMistakes;

  Future<List<MistakeItem>> getMistakes() async {
    if (_cachedMistakes != null) return _cachedMistakes!;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefKey);
    if (raw == null || raw.isEmpty) {
      // Seed with initial realistic mistake examples if empty
      _cachedMistakes = _generateInitialMistakes();
      await _save();
      return _cachedMistakes!;
    }
    try {
      final List<dynamic> list = jsonDecode(raw);
      _cachedMistakes = list.map((e) => MistakeItem.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      _cachedMistakes = _generateInitialMistakes();
    }
    return _cachedMistakes!;
  }

  Future<void> recordMistake({
    required String id,
    required String subjectId,
    required String subjectName,
    required String questionText,
    required String explanation,
    required String correctAnswer,
    required String userAnswer,
  }) async {
    final list = await getMistakes();
    final existingIndex = list.indexWhere((m) => m.id == id || m.questionText == questionText);

    final now = DateTime.now();
    // Ebbinghaus spacing: 1st review in 1 day
    final nextReview = now.add(const Duration(days: 1));

    if (existingIndex >= 0) {
      final item = list[existingIndex];
      item.nextReviewDate = nextReview;
      item.isMastered = false;
      item.reviewCount++;
    } else {
      list.insert(
        0,
        MistakeItem(
          id: id,
          subjectId: subjectId,
          subjectName: subjectName,
          questionText: questionText,
          explanation: explanation,
          correctAnswer: correctAnswer,
          userAnswer: userAnswer,
          dateMistaken: now,
          nextReviewDate: nextReview,
        ),
      );
    }
    await _save();
  }

  Future<void> toggleMastered(String id) async {
    final list = await getMistakes();
    final item = list.firstWhere((m) => m.id == id, orElse: () => list.first);
    item.isMastered = !item.isMastered;
    await _save();
  }

  Future<void> updateNote(String id, String note) async {
    final list = await getMistakes();
    final item = list.firstWhere((m) => m.id == id, orElse: () => list.first);
    item.userNote = note;
    await _save();
  }

  Future<void> markReviewed(String id, bool correct) async {
    final list = await getMistakes();
    final item = list.firstWhere((m) => m.id == id, orElse: () => list.first);
    item.reviewCount++;
    final now = DateTime.now();
    if (correct) {
      if (item.reviewCount >= 3) {
        item.isMastered = true;
      } else {
        // Next review in 3 days or 7 days
        final days = item.reviewCount == 1 ? 3 : 7;
        item.nextReviewDate = now.add(Duration(days: days));
      }
    } else {
      item.nextReviewDate = now.add(const Duration(days: 1));
    }
    await _save();
  }

  Future<void> deleteMistake(String id) async {
    final list = await getMistakes();
    list.removeWhere((m) => m.id == id);
    await _save();
  }

  Future<int> getDueCount() async {
    final list = await getMistakes();
    return list.where((m) => m.isDueToday).length;
  }

  Future<void> _save() async {
    if (_cachedMistakes == null) return;
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(_cachedMistakes!.map((e) => e.toJson()).toList());
    await prefs.setString(_prefKey, jsonStr);
  }

  List<MistakeItem> _generateInitialMistakes() {
    final now = DateTime.now();
    return [
      MistakeItem(
        id: 'math_101',
        subjectId: 'math',
        subjectName: '高校数学',
        questionText: '関数 f(x) = x³ - 3x² + 2 の極大値と極小値を求めよ。',
        explanation: 'f\'(x) = 3x² - 6x = 3x(x - 2) = 0 より、x = 0 で極大値 2、x = 2 で極小値 -2 をとります。増減表の符号変化を正確に確認しましょう。',
        correctAnswer: '極大値 2 (x=0), 極小値 -2 (x=2)',
        userAnswer: '極大値 4 (x=1), 極小値 0 (x=3)',
        dateMistaken: now.subtract(const Duration(days: 1)),
        nextReviewDate: now,
        reviewCount: 0,
        userNote: '増減表のプラス・マイナスの符号判定で係数の確認ミス。微分計算を焦らないこと！',
      ),
      MistakeItem(
        id: 'physics_102',
        subjectId: 'physics',
        subjectName: '物理',
        questionText: '傾角θのなめらかな斜面上を質量mの小物体が滑り落ちるときの加速度の大きさはいくらか。',
        explanation: '重力mgを斜面平行方向と垂直方向に分解すると、斜面平行方向の合力は mg sinθ。運動方程式 ma = mg sinθ より a = g sinθ です。',
        correctAnswer: 'g sinθ',
        userAnswer: 'g cosθ',
        dateMistaken: now.subtract(const Duration(days: 2)),
        nextReviewDate: now,
        reviewCount: 1,
        userNote: '斜面平行方向の分力が sinθ なのか cosθ なのか、直角三角形の幾何関係を必ず図示して確認する。',
      ),
      MistakeItem(
        id: 'english_103',
        subjectId: 'english',
        subjectName: '英語',
        questionText: 'The committee members were ( ) divided in their opinions.',
        explanation: '「鋭く対立して」を表す副詞は sharply です。divided を修飾するため副詞形を選択します。',
        correctAnswer: 'sharply',
        userAnswer: 'sharp',
        dateMistaken: now.subtract(const Duration(days: 3)),
        nextReviewDate: now.add(const Duration(days: 2)),
        reviewCount: 1,
        userNote: '過去分詞 divided を修飾するのは形容詞ではなく副詞(ly)。品詞の識別を徹底！',
      ),
    ];
  }
}
