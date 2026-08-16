import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/portion_provider.dart';
import '../widgets/food_type_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortionProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Today's Portions")),
      body: !provider.isReady
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemCount: provider.foodTypes.length,
                itemBuilder: (context, index) {
                  return FoodTypeCard(foodType: provider.foodTypes[index]);
                },
              ),
            ),
    );
  }
}
