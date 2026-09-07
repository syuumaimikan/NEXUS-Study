class UserProfile {
  final String id;
  final String username;
  final String avatarIcon; // Material icon identifier (e.g. 'school', 'science', etc.)
  final String schoolGrade;
  final String targetUniversity;
  final String studyTrack; // science, humanities, medical, general
  final String educationStage; // 'high_school' | 'junior_high'
  final bool hasCompletedOnboarding;
  final int level;
  final int currentXp;
  final int nextLevelXp;
  final int streakDays;
  final int coins;
  final String league;
  final String title;
  final List<String> unlockedTitles;
  final String avatarFrame;
  final int streakShields;

  bool get isJuniorHigh => educationStage == 'junior_high';

  UserProfile({
    required this.id,
    required this.username,
    required this.avatarIcon,
    required this.schoolGrade,
    required this.targetUniversity,
    required this.studyTrack,
    this.educationStage = 'high_school',
    required this.hasCompletedOnboarding,
    required this.level,
    required this.currentXp,
    required this.nextLevelXp,
    required this.streakDays,
    required this.coins,
    required this.league,
    this.title = '新鋭チャレンジャー',
    this.unlockedTitles = const ['新鋭チャレンジャー'],
    this.avatarFrame = 'cyan',
    this.streakShields = 0,
  });

  factory UserProfile.defaultProfile() {
    return UserProfile(
      id: 'student_1',
      username: '学習者',
      avatarIcon: 'school',
      schoolGrade: '高校2年生',
      targetUniversity: '',
      studyTrack: 'science',
      educationStage: 'high_school',
      hasCompletedOnboarding: false,
      level: 1,
      currentXp: 0,
      nextLevelXp: 500,
      streakDays: 1,
      coins: 100,
      league: 'Bronze',
      title: '新鋭チャレンジャー',
      unlockedTitles: const ['新鋭チャレンジャー'],
      avatarFrame: 'cyan',
      streakShields: 0,
    );
  }

  UserProfile copyWith({
    String? username,
    String? avatarIcon,
    String? schoolGrade,
    String? targetUniversity,
    String? studyTrack,
    String? educationStage,
    bool? hasCompletedOnboarding,
    int? level,
    int? currentXp,
    int? nextLevelXp,
    int? streakDays,
    int? coins,
    String? league,
    String? title,
    List<String>? unlockedTitles,
    String? avatarFrame,
    int? streakShields,
  }) {
    return UserProfile(
      id: id,
      username: username ?? this.username,
      avatarIcon: avatarIcon ?? this.avatarIcon,
      schoolGrade: schoolGrade ?? this.schoolGrade,
      targetUniversity: targetUniversity ?? this.targetUniversity,
      studyTrack: studyTrack ?? this.studyTrack,
      educationStage: educationStage ?? this.educationStage,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      level: level ?? this.level,
      currentXp: currentXp ?? this.currentXp,
      nextLevelXp: nextLevelXp ?? this.nextLevelXp,
      streakDays: streakDays ?? this.streakDays,
      coins: coins ?? this.coins,
      league: league ?? this.league,
      title: title ?? this.title,
      unlockedTitles: unlockedTitles ?? this.unlockedTitles,
      avatarFrame: avatarFrame ?? this.avatarFrame,
      streakShields: streakShields ?? this.streakShields,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? 'student_1',
      username: json['username'] as String? ?? '学習者',
      avatarIcon: json['avatarIcon'] as String? ?? 'school',
      schoolGrade: json['schoolGrade'] as String? ?? '高校2年生',
      targetUniversity: json['targetUniversity'] as String? ?? '',
      studyTrack: json['studyTrack'] as String? ?? 'science',
      educationStage: json['educationStage'] as String? ?? 'high_school',
      hasCompletedOnboarding: json['hasCompletedOnboarding'] as bool? ?? false,
      level: (json['level'] as num?)?.toInt() ?? 1,
      currentXp: (json['currentXp'] as num?)?.toInt() ?? 0,
      nextLevelXp: (json['nextLevelXp'] as num?)?.toInt() ?? 500,
      streakDays: (json['streakDays'] as num?)?.toInt() ?? 1,
      coins: (json['coins'] as num?)?.toInt() ?? 100,
      league: json['league'] as String? ?? 'Bronze',
      title: json['title'] as String? ?? '新鋭チャレンジャー',
      unlockedTitles: (json['unlockedTitles'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const ['新鋭チャレンジャー'],
      avatarFrame: json['avatarFrame'] as String? ?? 'cyan',
      streakShields: (json['streakShields'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatarIcon': avatarIcon,
      'schoolGrade': schoolGrade,
      'targetUniversity': targetUniversity,
      'studyTrack': studyTrack,
      'educationStage': educationStage,
      'hasCompletedOnboarding': hasCompletedOnboarding,
      'level': level,
      'currentXp': currentXp,
      'nextLevelXp': nextLevelXp,
      'streakDays': streakDays,
      'coins': coins,
      'league': league,
      'title': title,
      'unlockedTitles': unlockedTitles,
      'avatarFrame': avatarFrame,
      'streakShields': streakShields,
    };
  }
}
