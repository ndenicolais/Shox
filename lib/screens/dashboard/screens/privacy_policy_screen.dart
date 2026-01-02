import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/core/utils/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            _applyThemeToWebView();
          },
        ),
      )
      ..loadRequest(
        AppConstants.uriPrivacyPolicy,
      );
  }

  void _applyThemeToWebView() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? '#FFFFFF' : '#000000';

    _controller.runJavaScript('''
      document.body.style.backgroundColor = 'transparent';
      document.documentElement.style.backgroundColor = 'transparent';
      document.body.style.color = '$textColor';

      // Apply text color to all elements
      var allElements = document.getElementsByTagName('*');
      for (var i = 0; i < allElements.length; i++) {
        allElements[i].style.color = '$textColor';
      }
    ''');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
          title: AppLocalizations.of(context)!.policy_screen_title),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10.r),
          child: Center(
            child: Column(
              children: [
                _buildBody(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Expanded(
      child: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
