import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/button_widget.dart';
import 'package:shox/common/widgets/delete_dialog_widget.dart';
import 'package:shox/common/widgets/empty_state_widget.dart';
import 'package:shox/common/widgets/error_state_widget.dart';
import 'package:shox/common/widgets/toast_widget.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_font_sizes.dart';
import 'package:shox/theme/app_theme.dart';

/// Phone-sized surface (the ScreenUtil design size) with the OS text size
/// set to the maximum the app allows. German has the longest labels.
Future<void> pumpAtMaxTextScale(
  WidgetTester tester,
  Widget Function(BuildContext context) builder,
) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) => MaterialApp(
        theme: AppTheme.lightTheme(),
        locale: const Locale('de'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler:
                  const TextScaler.linear(AppFontSizes.maxTextScaleFactor),
            ),
            child: Scaffold(body: Builder(builder: builder)),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('wide button fits its label', (tester) async {
    await pumpAtMaxTextScale(
      tester,
      (context) => Center(
        child: ButtonWidget(
          width: 280.w,
          height: 60.h,
          text: AppLocalizations.of(context)!.welcome_signup,
          fontSize: AppFontSizes.large,
          onPressed: () {},
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('compact icon button fits its label', (tester) async {
    await pumpAtMaxTextScale(
      tester,
      (context) => Center(
        child: ButtonWidget(
          width: 120.w,
          height: 50.h,
          text: AppLocalizations.of(context)!.user_updater_screen_save,
          fontSize: AppFontSizes.regular,
          icon: MingCuteIcons.mgc_save_2_line,
          iconSize: 18.sp,
          onPressed: () {},
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('error state with retry does not overflow', (tester) async {
    await pumpAtMaxTextScale(
      tester,
      (context) => ErrorStateWidget(
        message: AppLocalizations.of(context)!.home_screen_error_state,
        onRetry: () {},
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('empty state with action does not overflow', (tester) async {
    await pumpAtMaxTextScale(
      tester,
      (context) => EmptyStateWidget(
        message: AppLocalizations.of(context)!.home_screen_no_results_state,
        icon: MingCuteIcons.mgc_search_2_line,
        actionLabel: AppLocalizations.of(context)!.home_screen_no_results_reset,
        onAction: () {},
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('confirmation dialog does not overflow', (tester) async {
    await pumpAtMaxTextScale(
      tester,
      (context) => DeleteDialogWidget(
        title: AppLocalizations.of(context)!.shoes_form_screen_unsaved_title,
        content: AppLocalizations.of(context)!.shoes_form_screen_unsaved_text,
        cancelLabel:
            AppLocalizations.of(context)!.shoes_form_screen_unsaved_stay,
        confirmLabel:
            AppLocalizations.of(context)!.shoes_form_screen_unsaved_leave,
        onCancelPressed: () {},
        onConfirmPressed: () {},
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('toast does not overflow', (tester) async {
    await pumpAtMaxTextScale(
      tester,
      (context) => Stack(
        children: [
          ToastWidget(
            title: AppLocalizations.of(context)!.session_expired_message,
            titleColor: Colors.black,
            icon: MingCuteIcons.mgc_warning_line,
            iconColor: Colors.black,
            backgroundColor: Colors.white,
            borderColor: Colors.black,
            onClose: () {},
          ),
        ],
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
