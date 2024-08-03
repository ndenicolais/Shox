import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  ContactsPageState createState() => ContactsPageState();
}

class ContactsPageState extends State<ContactsPage> {
  final Uri uriLinkedin =
      Uri.parse('https://it.linkedin.com/in/nicoladenicolais');
  final Uri uriGithub = Uri.parse('https://github.com/ndenicolais');
  final Uri uriWeb = Uri.parse('https://ndenicolais.github.io/');

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
          S.current.support_title,
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
                  'assets/images/img_support.png',
                  width: 120.r,
                  height: 120.r,
                ),
                40.verticalSpace,
                Text(
                  S.current.support_developer,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 36.r,
                    fontFamily: 'CustomFont',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset(
                  'assets/images/img_ndn21.png',
                  width: 200.r,
                  height: 200.r,
                  fit: BoxFit.contain,
                ),
                20.verticalSpace,
                Text(
                  S.current.support_contacts,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 36.r,
                    fontFamily: 'CustomFont',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                20.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await launchUrl(uriLinkedin);
                      },
                      child: Image.asset(
                        'assets/images/img_linkedin.png',
                        width: 100.r,
                        height: 100.r,
                        fit: BoxFit.contain,
                      ),
                    ),
                    10.horizontalSpace,
                    GestureDetector(
                      onTap: () async {
                        await launchUrl(uriGithub);
                      },
                      child: Image.asset(
                        'assets/images/img_github.png',
                        width: 100.r,
                        height: 100.r,
                        fit: BoxFit.contain,
                      ),
                    ),
                    10.horizontalSpace,
                    GestureDetector(
                      onTap: () async {
                        await launchUrl(uriWeb);
                      },
                      child: Image.asset(
                        'assets/images/img_web.png',
                        width: 100.r,
                        height: 100.r,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
