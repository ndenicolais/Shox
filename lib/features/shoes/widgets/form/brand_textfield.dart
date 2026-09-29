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
    final l10n = AppLocalizations.of(context)!;
    return FormFieldCard(
      icon: MingCuteIcons.mgc_tag_line,
      label: l10n.shoes_adder_screen_field_brand,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: l10n.shoes_adder_screen_field_brand,
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        textCapitalization: TextCapitalization.sentences,
        validator: (val) =>
            val!.isEmpty ? l10n.shoes_adder_screen_toast_error_brand : null,
      ),
    );
  }
}
