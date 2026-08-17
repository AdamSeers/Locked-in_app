import 'package:flutter/material.dart';

import '../models/food_type.dart';

/// One row on the Full List page — a single portion of a single food type.
class PortionTile extends StatelessWidget {
  final FoodType foodType;
  final String label;
  final bool isDone;
  final VoidCallback onTap;

  const PortionTile({
    required this.foodType,
    required this.label,
    required this.isDone,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        isDone ? Icons.check_circle : Icons.radio_button_unchecked,
        color: isDone ? foodType.color : Colors.grey.shade400,
      ),
      title: Text(
        '$label',//${foodType.name} —
      style: TextStyle(
          color: isDone ? Colors.grey.shade500 : null,
          decoration: isDone ? TextDecoration.lineThrough : null,
        ),
      ),
    );
  }
}