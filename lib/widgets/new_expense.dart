import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/category_type.enum.dart';
import 'package:intl/intl.dart';

class AddEditExpense extends StatefulWidget {
  const AddEditExpense(
      {super.key,
      required this.onSaveExpense,
      required this.isNewExpense,
      this.expense});

  final void Function(Expense expense) onSaveExpense;
  final bool isNewExpense;
  final Expense? expense;

  @override
  State<AddEditExpense> createState() => _AddEditExpenseState();
}

class _AddEditExpenseState extends State<AddEditExpense> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  CategoryType _selectedCategory = CategoryType.other;
  var _hasBeenSubmitted = false;
  var _isDateValid = false;
  String submitButtonText = 'Save';

  final List<DropdownMenuItem<CategoryType>> _categoryOptionsItems =
      CategoryType.values
          .map((category) => DropdownMenuItem(
                value: category,
                child: Text(toBeginningOfSentenceCase(category.name)),
              ))
          .toList();

  @override
  void initState() {
    super.initState();
    if (!widget.isNewExpense && widget.expense != null) {
      _titleController.text = widget.expense!.title;
      _amountController.text = widget.expense!.amount.toString();
      _selectedDate = widget.expense!.date;
      _selectedCategory = widget.expense!.category;
    }
    if (widget.isNewExpense) {
      submitButtonText = 'Add Expense';
    }
  }

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
      widget.onSaveExpense(Expense(
        id: widget.expense?.id,
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
    final keyboardInsertedContent = MediaQuery.of(context).viewInsets.bottom;

    var showDateError =
        _selectedDate == null && _hasBeenSubmitted && !_isDateValid;

    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;
      // different layout used for landscape mode or tablets
      final isLargeWidth = width >= 600;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.fromLTRB(20, 10, 20, keyboardInsertedContent + 20),
            child: Form(
              key: _formKey,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (isLargeWidth) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _titleController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                                labelText: 'Title', hintText: 'Title'),
                            maxLength: 50,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          // width: 100,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _amountController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                                labelText: 'Amount', suffixText: '€'),
                            validator: _validateAmount,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
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
                  ],
                  if (isLargeWidth) ...[
                    Row(
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
                        const SizedBox(width: 24),
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
                  ] else ...[
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _amountController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                                label: Text('Amount'), suffixText: '€'),
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
                  ],
                  const SizedBox(height: 16),
                  if (isLargeWidth) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: _closeModal,
                            child: const Text('Cancel')),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: Text(submitButtonText),
                        ),
                      ],
                    ),
                  ] else ...[
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
                        TextButton(
                            onPressed: _closeModal,
                            child: const Text('Cancel')),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: const Text('Add Expense'),
                        ),
                      ],
                    )
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
