import 'package:expense_tracker/widgets/add_edit_expense_form/amount_form_field.dart';
import 'package:expense_tracker/widgets/add_edit_expense_form/category_selector.dart';
import 'package:expense_tracker/widgets/add_edit_expense_form/date_selector.dart';
import 'package:expense_tracker/widgets/add_edit_expense_form/title_form_field.dart';
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

  void onDateChanged(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void onCategoryChanged(CategoryType category) {
    setState(() {
      _selectedCategory = category;
    });
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
                          child:
                              TitleFormField(titleController: _titleController),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: AmountFormField(
                              amountController: _amountController),
                        ),
                      ],
                    ),
                  ] else ...[
                    TitleFormField(titleController: _titleController),
                  ],
                  if (isLargeWidth) ...[
                    Row(
                      children: [
                        Expanded(
                          child: CategorySelector(
                            selectedCategory: _selectedCategory,
                            onCategoryChanged: onCategoryChanged,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: DateSelector(
                            date: _selectedDate,
                            onDateChanged: onDateChanged,
                            showDateError: showDateError,
                          ),
                        )
                      ],
                    ),
                  ] else ...[
                    Row(
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 150,
                          ),
                          child: AmountFormField(
                              amountController: _amountController),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DateSelector(
                            date: _selectedDate,
                            onDateChanged: onDateChanged,
                            showDateError: showDateError,
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
                          child: CategorySelector(
                            selectedCategory: _selectedCategory,
                            onCategoryChanged: onCategoryChanged,
                          ),
                        ),
                        const SizedBox(width: 16),
                        TextButton(
                            onPressed: _closeModal,
                            child: const Text('Cancel')),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: Text(submitButtonText),
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
