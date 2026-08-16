import 'package:flutter/material.dart';

/// One food category tracked by the app (e.g. Vegetables, Fruits).
class FoodType {
  final String id;
  final String name;
  final int dailyGoal;
  final String emoji;
  final Color color;
  final String infoTitle;
  final String infoText;

  const FoodType({
    required this.id,
    required this.name,
    required this.dailyGoal,
    required this.emoji,
    required this.color,
    required this.infoTitle,
    required this.infoText,
  });
}
