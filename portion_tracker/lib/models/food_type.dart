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
  final String emoji;
  final Color color;
  final String infoTitle;
  final String infoText;
  final List<FoodExample> examples;

  const FoodType({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
    required this.infoTitle,
    required this.infoText,
    required this.examples,
  });
}

/// One row on the Full List page: a specific portion of a specific food
/// type. Where this appears in `defaultPortionOrder` (in
/// food_types_data.dart) is exactly where it shows up in the list — food
/// types don't have to stay grouped together, and each food type's daily
/// goal is simply how many times it appears in that list.
abstract class PortionListItem {
  const PortionListItem();
}

class PortionEntry extends PortionListItem {
  final String foodTypeId;
  final String label;

  const PortionEntry(this.foodTypeId, this.label);
}

class PortionTitle extends PortionListItem {
  final String text;
  const PortionTitle(this.text);
}