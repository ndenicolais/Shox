extension ExtString on String {
  String? get nameValidationError {
    if (isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  bool get isValidName {
    return nameValidationError == null;
  }

  String? get emailValidationError {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+$");
    String message = '';

    if (!emailRegExp.hasMatch(this)) {
      if (!contains('@')) {
        message += '\nMissing @ symbol';
      }

      if (!contains('.')) {
        message += '\nMissing . symbol';
      }
    }

    return message.isNotEmpty ? message : null;
  }

  bool get isValidEmail {
    return emailValidationError == null;
  }

  String? get passwordValidationError {
    final passwordRegExp = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[+!@#\><*~]).{8,}$');
    String message = '';

    if (!passwordRegExp.hasMatch(this)) {
      if (!RegExp(r'[A-Z]').hasMatch(this)) {
        message += '\nMissing uppercase letter';
      }

      if (!RegExp(r'[a-z]').hasMatch(this)) {
        message += '\nMissing lowercase letter';
      }

      if (!RegExp(r'\d').hasMatch(this)) {
        message += '\nMissing digit';
      }

      if (!RegExp(r'[+!@#\><*~]').hasMatch(this)) {
        message += '\nMissing special character';
      }

      if (length < 8) {
        message += '\nPassword should be at least 8 characters long.';
      }
    }

    return message.isNotEmpty ? message : null;
  }

  bool get isValidPassword {
    return passwordValidationError == null;
  }
}
