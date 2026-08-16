import 'package:flutter/material.dart';

import '../models/food_type.dart';

/// Default food categories and daily portion goals.
///
/// Edit this list to match your own targets — add, remove, rename, or
/// re-order entries and the rest of the app follows automatically. The
/// `id` should stay unique and stable, since it's used as the storage key.
final List<FoodType> defaultFoodTypes = [
  const FoodType(
    id: 'vegetables',
    name: 'Vegetables',
    dailyGoal: 5,
    emoji: '🥦',
    color: Color(0xFF4CAF50),
    infoTitle: 'Vegetables',
    infoText: 'Aim for a variety of colors across the day. A portion is '
        'roughly 125 mL (1/2 cup) cooked, or 250 mL (1 cup) raw leafy '
        'greens.',
  ),
  const FoodType(
    id: 'fruits',
    name: 'Fruits',
    dailyGoal: 4,
    emoji: '🍎',
    color: Color(0xFFE53935),
    infoTitle: 'Fruits',
    infoText: 'Whole fruit is better than juice for fibre. A portion is '
        'one medium fruit, or 125 mL (1/2 cup) chopped fruit or berries.',
  ),
  const FoodType(
    id: 'grains',
    name: 'Grains',
    dailyGoal: 6,
    emoji: '🌾',
    color: Color(0xFFC98A2C),
    infoTitle: 'Grains',
    infoText: 'Choose whole grains when you can. A portion is about one '
        'slice of bread, 125 mL (1/2 cup) cooked rice or pasta, or 30 g '
        'of cereal.',
  ),
  const FoodType(
    id: 'dairy',
    name: 'Dairy',
    dailyGoal: 2,
    emoji: '🥛',
    color: Color(0xFF42A5F5),
    infoTitle: 'Dairy',
    infoText: 'A portion is about 250 mL (1 cup) milk or fortified plant '
        'milk, 175 g of yogurt, or 45 g of cheese.',
  ),
  const FoodType(
    id: 'protein',
    name: 'Protein',
    dailyGoal: 3,
    emoji: '🍗',
    color: Color(0xFF8D6E63),
    infoTitle: 'Protein',
    infoText: 'Meat, fish, eggs, tofu, and legumes all count. A portion '
        'is about 75 g cooked meat or fish, 2 eggs, or 175 mL (3/4 cup) '
        'legumes.',
  ),
  const FoodType(
    id: 'fats',
    name: 'Fats & Oils',
    dailyGoal: 2,
    emoji: '🥑',
    color: Color(0xFF9CCC65),
    infoTitle: 'Fats & Oils',
    infoText: 'Favor unsaturated fats. A portion is about 5-10 mL '
        '(1-2 tsp) of oil, butter, or nut butter.',
  ),
];
