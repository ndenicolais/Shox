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
  String? _selectedLanguageCode;

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
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        dropdownColor: Theme.of(context).colorScheme.primary,
        value: _selectedLanguageCode,
        icon: const Icon(Icons.arrow_drop_down),
        borderRadius: BorderRadius.circular(15.r),
        items: _languages.map((lang) {
          return DropdownMenuItem<String>(
            value: lang.code,
            alignment: Alignment.center,
            child: Image.asset(lang.flagAsset, width: 32.w, height: 22.h),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            _saveLanguagePreference(value);
          }
        },
      ),
    );
  }
}

class _LanguageOption {
  final String code;
  final String flagAsset;
  const _LanguageOption(this.code, this.flagAsset);
}
