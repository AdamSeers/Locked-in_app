import 'package:flutter/material.dart';

import '../models/food_type.dart';

/// Default food categories.
///
/// How many portions of each type there are per day — and what order
/// they show up in on the Full List page — is controlled entirely by
/// [defaultPortionOrder] below, not by anything here.
///
/// `examples` powers the "Examples" list in the long-press info sheet.
/// Amounts here match a nutritionist's specific portion plan (grams,
/// cups, tablespoons/teaspoons as given), rather than generic USDA
/// MyPlate figures.
final List<FoodType> defaultFoodTypes = [
  const FoodType(
    id: 'vegetables',
    name: 'Vegetables',
    emoji: '🥦',
    color: Color(0xFF4CAF50),
    infoTitle: 'Vegetables',
    infoText: 'A portion is 1 cup of vegetables.',
    examples: [
      FoodExample('Raw baby carrots', '1 cup'),
      FoodExample('Cooked broccoli', '1 cup'),
      FoodExample('Bell pepper strips', '1 cup'),
      FoodExample('Cherry tomatoes', '1 cup'),
      FoodExample('Cooked green beans', '1 cup'),
      FoodExample('Raw spinach or mixed greens', '1 cup'),
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
    infoText: 'A portion is about 2/3 of a banana, 1 cup of berries, or '
        '1 medium apple, pear, or orange — dried fruit and juice count '
        'for much less per portion.',
    examples: [
      FoodExample('Banana', '2/3'),
      FoodExample('Berries', '1 cup'),
      FoodExample('Apple, pear, or orange', '1'),
      FoodExample('Clementines or kiwis', '2'),
      FoodExample('Pineapple, melon, or grapes', '1/2 cup'),
      FoodExample('Frozen fruit', '1/2 cup'),
      FoodExample('Unsweetened fruit compote', '1/2 cup'),
      FoodExample('Dried fruit', '~1 tbsp'),
    ],
  ),
  const FoodType(
    id: 'grains',
    name: 'Grains',
    emoji: '🌾',
    color: Color(0xFFC98A2C),
    infoTitle: 'Grains',
    infoText: 'A portion is about 1 slice of bread, 30 g of cereal, '
        'crackers, or oatmeal, or 1/3 cup of granola.',
    examples: [
      FoodExample('Breakfast cereal', '30 g'),
      FoodExample('Bread', '1 slice'),
      FoodExample('English muffin', '1'),
      FoodExample('Bagel', '1/2'),
      FoodExample('Tortilla (6")', '1'),
      FoodExample('Oatmeal', '30 g (or 1 packet)'),
      FoodExample('Granola or AllBran Buds', '1/3 cup'),
      FoodExample('Granola or cereal bar', '1'),
      FoodExample('Store-bought muffin', '1/2'),
      FoodExample('Crackers', '30 g'),
      FoodExample('Rice cakes', '2'),
      FoodExample('Plain popcorn', '2-3 cups'),
      FoodExample('Roasted legumes (or in salad)', '1/4 cup'),
    ],
  ),
  const FoodType(
    id: 'dairy',
    name: 'Dairy',
    emoji: '🥛',
    color: Color(0xFF42A5F5),
    infoTitle: 'Dairy',
    infoText: 'A portion is about 1 cup of milk or soy beverage, 1/2 cup '
        'of yogurt, or 25 g of cheese.',
    examples: [
      FoodExample('Milk or soy beverage', '1 cup'),
      FoodExample('Yogurt', '1/2 cup'),
      FoodExample('Cottage cheese', '1/4 cup'),
      FoodExample('Cheese', '25 g (or 1-2 individually wrapped)'),
    ],
  ),
  const FoodType(
    id: 'protein',
    name: 'Protein',
    emoji: '🍗',
    color: Color(0xFF8D6E63),
    infoTitle: 'Protein',
    infoText: 'A portion is about 2 eggs, 3/4 cup of Greek yogurt, or '
        '50 g of light cheese.',
    examples: [
      FoodExample('Eggs', '2'),
      FoodExample('Egg whites or cottage cheese', '1/2 cup'),
      FoodExample('Greek yogurt', '3/4 cup'),
      FoodExample('High-protein milk (e.g. NatrelPlus, Silk 18g)', '1 cup'),
      FoodExample('Protein powder', '1 scoop'),
      FoodExample('Protein bar (>20 g protein)', '1'),
      FoodExample('Light cheese (0-20% M.F.)', '50 g (or 2-3 individually wrapped)'),
      FoodExample('Roasted edamame', '3/4 cup'),
    ],
  ),
  const FoodType(
    id: 'fats',
    name: 'Fats & Oils',
    emoji: '🥑',
    color: Color(0xFF9CCC65),
    infoTitle: 'Fats & Oils',
    infoText: 'A portion is about 2 tsp of peanut butter, 2-3 tbsp of '
        'hummus, or about 10 nuts or olives.',
    examples: [
      FoodExample('Peanut butter', '2 tsp (10 mL)'),
      FoodExample('Hummus or tofu spread', '2-3 tbsp (30-45 mL)'),
      FoodExample('Nuts or olives', '~10'),
      FoodExample('Avocado', '1/3'),
    ],
  ),
  const FoodType(
    id: 'added_sugars',
    name: 'Added Sugars',
    emoji: '🍬',
    color: Color(0xFFEC407A),
    infoTitle: 'Added Sugars',
    infoText: 'A portion is about 1 tbsp of honey, sugar, or syrup, '
        '1/2 cup of fruit juice, or one alcoholic drink.',
    examples: [
      FoodExample('Honey, sugar, maple syrup, or jam', '1 tbsp (15 mL)'),
      FoodExample('Fruit juice', '1/2 cup'),
      FoodExample('A dessert (e.g. cookies, chocolate)', '1 serving'),
      FoodExample('Ice cream', '1/4 cup'),
      FoodExample('Alcoholic drink', '1'),
    ],
  ),
];

/// The full, freely-reorderable list of portions shown on the Full List
/// page. Each entry references a food type (by id, matching
/// [defaultFoodTypes]) plus its own label. Reorder, interleave, add, or
/// remove entries here — the display order follows this list exactly,
/// entries don't need to stay grouped by food type, and each food type's
/// daily goal is simply how many times it appears here.
final List<PortionListItem> defaultPortionOrder = [

  const PortionTitle('Breakfast'),
  const PortionEntry('grains', 'Grains'),
  const PortionEntry('grains', 'Grains'),
  const PortionEntry('fruits', 'Fruit'),
  const PortionEntry('protein', 'Protein'),

  const PortionTitle('Dinner'),
  const PortionEntry('grains', 'Grains'),
  const PortionEntry('grains', 'Grains'),
  const PortionEntry('protein', 'Protein'),
  const PortionEntry('protein', 'Protein'),
  const PortionEntry('fats', 'Fats & Oils'),
  const PortionEntry('fats', 'Fats & Oils'),
  const PortionEntry('fats', 'Fats & Oils'),

  const PortionTitle('PM Snack'),
  const PortionEntry('grains', 'Grains'),
  const PortionEntry('grains', 'Grains'),
  const PortionEntry('fruits', 'Fruit'),
  const PortionEntry('fruits', 'Fruit'),
  const PortionEntry('dairy', 'Dairy'),

  const PortionTitle('Supper'),
  const PortionEntry('grains', 'Grains'),
  const PortionEntry('grains', 'Grains'),
  const PortionEntry('vegetables', 'Vegetables'),
  const PortionEntry('vegetables', 'Vegetables'),
  const PortionEntry('protein', 'Protein'),
  const PortionEntry('protein', 'Protein'),
  const PortionEntry('protein', 'Protein'),
  const PortionEntry('fats', 'Fats & Oils'),
  const PortionEntry('fats', 'Fats & Oils'),
  const PortionEntry('fats', 'Fats & Oils'),

  const PortionTitle('Night Snack'),
  const PortionEntry('dairy', 'Dairy'),
  const PortionEntry('fats', 'Fats & Oils'),
  const PortionEntry('added_sugars', 'Added Sugars'),
  const PortionEntry('added_sugars', 'Added Sugars'),
];