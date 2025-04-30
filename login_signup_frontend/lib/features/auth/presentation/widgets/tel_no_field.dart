import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class TelephoneNumberField extends StatelessWidget {
  final TextEditingController phoneNumberController;
  final FormFieldValidator<String>? validator;
  const TelephoneNumberField({
    super.key,
    required this.phoneNumberController,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: FormField(
        validator: validator,
        builder: (formFieldState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntlPhoneField(
                keyboardType: TextInputType.phone,
                initialCountryCode: 'TR',
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w400,
                  ),
                  errorText: formFieldState.errorText,
                ),
                onChanged: (phone) {
                  phoneNumberController.text = phone.completeNumber;
                  formFieldState.didChange(phone.completeNumber);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
