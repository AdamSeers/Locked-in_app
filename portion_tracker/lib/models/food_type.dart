import 'package:flutter/material.dart';

/// One "what could I eat" suggestion for a food type, e.g.
/// ("Cooked broccoli", "1 cup").
class FoodExample {
  final String name;
  final String amount;

  const FoodExample(this.name, this.amount);
}

/// One food category tracked by the app (e.g. Vegetables, Fruits).
class FoodType {
  final String id;
  final String name;
  final List<String> portions;
  final String emoji;
  final Color color;
  final String infoTitle;
  final String infoText;
  final List<FoodExample> examples;

  const FoodType({
    required this.id,
    required this.name,
    required this.portions,
    required this.emoji,
    required this.color,
    required this.infoTitle,
    required this.infoText,
    required this.examples,
  });

  /// Number of portions per day, derived from the hardcoded [portions] list.
  int get dailyGoal => portions.length;
}