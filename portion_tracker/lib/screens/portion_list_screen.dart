import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/food_types_data.dart';
import '../models/food_type.dart';
import '../providers/portion_provider.dart';
import '../widgets/portion_tile.dart';
import '../widgets/reset_button.dart';

/// Shows every portion for the day in exactly the order they're listed
/// in [defaultPortionOrder] — food types are not grouped together, and
/// [PortionTitle] rows can be dropped in anywhere as section headers.
class PortionListScreen extends StatelessWidget {
  const PortionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortionProvider>();
    final seen = <String, int>{};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Full List'),
        actions: [const ResetButton()],
      ),
      body: !provider.isReady
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress today',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${provider.totalConsumed} / ${provider.totalGoal}',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: provider.totalGoal == 0
                    ? 0
                    : provider.totalConsumed / provider.totalGoal,
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              children: [
                for (final item in defaultPortionOrder)
                  _buildItem(context, provider, item, seen),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
      BuildContext context,
      PortionProvider provider,
      PortionListItem item,
      Map<String, int> seen,
      ) {
    if (item is PortionTitle) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
        child: Text(
          item.text,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    final entry = item as PortionEntry;
    final foodType = provider.foodTypes.firstWhere(
          (f) => f.id == entry.foodTypeId,
    );
    final index = seen[entry.foodTypeId] ?? 0;
    seen[entry.foodTypeId] = index + 1;
    final isDone = index < provider.consumedFor(entry.foodTypeId);

    return PortionTile(
      foodType: foodType,
      label: entry.label,
      isDone: isDone,
      onTap: () {
        if (isDone) {
          provider.unlogPortion(entry.foodTypeId);
        } else {
          provider.logPortion(entry.foodTypeId);
        }
      },
    );
  }
}