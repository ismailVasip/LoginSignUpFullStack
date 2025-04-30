import 'package:flutter/material.dart';
import 'package:login_signup_frontend/common/enums/gender.dart';

class GenderField extends StatefulWidget {
  final Function(Gender?)? onSelected;
  const GenderField({super.key, required this.onSelected});

  @override
  State<GenderField> createState() => _GenderFieldState();
}

class _GenderFieldState extends State<GenderField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: DropdownMenu(
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
              enableSearch: false,
              label: const Text('Select Gender'),
              width: MediaQuery.of(context).size.width / 2,
              dropdownMenuEntries: <DropdownMenuEntry<Gender>>[
                DropdownMenuEntry(value: Gender.male, label: 'Male'),
                DropdownMenuEntry(value: Gender.female, label: 'Female'),
                DropdownMenuEntry(value: Gender.other, label: 'Other'),
              ],
              onSelected: widget.onSelected,
            ),
          ),
        ],
      ),
    );
  }
}
