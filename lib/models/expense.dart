import 'package:expense_tracker/models/category_type.enum.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat('dd.MM.yyyy');

const uuid = Uuid();

class Expense {
  Expense(
      {required this.title,
      required this.amount,
      required this.date,
      this.category = CategoryType.other})
      : id = const Uuid().v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final CategoryType category;

  get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  ExpenseBucket({required this.expenses, required this.categoryType});

  ExpenseBucket.forCategory(allExpenses, this.categoryType)
      : expenses = allExpenses
            .where((expense) => expense.category == categoryType)
            .toList();

  final CategoryType categoryType;
  final List<Expense> expenses;

  double get totalAmount {
    return expenses.fold(0, (sum, expense) => sum + expense.amount);
  }
}
