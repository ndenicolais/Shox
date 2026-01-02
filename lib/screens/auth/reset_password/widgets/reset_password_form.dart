import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/core/utils/validator.dart';
import 'package:shox/common/widgets/textfield_widget.dart';

class ResetPasswordForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final BuildContext context;
  final TextEditingController emailController;

  const ResetPasswordForm({
    super.key,
    required this.context,
    required this.formKey,
    required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFieldWidget(
            controller: emailController,
            labelText: AppLocalizations.of(context)!.reset_password_form_email,
            hintText:
                AppLocalizations.of(context)!.reset_password_form_email_field,
            prefixIcon: MingCuteIcons.mgc_mail_line,
            keyboardType: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.done,
            validator: (val) => val?.emailValidationError(context),
          ),
        ],
      ),
    );
  }
}
