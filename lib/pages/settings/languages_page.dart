import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/generated/l10n.dart';

class LanguagesPage extends StatefulWidget {
  const LanguagesPage({super.key});

  @override
  LanguagesPageState createState() => LanguagesPageState();
}

class LanguagesPageState extends State<LanguagesPage> {
  String? _selectedLanguageCode;

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference().then((languageCode) {
      setState(() {
        _selectedLanguageCode = languageCode;
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            MingCuteIcons.mgc_large_arrow_left_fill,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          S.current.languages_title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.bold,
            fontFamily: 'CustomFont',
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.secondary,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.r, horizontal: 30.r),
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/img_languages.png',
                  width: 120.r,
                  height: 120.r,
                ),
                40.verticalSpace,
                Text(
                  S.current.languages_description,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 22.r,
                    fontFamily: 'CustomFont',
                  ),
                  textAlign: TextAlign.center,
                ),
                40.verticalSpace,
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12.r,
                    mainAxisSpacing: 12.r,
                    children: [
                      _buildLanguageCard(
                          'en', 'English', 'assets/images/img_flag_eng.png'),
                      _buildLanguageCard(
                          'it', 'Italian', 'assets/images/img_flag_ita.png'),
                      _buildLanguageCard(
                          'es', 'Spanish', 'assets/images/img_flag_esp.png'),
                      _buildLanguageCard(
                          'fr', 'French', 'assets/images/img_flag_fra.png'),
                      _buildLanguageCard(
                          'de', 'German', 'assets/images/img_flag_deu.png'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard(
      String languageCode, String languageName, String flagAsset) {
    final isSelected = languageCode == _selectedLanguageCode;
    return GestureDetector(
      onTap: () {
        _saveLanguagePreference(languageCode);
      },
      child: Card(
        color: isSelected
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Theme.of(context).colorScheme.tertiary, width: 0.2),
          borderRadius: BorderRadius.circular(10.0.r),
        ),
        child: SizedBox(
          width: 120.r,
          height: 120.r,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                flagAsset,
                width: 60.r,
                height: 40.r,
              ),
              10.verticalSpace,
              Text(
                languageName,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 18.r,
                  fontFamily: 'CustomFont',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
