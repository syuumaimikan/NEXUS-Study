import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question.dart';

class SubjectInfo {
  final String id;
  final String name;
  final String category;
  final String jsonFile;
  final String iconName; // Flutter material icon name
  final String description;

  const SubjectInfo({
    required this.id,
    required this.name,
    required this.category,
    required this.jsonFile,
    required this.iconName,
    required this.description,
  });
}

class QuestionService {
  static final QuestionService _instance = QuestionService._internal();
  factory QuestionService() => _instance;
  QuestionService._internal();

  static const List<SubjectInfo> highSchoolSubjects = [
    SubjectInfo(
      id: 'math',
      name: '高校数学',
      category: '理系・共通',
      jsonFile: 'math.json',
      iconName: 'calculate',
      description: '数学I/A/II/B/C/III。2次関数、三角比、微積分、数列、ベクトルを網羅。',
    ),
    SubjectInfo(
      id: 'physics',
      name: '物理',
      category: '理科',
      jsonFile: 'physics.json',
      iconName: 'bolt',
      description: '物理基礎・物理。力学、等加速度、単振動、電磁気、波動、熱力学。',
    ),
    SubjectInfo(
      id: 'chemistry',
      name: '化学',
      category: '理科',
      jsonFile: 'chemistry.json',
      iconName: 'science',
      description: '化学基礎・化学。酸と塩基、pH、酸化還元、有機化学、無機気体・沈殿。',
    ),
    SubjectInfo(
      id: 'biology',
      name: '生物',
      category: '理科',
      jsonFile: 'biology.json',
      iconName: 'biotech',
      description: '生物基礎・生物。細胞、DNA・セントラルドグマ、代謝、免疫系。',
    ),
    SubjectInfo(
      id: 'earth_science',
      name: '地学',
      category: '理科',
      jsonFile: 'earth_science.json',
      iconName: 'public',
      description: '地学基礎・地学。地球内部、地震波、プレート、大気・海洋、宇宙。',
    ),
    SubjectInfo(
      id: 'information',
      name: '情報',
      category: '共通テスト必修',
      jsonFile: 'information.json',
      iconName: 'terminal',
      description: '情報I・情報II。アルゴリズム、プログラミング、2進数、情報セキュリティ。',
    ),
    SubjectInfo(
      id: 'english',
      name: '英語',
      category: '語学',
      jsonFile: 'english.json',
      iconName: 'language',
      description: 'リーディング、英文法、語法、仮定法、前置詞・熟語、論理読解。',
    ),
    SubjectInfo(
      id: 'japanese',
      name: '現代文',
      category: '国語',
      jsonFile: 'japanese.json',
      iconName: 'menu_book',
      description: '論理国語・現代の国語。評論文読解、対比構造、重要評論キーワード。',
    ),
    SubjectInfo(
      id: 'kobun',
      name: '古文',
      category: '国語',
      jsonFile: 'kobun.json',
      iconName: 'history_edu',
      description: '古典探究・古文。用言活用、助動詞の意味・接続、重要古文単語315。',
    ),
    SubjectInfo(
      id: 'kanbun',
      name: '漢文',
      category: '国語',
      jsonFile: 'kanbun.json',
      iconName: 'auto_stories',
      description: '古典探究・漢文。返り点・訓読、再読文字、使役・受身・反語重要句法。',
    ),
    SubjectInfo(
      id: 'history_japan',
      name: '日本史',
      category: '地歴・社会',
      jsonFile: 'history_japan.json',
      iconName: 'account_balance',
      description: '日本史探究。律令国家、平安・摂関政治、武家政権、幕藩体制、近代化。',
    ),
    SubjectInfo(
      id: 'history_world',
      name: '世界史',
      category: '地歴・社会',
      jsonFile: 'history_world.json',
      iconName: 'travel_explore',
      description: '世界史探究。古代オリエント、ギリシア・ローマ、市民革命、世界大戦。',
    ),
    SubjectInfo(
      id: 'geography',
      name: '地理',
      category: '地歴・社会',
      jsonFile: 'geography.json',
      iconName: 'map',
      description: '地理探究。ケッペン気候区分、プレートテクトニクス、地形、世界の地誌。',
    ),
    SubjectInfo(
      id: 'civics',
      name: '公民',
      category: '公民',
      jsonFile: 'civics.json',
      iconName: 'gavel',
      description: '公共・政治経済・倫理。日本国憲法三大原則、三権分立、市場機構、金融。',
    ),
  ];

