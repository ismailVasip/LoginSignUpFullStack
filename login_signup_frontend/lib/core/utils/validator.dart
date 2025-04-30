import 'package:email_validator/email_validator.dart';

class Validators {
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Fullname can not be empty.';
    }
    if (value.length < 5 && value.length > 50) {
      return 'Fullname should be between 5 and 50 characters long.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password can not be empty.';
    }
    if (value.length < 8) {
      return 'Password should be at least 8 characters long.';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password should contain at least one number.';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password should contain at least one lowercase letter.';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password should contain at least one uppercase letter.';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email can not be empty.';
    }
    if (!EmailValidator.validate(value)) {
      return 'Invalid email format.';
    }
    return null;
  }

  static String? validateDateBirth(String? value) {
    if (value == null || value.isEmpty) {
      return 'Birth date can not be empty.';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number cannot be empty.';
    }
    final regex = RegExp(r'^\+[1-9]\d{1,14}$');
    if (!regex.hasMatch(value)) {
      return 'Invalid phone number format.';
    }
    return null;
  }
}
