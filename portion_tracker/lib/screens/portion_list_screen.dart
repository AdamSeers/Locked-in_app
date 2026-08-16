import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/portion_provider.dart';
import '../widgets/portion_tile.dart';

class PortionListScreen extends StatelessWidget {
  const PortionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortionProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Full List')),
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
                    padding: const EdgeInsets.only(bottom: 24),
                    children: [
                      for (final foodType in provider.foodTypes) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                          child: Row(
                            children: [
                              Text(
                                foodType.emoji,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                foodType.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        for (int i = 0; i < foodType.dailyGoal; i++)
                          PortionTile(
                            foodType: foodType,
                            portionNumber: i + 1,
                            isDone: i < provider.consumedFor(foodType.id),
                          ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
