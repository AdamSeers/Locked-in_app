import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/routine_data.dart';
import '../models/routine_item.dart';

class RoutineProvider extends ChangeNotifier {
  static const _itemsKey = 'routine_items';
  static const _checkedKey = 'routine_checked';
  static const _logicalDayKey = 'routine_logical_day';
  static const _startTimeKey = 'routine_start_time_minutes';
  static const _resetHour = 3;

  List<RoutineItem> _items = List.of(defaultRoutineItems);
  Set<String> _checked = {};
  TimeOfDay? _startTime;
  String _logicalDay = '';
  bool _ready = false;
  Timer? _timer;

  List<RoutineItem> get items => _items;
  TimeOfDay? get startTime => _startTime;
  bool get isReady => _ready;

  RoutineProvider() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();

    final rawItems = prefs.getString(_itemsKey);
    if (rawItems != null) {
      final decoded = jsonDecode(rawItems) as List;
      _items = decoded
          .map(
            (e) => RoutineItem(
          id: e['id'] as String,
          label: e['label'] as String,
          durationMinutes: (e['durationMinutes'] as num?)?.toInt() ?? 10,
        ),
      )
          .toList();
    }

    final rawStartTime = prefs.getInt(_startTimeKey);
    if (rawStartTime != null) {
      _startTime = TimeOfDay(hour: rawStartTime ~/ 60, minute: rawStartTime % 60);
    }

    _logicalDay = _logicalDayFor(DateTime.now());
    final storedDay = prefs.getString(_logicalDayKey);

    if (storedDay == _logicalDay) {
      final rawChecked = prefs.getString(_checkedKey);
      if (rawChecked != null) {
        _checked = Set<String>.from(jsonDecode(rawChecked) as List);
      }
    } else {
      await _persistReset(prefs, _logicalDay);
    }

    _ready = true;
    _startTimer();
    notifyListeners();
  }

  String _logicalDayFor(DateTime time) {
    final effective =
    time.hour < _resetHour ? time.subtract(const Duration(days: 1)) : time;
    return '${effective.year.toString().padLeft(4, '0')}-'
        '${effective.month.toString().padLeft(2, '0')}-'
        '${effective.day.toString().padLeft(2, '0')}';
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => checkReset());
  }

  Future<void> checkReset() async {
    final today = _logicalDayFor(DateTime.now());
    if (today != _logicalDay) {
      final prefs = await SharedPreferences.getInstance();
      await _persistReset(prefs, today);
      notifyListeners();
    }
  }

  Future<void> _persistReset(SharedPreferences prefs, String day) async {
    _checked = {};
    _logicalDay = day;
    await prefs.setString(_logicalDayKey, day);
    await prefs.setString(_checkedKey, jsonEncode(_checked.toList()));
  }

  Future<void> resetChecked() async {
    final prefs = await SharedPreferences.getInstance();
    await _persistReset(prefs, _logicalDay);
    notifyListeners();
  }

  bool isChecked(String id) => _checked.contains(id);

  Future<void> toggle(String id) async {
    if (_checked.contains(id)) {
      _checked.remove(id);
    } else {
      _checked.add(id);
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_checkedKey, jsonEncode(_checked.toList()));
  }

  Future<void> setStartTime(TimeOfDay time) async {
    _startTime = time;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_startTimeKey, time.hour * 60 + time.minute);
  }

  Future<void> _persistItems() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      _items
          .map((e) => {
        'id': e.id,
        'label': e.label,
        'durationMinutes': e.durationMinutes,
      })
          .toList(),
    );
    await prefs.setString(_itemsKey, encoded);
  }

  Future<void> addItem(String label, int durationMinutes) async {
    final trimmed = label.trim();
    if (trimmed.isEmpty) return;
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    _items = [
      ..._items,
      RoutineItem(id: id, label: trimmed, durationMinutes: durationMinutes),
    ];
    notifyListeners();
    await _persistItems();
  }

  Future<void> renameItem(String id, String newLabel, int durationMinutes) async {
    final trimmed = newLabel.trim();
    if (trimmed.isEmpty) return;
    _items = [
      for (final item in _items)
        if (item.id == id)
          item.copyWith(label: trimmed, durationMinutes: durationMinutes)
        else
          item,
    ];
    notifyListeners();
    await _persistItems();
  }

  Future<void> removeItem(String id) async {
    _items = _items.where((e) => e.id != id).toList();
    _checked.remove(id);
    notifyListeners();
    await _persistItems();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_checkedKey, jsonEncode(_checked.toList()));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}