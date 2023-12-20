import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/category_type.enum.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Flutter Course',
        amount: 9.99,
        date: DateTime.now(),
        category: CategoryType.education),
    Expense(
        title: 'New Desk',
        amount: 99.99,
        date: DateTime.now(),
        category: CategoryType.work),
    Expense(
        title: 'Cinema ticket',
        amount: 8.99,
        date: DateTime.now(),
        category: CategoryType.leisure),
  ];

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _deleteExpense(Expense expenseToDelete) {
    final expenseIndex = _registeredExpenses.indexOf(expenseToDelete);
    setState(() {
      _registeredExpenses.removeWhere((expense) => expense == expenseToDelete);
    });
    var snackbar = SnackBar(
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 5),
      content: const Row(
        children: [
          Text(
            'Expense deleted',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 10),
          Icon(
            Icons.check,
            color: Colors.white,
          )
        ],
      ),
      action: SnackBarAction(
        label: 'UNDO',
        textColor: Colors.white,
        onPressed: () {
          setState(() {
            _registeredExpenses.insert(expenseIndex, expenseToDelete);
          });
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => NewExpense(onAddExpense: _addExpense),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageIcon(
            const AssetImage('assets/images/expense_1.png'),
            color: Colors.grey[300],
            size: 200,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No expenses found.', style: TextStyle(fontSize: 18)),
              TextButton(
                  onPressed: _openAddExpenseOverlay,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add, color: Colors.blueAccent),
                      Text(
                        'Add one!',
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onDeleteExpense: _deleteExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Column(
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(
            child: mainContent,
          )
        ],
      ),
      // Your widget code here
    );
  }
}
