import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/category_type.enum.dart';
import 'package:intl/intl.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  CategoryType _selectedCategory = CategoryType.other;
  var _hasBeenSubmitted = false;
  var _isDateValid = false;

  final List<DropdownMenuItem<CategoryType>> _categoryOptionsItems =
      CategoryType.values
          .map((category) => DropdownMenuItem(
                value: category,
                child: Text(toBeginningOfSentenceCase(category.name)),
              ))
          .toList();

  void _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _closeModal() {
    Navigator.pop(context);
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount';
    }
    final amount = double.tryParse(value.replaceAll(',', '.'));
    if (amount == null || amount <= 0) {
      return 'Please enter a valid amount';
    }
    return null;
  }

  String? _validateDate(DateTime? value) {
    if (value == null) {
      return 'Please enter a date';
    }
    setState(() {
      _isDateValid = true;
    });
    return null;
  }

  void _submitForm() {
    setState(() {
      _hasBeenSubmitted = true;
    });
    var isRestOfFormValid = _formKey.currentState!.validate();
    // both date and rest of form need to be evaluated
    if (_validateDate(_selectedDate) == null && isRestOfFormValid) {
      // Form is valid, add expense
      widget.onAddExpense(Expense(
        title: _titleController.text.trim(),
        amount:
            double.parse(_amountController.text.trim().replaceAll(',', '.')),
        date: _selectedDate!,
        category: _selectedCategory,
      ));
      _closeModal();
    }
  }

  @override
  Widget build(BuildContext context) {
    var showDateError =
        _selectedDate == null && _hasBeenSubmitted && !_isDateValid;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      child: Form(
        key: _formKey,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFormField(
              controller: _titleController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(label: Text('Title')),
              maxLength: 50,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    
                    keyboardType: TextInputType.number,
                    controller: _amountController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                        label: Text('Amount'), suffixText: '€'),
                    onChanged: (value) {
                      // Add your onChanged logic here
                    },
                    validator: _validateAmount,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        showDateError
                            ? 'Please select a date'
                            : _selectedDate == null
                                ? 'No date Selected'
                                : formatter.format(_selectedDate!),
                        style: TextStyle(
                          color: showDateError
                              ? Theme.of(context).colorScheme.error
                              : null,
                        ),
                      ),
                      IconButton(
                          icon: const Icon(Icons.calendar_month),
                          color: showDateError
                              ? Theme.of(context).colorScheme.error
                              : null,
                          onPressed: _presentDatePicker)
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: DropdownButtonFormField<CategoryType>(
                    value: _selectedCategory,
                    style: Theme.of(context).textTheme.bodyMedium,
                    onChanged: (newValue) {
                      if (newValue == null) {
                        return;
                      }
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                    items: _categoryOptionsItems,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(onPressed: _closeModal, child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Add Expense'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
