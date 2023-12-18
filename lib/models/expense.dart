import 'package:expense_tracker/models/category_type.enum.dart';
import 'package:uuid/uuid.dart';

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
}
