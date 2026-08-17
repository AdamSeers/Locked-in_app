import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/food_type.dart';
import '../providers/portion_provider.dart';

/// A single grid card for one food type. Tap logs a portion; long-press
/// shows more information in a sheet that slides up from the bottom.
class FoodTypeCard extends StatelessWidget {
  final FoodType foodType;

  const FoodTypeCard({required this.foodType, super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortionProvider>();
    final remaining = provider.remainingFor(foodType.id);
    final isDone = remaining == 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isDone
            ? (isDark ? Colors.grey.shade800 : Colors.grey.shade200)
            : foodType.color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDone ? Colors.transparent : foodType.color,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isDone ? null : () => provider.logPortion(foodType.id),
          onLongPress: () => _showInfoSheet(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Opacity(
                  opacity: isDone ? 0.35 : 1.0,
                  child: Text(
                    foodType.emoji,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  foodType.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDone ? Colors.grey.shade600 : null,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  isDone
                      ? 'Done for today'
                      : '$remaining left of ${provider.dailyGoalFor(foodType.id)}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDone
                            ? Colors.grey.shade500
                            : Colors.grey.shade700,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showInfoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.35,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(foodType.emoji, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        foodType.infoTitle,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  foodType.infoText,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (foodType.examples.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    'Examples',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 16),
                  for (final example in foodType.examples)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              example.name,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            example.amount,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: foodType.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
                const SizedBox(height: 8),
              ],
            );
          },
        );
      },
    );
  }
}