  static const List<SubjectInfo> juniorHighSubjects = [
    SubjectInfo(
      id: 'jh_math',
      name: '中学数学',
      category: '数理',
      jsonFile: 'jh_math.json',
      iconName: 'calculate',
      description: '正負の数、文字式、一次方程式、連立方程式、一次関数、二次関数、合同・相似、三平方の定理。',
    ),
    SubjectInfo(
      id: 'jh_english',
      name: '中学英語',
      category: '語学',
      jsonFile: 'jh_english.json',
      iconName: 'language',
      description: 'be動詞・一般動詞、過去形・進行形、未来形・助動詞、不定詞・動名詞、現在完了、受動態、関係代名詞。',
    ),
    SubjectInfo(
      id: 'jh_japanese',
      name: '中学国語',
      category: '国語',
      jsonFile: 'jh_japanese.json',
      iconName: 'menu_book',
      description: '説明文・論説文読解、小説読解、文法・品詞分類、敬語表現、古典基礎・漢文訓読・故事成語。',
    ),
    SubjectInfo(
      id: 'jh_science',
      name: '中学理科',
      category: '理科',
      jsonFile: 'jh_science.json',
      iconName: 'science',
      description: '光と音・力、電流と磁界、水溶液・状態変化、化学変化とイオン、植物・動物の分類、天気、天体。',
    ),
    SubjectInfo(
      id: 'jh_social',
      name: '中学社会',
      category: '社会',
      jsonFile: 'jh_social.json',
      iconName: 'public',
      description: '地理（日本・世界地誌）、歴史（縄文〜近現代の通史）、公民（日本国憲法、三権分立、経済・国際社会）。',
    ),
  ];

  static List<SubjectInfo> get allSubjects => [...highSchoolSubjects, ...juniorHighSubjects];

  static List<SubjectInfo> getSubjectsForStage(String stage) {
    if (stage == 'junior_high') {
      return juniorHighSubjects;
    }
    return highSchoolSubjects;
  }

  final Map<String, List<Question>> _cachedQuestions = {};

  Future<List<Question>> getQuestionsForSubject(String subjectId) async {
    if (_cachedQuestions.containsKey(subjectId)) {
      return _cachedQuestions[subjectId]!;
    }

    final all = allSubjects;
    final subject = all.firstWhere(
      (s) => s.id == subjectId,
      orElse: () => all.first,
    );

    try {
      final jsonString = await rootBundle.loadString('assets/questions/${subject.jsonFile}');
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      final questions = jsonList.map((j) => Question.fromJson(j as Map<String, dynamic>)).toList();
      _cachedQuestions[subjectId] = questions;
      return questions;
    } catch (e) {
      // Fallback
      return [];
    }
  }

  Future<List<Question>> getAllQuestions({String? stage}) async {
    final subjects = stage != null ? getSubjectsForStage(stage) : allSubjects;
    List<Question> all = [];
    for (final s in subjects) {
      final qs = await getQuestionsForSubject(s.id);
      all.addAll(qs);
    }
    return all;
  }

  Future<List<Question>> getMockExamQuestions({String stage = 'high_school'}) async {
    if (stage == 'junior_high') {
      final mQs = await getQuestionsForSubject('jh_math');
      final eQs = await getQuestionsForSubject('jh_english');
      final jQs = await getQuestionsForSubject('jh_japanese');
      final sQs = await getQuestionsForSubject('jh_science');
      final soQs = await getQuestionsForSubject('jh_social');

      return [
        if (mQs.isNotEmpty) mQs.first,
        if (eQs.isNotEmpty) eQs.first,
        if (jQs.isNotEmpty) jQs.first,
        if (sQs.isNotEmpty) sQs.first,
        if (soQs.isNotEmpty) soQs.first,
      ];
    }

    // High school curated 5-subject exam
    final mathQs = await getQuestionsForSubject('math');
    final physQs = await getQuestionsForSubject('physics');
    final chemQs = await getQuestionsForSubject('chemistry');
    final engQs = await getQuestionsForSubject('english');
    final infoQs = await getQuestionsForSubject('information');

    return [
      if (mathQs.isNotEmpty) mathQs.first,
      if (physQs.isNotEmpty) physQs.first,
      if (chemQs.isNotEmpty) chemQs.first,
      if (engQs.isNotEmpty) engQs.first,
      if (infoQs.isNotEmpty) infoQs.first,
    ];
  }
}
