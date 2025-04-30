import 'package:flutter/material.dart';

class BirthDayPicker extends StatefulWidget {
  final TextEditingController birthDateController;
  final FormFieldValidator<String>? validator;
  const BirthDayPicker({super.key, required this.birthDateController,required this.validator});

  @override
  State<BirthDayPicker> createState() => _BirthDayPickerState();
}

class _BirthDayPickerState extends State<BirthDayPicker> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: widget.birthDateController,
        validator: widget.validator,
        decoration: InputDecoration(
          labelText: 'Birth Date',
          filled: true,
          prefixIcon: const Icon(Icons.calendar_today),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        readOnly: true,
        onTap: () {
          _selectBirthDate();
        },
      ),
    );
  }

  Future<void> _selectBirthDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      widget.birthDateController.text = picked.toString().split(' ')[0];
    }
  }
}
