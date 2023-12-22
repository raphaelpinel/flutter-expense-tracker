import 'package:flutter/material.dart';

class TitleFormField extends StatelessWidget {
  const TitleFormField({
    super.key,
    required this.titleController,
  });

  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: titleController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        labelText: 'Title',
        hintText: 'Enter a title',
      ),
      maxLength: 50,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a title';
        }
        return null;
      },
    );
  }
}
