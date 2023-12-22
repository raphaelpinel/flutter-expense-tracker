import 'package:flutter/material.dart';

class AmountFormField extends StatelessWidget {
  const AmountFormField({
    super.key,
    required this.amountController,
  });

  final TextEditingController amountController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: amountController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        labelText: 'Amount',
        hintText: 'Enter an amount',
        suffixText: '€',
      ),
      keyboardType: TextInputType.number,
      validator: (val) {
        final value = val?.replaceAll(',', '.');
        if (value == null || value.isEmpty) {
          return 'Please enter an amount';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        if (double.parse(value) <= 0) {
          return 'Please enter a number greater than 0';
        }
        return null;
      },
    );
  }
}
