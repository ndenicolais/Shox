import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageDropdown extends StatefulWidget {
  const LanguageDropdown({super.key});

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  String _selectedLanguageCode = 'en';

  final List<_LanguageOption> _languages = const [
    _LanguageOption('en', 'assets/images/img_flag_eng.png'),
    _LanguageOption('it', 'assets/images/img_flag_ita.png'),
    _LanguageOption('es', 'assets/images/img_flag_esp.png'),
    _LanguageOption('fr', 'assets/images/img_flag_fra.png'),
    _LanguageOption('de', 'assets/images/img_flag_deu.png'),
  ];

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference().then((languageCode) {
      setState(() {
        if (languageCode.isNotEmpty) {
          _selectedLanguageCode = languageCode;
        } else {
          final deviceLocale = Get.deviceLocale?.languageCode ?? 'en';
          final isSupported =
              _languages.any((lang) => lang.code == deviceLocale);
          _selectedLanguageCode = isSupported ? deviceLocale : 'en';
        }
      });
    });
  }

  Future<void> _saveLanguagePreference(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    setState(() {
      _selectedLanguageCode = languageCode;
    });
    Get.updateLocale(Locale(languageCode));
  }

  Future<String> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('language_code') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<String>(
      segments: _languages
          .map(
            (lang) => ButtonSegment(
              value: lang.code,
              icon: ClipRRect(
                borderRadius: BorderRadius.circular(2.r),
                child: Image.asset(
                  lang.flagAsset,
                  width: 24.w,
                  height: 16.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
          .toList(),
      selected: {_selectedLanguageCode},
      showSelectedIcon: false,
      onSelectionChanged: (selection) {
        _saveLanguagePreference(selection.first);
      },
    );
  }
}

class _LanguageOption {
  final String code;
  final String flagAsset;
  const _LanguageOption(this.code, this.flagAsset);
}
