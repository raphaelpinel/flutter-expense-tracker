import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/category_type.enum.dart';
import 'package:flutter/material.dart';

List<Category> categories = [
  Category(type: CategoryType.work, icon: Icons.work),
  Category(type: CategoryType.food, icon: Icons.fastfood),
  Category(type: CategoryType.education, icon: Icons.school),
  Category(type: CategoryType.travel, icon: Icons.flight),
  Category(type: CategoryType.leisure, icon: Icons.sports_soccer),
  Category(type: CategoryType.other, icon: Icons.category),
];

IconData getCategoryIconData(CategoryType categoryType) {
  for (var category in categories) {
    if (category.type == categoryType) {
      return category.icon;
    }
  }
  return Icons.category;
}
