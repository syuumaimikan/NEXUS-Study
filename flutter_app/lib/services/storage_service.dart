import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const _profileKey = 'nexus_user_profile_v2';
  static const _attemptsKey = 'nexus_attempts_count';
  static const _correctKey = 'nexus_correct_count';
  static const _customCardsKey = 'nexus_custom_flashcards_v1';
  static const _weeklyActivityKey = 'nexus_weekly_activity_v1';

  Future<UserProfile> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_profileKey);
    if (jsonStr == null) {
      return UserProfile.defaultProfile();
    }
    try {
      final map = json.decode(jsonStr) as Map<String, dynamic>;
      return UserProfile.fromJson(map);
    } catch (_) {
      return UserProfile.defaultProfile();
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, json.encode(profile.toJson()));
  }

  Future<UserProfile> resetProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
    await prefs.remove(_attemptsKey);
    await prefs.remove(_correctKey);
    await prefs.remove(_customCardsKey);
    await prefs.remove(_weeklyActivityKey);
    return UserProfile.defaultProfile();
  }

  Future<void> recordAttempt(bool isCorrect, int xpEarned, {int bonusCoins = 0}) async {
    final prefs = await SharedPreferences.getInstance();
    final currentAttempts = prefs.getInt(_attemptsKey) ?? 0;
    final currentCorrect = prefs.getInt(_correctKey) ?? 0;

    await prefs.setInt(_attemptsKey, currentAttempts + 1);
    if (isCorrect) {
      await prefs.setInt(_correctKey, currentCorrect + 1);
    }

    // Record today's activity
    final now = DateTime.now();
    final todayKey = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final actJson = prefs.getString(_weeklyActivityKey);
    Map<String, dynamic> actMap = {};
    if (actJson != null) {
      try {
        actMap = json.decode(actJson) as Map<String, dynamic>;
      } catch (_) {}
    }
    final todayCount = (actMap[todayKey] as num?)?.toInt() ?? 0;
    actMap[todayKey] = todayCount + 1;
    await prefs.setString(_weeklyActivityKey, json.encode(actMap));

    final profile = await loadProfile();
    final updatedXp = profile.currentXp + xpEarned;
    var newLevel = profile.level;
    var nextXp = profile.nextLevelXp;

    if (updatedXp >= nextXp) {
      newLevel += 1;
      nextXp = (nextXp * 1.5).round();
    }

    await saveProfile(profile.copyWith(
      currentXp: updatedXp,
      level: newLevel,
      nextLevelXp: nextXp,
      coins: profile.coins + (isCorrect ? 10 : 2) + bonusCoins,
    ));
  }

  Future<Map<String, int>> getStats() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'attempts': prefs.getInt(_attemptsKey) ?? 0,
      'correct': prefs.getInt(_correctKey) ?? 0,
    };
  }

  // Activity map for last 7 days: Day name -> question count
  Future<List<Map<String, dynamic>>> getWeeklyActivity() async {
    final prefs = await SharedPreferences.getInstance();
    final actJson = prefs.getString(_weeklyActivityKey);
    Map<String, dynamic> actMap = {};
    if (actJson != null) {
      try {
        actMap = json.decode(actJson) as Map<String, dynamic>;
      } catch (_) {}
    }

    final dayNames = ['月', '火', '水', '木', '金', '土', '日'];
    final now = DateTime.now();
    final list = <Map<String, dynamic>>[];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final count = (actMap[dateKey] as num?)?.toInt() ?? 0;
      final dayLabel = dayNames[date.weekday - 1];
      list.add({
        'day': dayLabel,
        'date': dateKey,
        'count': count,
      });
    }

    return list;
  }

  // Custom Flashcard persistence
  Future<List<Map<String, String>>> loadCustomFlashcards() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_customCardsKey);
    if (jsonStr == null) return [];
    try {
      final list = json.decode(jsonStr) as List;
      return list.map((item) => Map<String, String>.from(item as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveCustomFlashcards(List<Map<String, String>> cards) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_customCardsKey, json.encode(cards));
  }

  Future<void> addCustomFlashcard(Map<String, String> card) async {
    final current = await loadCustomFlashcards();
    current.add(card);
    await saveCustomFlashcards(current);
  }

  Future<void> deleteCustomFlashcard(int index) async {
    final current = await loadCustomFlashcards();
    if (index >= 0 && index < current.length) {
      current.removeAt(index);
      await saveCustomFlashcards(current);
    }
  }
}
