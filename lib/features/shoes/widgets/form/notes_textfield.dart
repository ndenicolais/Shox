import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/features/shoes/widgets/form/form_field_card.dart';

class NotesTextField extends StatelessWidget {
  final TextEditingController controller;

  const NotesTextField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return FormFieldCard(
      icon: MingCuteIcons.mgc_document_line,
      label: AppLocalizations.of(context)!.shoes_adder_screen_field_note,
      child: TextFormField(
        controller: controller,
        minLines: 3,
        maxLines: 6,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }
}
