import 'package:flutter/material.dart';

import '../models/food_type.dart';

/// Default food categories and their hardcoded daily portions.
///
/// Each food type's `portions` list is a literal, editable list of labels
/// — add, remove, or rename entries to change what shows up on both
/// pages. The number of portions per day is simply that list's length.
final List<FoodType> defaultFoodTypes = [
  const FoodType(
    id: 'vegetables',
    name: 'Vegetables',
    emoji: '🥦',
    color: Color(0xFF4CAF50),
    infoTitle: 'Vegetables',
    infoText: 'A portion is about 1 cup of raw or cooked vegetables, or '
        '2 cups of raw leafy greens.',
    examples: [
      FoodExample('Raw baby carrots', '1 cup'),
      FoodExample('Cooked broccoli', '1 cup'),
      FoodExample('Bell pepper strips', '1 cup'),
      FoodExample('Cherry tomatoes', '1 cup'),
      FoodExample('Cooked green beans', '1 cup'),
      FoodExample('Raw spinach or mixed greens', '2 cups'),
      FoodExample('Cooked spinach', '1 cup'),
      FoodExample('Cooked mushrooms', '1 cup'),
      FoodExample('Cooked cauliflower', '1 cup'),
      FoodExample('100% vegetable juice', '1 cup'),
    ],
  ),
  const FoodType(
    id: 'fruits',
    name: 'Fruits',
    emoji: '🍎',
    color: Color(0xFFE53935),
    infoTitle: 'Fruits',
    infoText: 'A portion is about 1 cup of fruit, or 1/2 cup of dried '
        'fruit (dried fruit is more concentrated, so it counts double).',
    examples: [
      FoodExample('Sliced strawberries', '1 cup'),
      FoodExample('Grapes', '1 cup (about 32)'),
      FoodExample('Large banana', '1'),
      FoodExample('Melon or pineapple chunks', '1 cup'),
      FoodExample('Mixed berries', '1 cup'),
      FoodExample('Orange segments', '1 cup'),
      FoodExample('Applesauce', '1 cup'),
      FoodExample('100% fruit juice', '1 cup'),
      FoodExample('Raisins or dried cranberries', '1/2 cup'),
    ],
  ),
  const FoodType(
    id: 'grains',
    name: 'Grains',
    emoji: '🌾',
    color: Color(0xFFC98A2C),
    infoTitle: 'Grains',
    infoText: 'A portion is about 1 slice of bread, 1/2 cup of cooked '
        'rice, pasta, or oatmeal, or 1 cup of ready-to-eat cereal.',
    examples: [
      FoodExample('Bread', '1 slice'),
      FoodExample('Cooked rice', '1/2 cup'),
      FoodExample('Cooked pasta', '1/2 cup'),
      FoodExample('Cooked oatmeal', '1/2 cup'),
      FoodExample('Ready-to-eat cereal', '1 cup'),
      FoodExample('English muffin', '1/2'),
      FoodExample('Pancake (4.5")', '1'),
      FoodExample('Small tortilla (6")', '1'),
    ],
  ),
  const FoodType(
    id: 'dairy',
    name: 'Dairy',
    emoji: '🥛',
    color: Color(0xFF42A5F5),
    infoTitle: 'Dairy',
    infoText: 'A portion is about 1 cup of milk or yogurt, or 1.5 oz of '
        'natural cheese (cheese is conventionally measured by weight, '
        'not volume).',
    examples: [
      FoodExample('Milk', '1 cup'),
      FoodExample('Yogurt', '1 cup'),
      FoodExample('Fortified soy milk', '1 cup'),
      FoodExample('Lactose-free milk', '1 cup'),
      FoodExample('Natural cheese (cheddar, mozzarella, swiss)', '1.5 oz'),
      FoodExample('Processed cheese', '2 oz'),
    ],
  ),
  const FoodType(
    id: 'protein',
    name: 'Protein',
    emoji: '🍗',
    color: Color(0xFF8D6E63),
    infoTitle: 'Protein',
    infoText: 'A portion is about 1 oz of cooked meat, poultry, or fish, '
        '1 egg, 1 tbsp of peanut butter, or 1/4 cup of cooked beans '
        '(meat and fish are conventionally measured by weight, not '
        'volume).',
    examples: [
      FoodExample('Cooked meat, poultry, or fish', '1 oz'),
      FoodExample('Egg', '1'),
      FoodExample('Peanut butter (or other nut butter)', '1 tbsp'),
      FoodExample('Cooked beans, peas, or lentils', '1/4 cup'),
      FoodExample('Nuts or seeds', '1/2 oz (small handful)'),
    ],
  ),
  const FoodType(
    id: 'fats',
    name: 'Fats & Oils',
    emoji: '🥑',
    color: Color(0xFF9CCC65),
    infoTitle: 'Fats & Oils',
    infoText: 'A portion is about 1 tsp of oil, butter, or margarine, or '
        '1 tbsp of regular salad dressing.',
    examples: [
      FoodExample('Cooking oil (olive, canola, vegetable)', '1 tsp'),
      FoodExample('Butter or soft margarine', '1 tsp'),
      FoodExample('Regular salad dressing', '1 tbsp'),
      FoodExample('Large olives', '8'),
      FoodExample('Avocado', '1/2 medium (~3 portions)'),
    ],
  ),
  const FoodType(
    id: 'added_sugars',
    name: 'Added Sugars',
    emoji: '🍬',
    color: Color(0xFFEC407A),
    infoTitle: 'Added Sugars',
    infoText: 'A portion is about 1 tsp of sugar, honey, or syrup — '
        'roughly 4 grams. Sweetened drinks add up fast: a 12 oz can of '
        'soda alone runs about 8-10 tsp.',
    examples: [
      FoodExample('Granulated sugar', '1 tsp'),
      FoodExample('Honey', '1 tsp'),
      FoodExample('Maple syrup', '1 tsp'),
      FoodExample('Jam or jelly', '1 tsp'),
      FoodExample('Regular soda (12 oz can)', '~8-10 tsp total'),
    ],
  ),
];

