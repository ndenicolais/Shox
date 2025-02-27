import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  LanguageScreenState createState() => LanguageScreenState();
}

class LanguageScreenState extends State<LanguageScreen> {
  String? _selectedLanguageCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.r),
          child: Center(
            child: Column(
              spacing: 40.h,
              children: [
                _buildTopImage(context),
                _buildDescription(context),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 3.r,
                    mainAxisSpacing: 3.r,
                    children: [
                      _buildLanguageCard(
                          'en',
                          AppLocalizations.of(context)!.language_screen_english,
                          'assets/images/img_flag_eng.png'),
                      _buildLanguageCard(
                          'it',
                          AppLocalizations.of(context)!.language_screen_italian,
                          'assets/images/img_flag_ita.png'),
                      _buildLanguageCard(
                          'es',
                          AppLocalizations.of(context)!.language_screen_spanish,
                          'assets/images/img_flag_esp.png'),
                      _buildLanguageCard(
                          'fr',
                          AppLocalizations.of(context)!.language_screen_french,
                          'assets/images/img_flag_fra.png'),
                      _buildLanguageCard(
                          'de',
                          AppLocalizations.of(context)!.language_screen_german,
                          'assets/images/img_flag_deu.png'),
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

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
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
        AppLocalizations.of(context)!.language_screen_title,
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.secondary,
    );
  }

  Widget _buildTopImage(BuildContext context) {
    return Image.asset(
      'assets/images/img_languages.png',
      width: 120.w,
      height: 120.h,
    );
  }

  Widget _buildDescription(BuildContext context) {
    return SizedBox(
      width: 280.w,
      child: Text(
        AppLocalizations.of(context)!.language_screen_description,
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.tertiary,
          fontSize: 22.sp,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLanguageCard(
    String languageCode,
    String languageName,
    String flagAsset,
  ) {
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
            color: Theme.of(context).colorScheme.tertiary,
            width: 0.5.w,
          ),
          borderRadius: BorderRadius.circular(10.0.r),
        ),
        child: SizedBox(
          width: 120.w,
          height: 120.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                flagAsset,
                width: 60.w,
                height: 40.h,
              ),
              SizedBox(height: 10.h),
              Text(
                languageName,
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
