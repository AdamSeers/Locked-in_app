import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/food_types_data.dart';
import '../models/food_type.dart';

/// Holds today's logged portions, persists them, and resets everything
/// at 3:00 AM each day (see [_resetHour]).
class PortionProvider extends ChangeNotifier {
  static const _consumedKey = 'consumed_portions';
  static const _logicalDayKey = 'logical_day';
  static const _resetHour = 3;

  final List<FoodType> foodTypes = defaultFoodTypes;
  final Map<String, int> _dailyGoals = _computeDailyGoals();

  Map<String, int> _consumed = {for (final f in defaultFoodTypes) f.id: 0};
  String _logicalDay = '';
  bool _ready = false;
  Timer? _timer;

  Map<String, int> get consumed => _consumed;
  bool get isReady => _ready;

  PortionProvider() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _logicalDay = _logicalDayFor(DateTime.now());
    final storedDay = prefs.getString(_logicalDayKey);

    if (storedDay == _logicalDay) {
      final raw = prefs.getString(_consumedKey);
      if (raw != null) {
        final decoded = Map<String, dynamic>.from(
          jsonDecode(raw) as Map,
        );
        _consumed = decoded.map(
          (key, value) => MapEntry(key, value as int),
        );
        for (final f in foodTypes) {
          _consumed.putIfAbsent(f.id, () => 0);
        }
      }
    } else {
      await _persistReset(prefs, _logicalDay);
    }

    _ready = true;
    _startTimer();
    notifyListeners();
  }

  /// The "logical day" a given moment belongs to: anything before
  /// [_resetHour] still counts as the previous day.
  String _logicalDayFor(DateTime time) {
    final effective =
        time.hour < _resetHour ? time.subtract(const Duration(days: 1)) : time;
    return '${effective.year.toString().padLeft(4, '0')}-'
        '${effective.month.toString().padLeft(2, '0')}-'
        '${effective.day.toString().padLeft(2, '0')}';
  }

  void _startTimer() {
    _timer?.cancel();
    // Lets an open app roll over automatically at 3 AM without a restart.
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => checkReset());
  }

  /// Call this when the app resumes, in case 3 AM passed while it was
  /// backgrounded (and the periodic timer above was suspended by the OS).
  Future<void> checkReset() async {
    final today = _logicalDayFor(DateTime.now());
    if (today != _logicalDay) {
      final prefs = await SharedPreferences.getInstance();
      await _persistReset(prefs, today);
      notifyListeners();
    }
  }

  Future<void> _persistReset(SharedPreferences prefs, String day) async {
    _consumed = {for (final f in foodTypes) f.id: 0};
    _logicalDay = day;
    await prefs.setString(_logicalDayKey, day);
    await prefs.setString(_consumedKey, jsonEncode(_consumed));
  }

  /// Manually clears all of today's logged portions. Used by the reset
  /// button as a fallback when the automatic 3 AM reset didn't fire.
  Future<void> resetToday() async {
    final prefs = await SharedPreferences.getInstance();
    await _persistReset(prefs, _logicalDay);
    notifyListeners();
  }

  int consumedFor(String id) => _consumed[id] ?? 0;

  int remainingFor(String id) {
    final foodType = foodTypes.firstWhere((f) => f.id == id);
    final left = dailyGoalFor(id) - consumedFor(id);
    return left < 0 ? 0 : left;
  }

  int get totalGoal => foodTypes.fold(0, (sum, f) => sum + dailyGoalFor(f.id));

  int get totalConsumed => _consumed.values.fold(0, (sum, v) => sum + v);

  Future<void> logPortion(String id) async {
    final foodType = foodTypes.firstWhere((f) => f.id == id);
    final current = consumedFor(id);
    //if (current >= foodType.dailyGoal) return;

    _consumed[id] = current + 1;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_consumedKey, jsonEncode(_consumed));
  }

  Future<void> unlogPortion(String id) async {
    final current = consumedFor(id);
    if (current <= 0) return;

    _consumed[id] = current - 1;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_consumedKey, jsonEncode(_consumed));
  }

  static Map<String, int> _computeDailyGoals() {
    final goals = <String, int>{};
    for (final item in defaultPortionOrder) {
      if (item is PortionEntry) {
        goals[item.foodTypeId] = (goals[item.foodTypeId] ?? 0) + 1;
      }
    }
    return goals;
  }

  int dailyGoalFor(String id) => _dailyGoals[id] ?? 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