/// The full, freely-reorderable list of portions shown on the Full List
/// page. Each entry references a food type (by id, matching
/// [defaultFoodTypes]) plus its own label. Reorder, interleave, add, or
/// remove entries here — the display order follows this list exactly,
/// entries don't need to stay grouped by food type, and each food type's
/// daily goal is simply how many times it appears here.
final List<PortionEntry> defaultPortionOrder = [
  //Breakfast
  const PortionEntry('grains', 'Breakfast Grains'),
  const PortionEntry('grains', 'Breakfast Grains'),
  const PortionEntry('fruits', 'Breakfast Fruit'),
  const PortionEntry('protein', 'Breakfast Protein'),

  //Dinner
  const PortionEntry('grains', 'Dinner Grains'),
  const PortionEntry('grains', 'Dinner Grains'),
  const PortionEntry('protein', 'Dinner Protein'),
  const PortionEntry('protein', 'Dinner Protein'),
  const PortionEntry('fats', 'Dinner Fats & Oils'),
  const PortionEntry('fats', 'Dinner Fats & Oils'),
  const PortionEntry('fats', 'Dinner Fats & Oils'),

  //Collation PM
  const PortionEntry('grains', 'PM Snack Grains'),
  const PortionEntry('grains', 'PM Snack Grains'),
  const PortionEntry('fruits', 'PM Snack Fruit'),
  const PortionEntry('fruits', 'PM Snack Fruit'),
  const PortionEntry('dairy', 'PM Snack Dairy'),

  //Supper
  const PortionEntry('grains', 'Supper Grains'),
  const PortionEntry('grains', 'Supper Grains'),
  const PortionEntry('vegetables', 'Supper Vegetables'),
  const PortionEntry('vegetables', 'Supper Vegetables'),
  const PortionEntry('protein', 'Supper Protein'),
  const PortionEntry('protein', 'Supper Protein'),
  const PortionEntry('protein', 'Supper Protein'),
  const PortionEntry('fats', 'Supper Fats & Oils'),
  const PortionEntry('fats', 'Supper Fats & Oils'),
  const PortionEntry('fats', 'Supper Fats & Oils'),

  //Night snack
  const PortionEntry('dairy', 'Night Snack Dairy'),
  const PortionEntry('fats', 'Night Snack Fats & Oils'),
  const PortionEntry('added_sugars', 'Night Snack Added Sugars'),
  const PortionEntry('added_sugars', 'Night Snack Added Sugars'),
];