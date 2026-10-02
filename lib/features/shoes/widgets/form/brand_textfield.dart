import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/features/shoes/models/brand_suggestions.dart';
import 'package:shox/features/shoes/widgets/form/form_field_card.dart';

/// Brand field that suggests brands already used in the collection.
class BrandTextField extends StatefulWidget {
  final TextEditingController controller;
  final BrandSuggestions suggestions;

  const BrandTextField({
    super.key,
    required this.controller,
    this.suggestions = const BrandSuggestions([]),
  });

  @override
  State<BrandTextField> createState() => _BrandTextFieldState();
}

class _BrandTextFieldState extends State<BrandTextField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FormFieldCard(
      icon: MingCuteIcons.mgc_tag_line,
      label: l10n.shoes_adder_screen_field_brand,
      child: LayoutBuilder(
        builder: (context, constraints) => RawAutocomplete<String>(
          textEditingController: widget.controller,
          focusNode: _focusNode,
          optionsBuilder: (value) => widget.suggestions.match(value.text),
          fieldViewBuilder: (context, controller, focusNode, onSubmitted) =>
              TextFormField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: l10n.shoes_adder_screen_field_brand,
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
            validator: (val) =>
                val!.isEmpty ? l10n.shoes_adder_screen_toast_error_brand : null,
          ),
          optionsViewBuilder: (context, onSelected, options) => _BrandOptions(
            width: constraints.maxWidth,
            options: options,
            onSelected: onSelected,
          ),
        ),
      ),
    );
  }
}

class _BrandOptions extends StatelessWidget {
  final double width;
  final Iterable<String> options;
  final AutocompleteOnSelected<String> onSelected;

  const _BrandOptions({
    required this.width,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4,
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width, maxHeight: 240),
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              for (final brand in options)
                ListTile(
                  dense: true,
                  leading: Icon(
                    MingCuteIcons.mgc_history_line,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  title: Text(brand, style: theme.textTheme.bodyMedium),
                  onTap: () => onSelected(brand),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
