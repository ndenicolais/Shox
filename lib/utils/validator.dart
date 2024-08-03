import 'package:shox/generated/l10n.dart';

extension ExtString on String {
  String? get nameValidationError {
    final localizations = S.current;
    String message = '';
    if (trim() == '') {
      return message += '\n${localizations.validator_name_empty}';
    }
    return message.isNotEmpty ? message : null;
  }

  bool get isValidName {
    return nameValidationError == null;
  }

  String? get emailValidationError {
    final localizations = S.current;
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+$");
    String message = '';

    if (!emailRegExp.hasMatch(this)) {
      if (!contains('@')) {
        message += '\n${localizations.validator_email_missing_special}';
      }

      if (!contains('.')) {
        message += '\n${localizations.validator_email_missing_dot}';
      }
    }

    return message.isNotEmpty ? message : null;
  }

  bool get isValidEmail {
    return emailValidationError == null;
  }

  String? get passwordValidationError {
    final localizations = S.current;
    final passwordRegExp = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[+!@#\><*~]).{8,}$');
    String message = '';

    if (!passwordRegExp.hasMatch(this)) {
      if (!RegExp(r'[A-Z]').hasMatch(this)) {
        message += '\n${localizations.validator_password_missing_upper}';
      }

      if (!RegExp(r'[a-z]').hasMatch(this)) {
        message += '\n${localizations.validator_password_missing_lower}';
      }

      if (!RegExp(r'\d').hasMatch(this)) {
        message += '\n${localizations.validator_password_missing_digit}';
      }

      if (!RegExp(r'[+!@#\><*~]').hasMatch(this)) {
        message += '\n${localizations.validator_password_missing_special}';
      }

      if (length < 8) {
        message += '\n${localizations.validator_password_missing_lenght}';
      }
    }

    return message.isNotEmpty ? message : null;
  }

  bool get isValidPassword {
    return passwordValidationError == null;
  }
}
