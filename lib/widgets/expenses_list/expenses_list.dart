import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key,
      required this.expenses,
      required this.onDeleteExpense,
      required this.onOpenEditExpense});

  final List<Expense> expenses;
  final void Function(Expense expense) onDeleteExpense;
  final void Function(Expense expense) onOpenEditExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: ValueKey(expenses[index]),
          direction: DismissDirection.endToStart,
          background: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              color: Theme.of(context).colorScheme.error,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16.0),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
          onDismissed: (direction) {
            onDeleteExpense(expenses[index]);
          },
          child: InkWell(
              onTap: () {
                onOpenEditExpense(expenses[index]);
              },
              child: ExpenseItem(expenses[index])),
        );
      },
    );
  }
}
