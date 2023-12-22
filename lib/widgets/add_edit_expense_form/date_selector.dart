import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class DateSelector extends StatefulWidget {
  const DateSelector({
    super.key,
    this.date,
    required this.onDateChanged,
    required this.showDateError,
  });

  final DateTime? date;
  final Function(DateTime) onDateChanged;
  final bool showDateError;

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  void _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.date ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
    );
    if (pickedDate == null) {
      return;
    }
    widget.onDateChanged(pickedDate);
  }

  @override
  Widget build(BuildContext context) {
    final errorTextStyle = TextStyle(
      color: Theme.of(context).colorScheme.error,
      fontSize: 12,
    );

    return TextButton(
      onPressed: _presentDatePicker,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.showDateError
              ? Text(
                  'Please select a date',
                  style: errorTextStyle,
                )
              : Text(
                  widget.date == null
                      ? 'No date Selected'
                      : formatter.format(widget.date!),
                ),
          const SizedBox(width: 10),
          Icon(Icons.calendar_month,
              color: widget.showDateError
                  ? Theme.of(context).colorScheme.error
                  : null),
        ],
      ),
    );
  }
}
