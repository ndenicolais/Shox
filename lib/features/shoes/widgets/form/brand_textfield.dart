import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/features/shoes/widgets/form/form_field_card.dart';

class BrandTextField extends StatelessWidget {
  final TextEditingController controller;

  const BrandTextField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return FormFieldCard(
      icon: MingCuteIcons.mgc_tag_line,
      label: AppLocalizations.of(context)!.shoes_adder_screen_field_brand,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText:
              AppLocalizations.of(context)!.shoes_adder_screen_field_brand,
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 2,
            ),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 2,
            ),
          ),
        ),
        style: TextStyle(
          fontFamily: 'CustomFont',
          color: Theme.of(context).colorScheme.secondary,
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        textCapitalization: TextCapitalization.sentences,
        validator: (val) => val!.isEmpty
            ? AppLocalizations.of(context)!.shoes_adder_screen_toast_error_brand
            : null,
      ),
    );
  }
}
