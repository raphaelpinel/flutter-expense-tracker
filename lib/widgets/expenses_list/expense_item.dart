import 'package:expense_tracker/models/category_icons.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(
    this.expense, {
    super.key,
  });

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Colors.purple[400], // Set the background color to light purple
      // margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),

      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(expense.title, style: Theme.of(context).textTheme.titleMedium),
            Row(
              children: [
                Text(
                    '${expense.amount.toStringAsFixed(2).replaceAll('.', ',')} €'),
                const Spacer(),
                Icon(categoryIcons[expense.category]),
                const SizedBox(width: 5),
                Text(expense.formattedDate),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
