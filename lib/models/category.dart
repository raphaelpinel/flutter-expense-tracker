import 'package:expense_tracker/models/category_type.enum.dart';
import 'package:flutter/material.dart';

class Category {
  Category({required this.type, required this.icon});
  CategoryType type;
  IconData icon;
}
