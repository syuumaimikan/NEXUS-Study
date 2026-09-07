import 'package:flutter/services.dart';
import '../models/user_profile.dart';

class WidgetService {
  static final WidgetService _instance = WidgetService._internal();
  factory WidgetService() => _instance;
  WidgetService._internal();

  static const MethodChannel _channel = MethodChannel('com.nexusstudy.app/widget');

  Future<bool> isPinSupported() async {
    try {
      final supported = await _channel.invokeMethod<bool>('isPinSupported');
      return supported ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> requestPinWidget(String widgetType) async {
    try {
      final success = await _channel.invokeMethod<bool>('requestPinWidget', {
        'widgetType': widgetType,
      });
      return success ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> syncWidgetData({
    required UserProfile profile,
    String? todayWord,
    String? formulaSubject,
    String? formulaTitle,
    String? formulaBody,
  }) async {
    try {
      // Calculate days to common test (approx Jan 16)
      final now = DateTime.now();
      var targetDate = DateTime(now.year, 1, 16);
      if (now.isAfter(targetDate)) {
        targetDate = DateTime(now.year + 1, 1, 16);
      }
      final countdownDays = targetDate.difference(now).inDays;

      await _channel.invokeMethod('updateWidgetData', {
        'streakDays': profile.streakDays,
        'todayWord': todayWord ?? 'scrutinize : を詳細に調べる',
        'targetSchool': profile.targetUniversity.isEmpty ? '難関大学・志望校' : profile.targetUniversity,
        'targetDeviation': profile.targetDeviation,
        'countdownDays': countdownDays,
        'formulaSubject': formulaSubject ?? '【数学】本日の重要公式',
        'formulaTitle': formulaTitle ?? '積分の1/6公式 (放物線と直線の面積)',
        'formulaBody': formulaBody ?? 'S = (|a| / 6) * (β - α)³',
      });
    } catch (_) {}
  }
}
