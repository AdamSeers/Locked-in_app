import 'package:flutter/material.dart';

import '../models/food_type.dart';

/// One row on the Full List page — a single portion of a single food type.
class PortionTile extends StatelessWidget {
  final FoodType foodType;
  final int portionNumber;
  final bool isDone;

  const PortionTile({
    required this.foodType,
    required this.portionNumber,
    required this.isDone,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        isDone ? Icons.check_circle : Icons.radio_button_unchecked,
        color: isDone ? foodType.color : Colors.grey.shade400,
      ),
      title: Text(
        '${foodType.name} — Portion $portionNumber',
        style: TextStyle(
          color: isDone ? Colors.grey.shade500 : null,
          decoration: isDone ? TextDecoration.lineThrough : null,
        ),
      ),
    );
  }
}
