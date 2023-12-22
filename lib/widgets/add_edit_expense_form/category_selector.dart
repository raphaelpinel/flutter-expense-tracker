import 'package:expense_tracker/models/category_type.enum.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  final CategoryType selectedCategory;
  final void Function(CategoryType category) onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<CategoryType>> categoryOptionsItems =
        CategoryType.values
            .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(toBeginningOfSentenceCase(category.name)),
                ))
            .toList();
    return DropdownButtonFormField<CategoryType>(
        value: selectedCategory,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: const InputDecoration(
          labelText: 'Category',
        ),
        items: categoryOptionsItems,
        onChanged: (newValue) {
          if (newValue == null) {
            return;
          }
          onCategoryChanged(newValue);
        });
  }
}
