import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/core/utils/constants.dart';
import 'package:shox/theme/app_font_sizes.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
          title: AppLocalizations.of(context)!.support_screen_title),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                _buildContactSection(
                  context,
                  title: AppLocalizations.of(context)!
                      .support_screen_contacts_text,
                  description: AppLocalizations.of(context)!
                      .support_screen_contacts_decription,
                  contactInfo: AppLocalizations.of(context)!
                      .support_screen_contacts_info,
                  icon: MingCuteIcons.mgc_mail_send_line,
                  onTap: () => _launchEmail(),
                ),
                SizedBox(height: 20.h),
                _buildFaqSection(context),
                SizedBox(height: 20.h),
                _buildContactSection(
                  context,
                  title: AppLocalizations.of(context)!
                      .support_screen_documentation_text,
                  description: AppLocalizations.of(context)!
                      .support_screen_documentation_decription,
                  contactInfo: AppLocalizations.of(context)!
                      .support_screen_documentation_info,
                  icon: MingCuteIcons.mgc_book_6_line,
                  onTap: () => _launchDocumentation(),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactSection(
    BuildContext context, {
    required String title,
    required String description,
    required String contactInfo,
    required IconData icon,
    required Function onTap,
  }) {
    return InkWell(
      onTap: () => onTap(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.secondary,
                size: 30.sp,
              ),
              SizedBox(width: 10.w),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: AppFontSizes.regular,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            description,
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: AppFontSizes.small,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            contactInfo,
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: AppFontSizes.normal,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              MingCuteIcons.mgc_question_line,
              color: Theme.of(context).colorScheme.secondary,
              size: 30.sp,
            ),
            SizedBox(width: 10.w),
            Text(
              AppLocalizations.of(context)!.support_screen_faq_text,
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: AppFontSizes.regular,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Text(
          AppLocalizations.of(context)!.support_screen_faq_decription,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: AppFontSizes.small,
          ),
        ),
        SizedBox(height: 10.h),
        ExpansionTileWidget(
          title: AppLocalizations.of(context)!.support_screen_faq_q1,
          answer: AppLocalizations.of(context)!.support_screen_faq_a1,
        ),
        ExpansionTileWidget(
          title: AppLocalizations.of(context)!.support_screen_faq_q2,
          answer: AppLocalizations.of(context)!.support_screen_faq_a2,
        ),
        ExpansionTileWidget(
          title: AppLocalizations.of(context)!.support_screen_faq_q3,
          answer: AppLocalizations.of(context)!.support_screen_faq_a3,
        ),
        ExpansionTileWidget(
          title: AppLocalizations.of(context)!.support_screen_faq_q4,
          answer: AppLocalizations.of(context)!.support_screen_faq_a4,
        ),
        ExpansionTileWidget(
          title: AppLocalizations.of(context)!.support_screen_faq_q8,
          answer: AppLocalizations.of(context)!.support_screen_faq_a8,
        ),
        ExpansionTileWidget(
          title: AppLocalizations.of(context)!.support_screen_faq_q9,
          answer: AppLocalizations.of(context)!.support_screen_faq_a9,
        ),
        ExpansionTileWidget(
          title: AppLocalizations.of(context)!.support_screen_faq_q10,
          answer: AppLocalizations.of(context)!.support_screen_faq_a10,
        ),
        ExpansionTileWidget(
          title: AppLocalizations.of(context)!.support_screen_faq_q11,
          answer: AppLocalizations.of(context)!.support_screen_faq_a11,
        ),
      ],
    );
  }

  Future<void> _launchEmail() async {
    if (await launchUrlString(AppConstants.uriMail.toString())) {
      return;
    } else {
      throw 'Impossible to open email client';
    }
  }

  Future<void> _launchDocumentation() async {
    if (await launchUrlString(AppConstants.uriGithubDocumentation.toString())) {
      return;
    } else {
      throw 'Impossible to open documentation.';
    }
  }
}

class ExpansionTileWidget extends StatefulWidget {
  final String title;
  final String answer;
  final IconData iconClosed;
  final IconData iconOpened;

  const ExpansionTileWidget({
    super.key,
    required this.title,
    required this.answer,
    this.iconClosed = MingCuteIcons.mgc_down_line,
    this.iconOpened = MingCuteIcons.mgc_up_line,
  });

  @override
  ExpansionTileWidgetState createState() => ExpansionTileWidgetState();
}

class ExpansionTileWidgetState extends State<ExpansionTileWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.title,
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.tertiary,
          fontSize: AppFontSizes.normal,
        ),
      ),
      trailing: Icon(
        isExpanded ? widget.iconOpened : widget.iconClosed,
        color: isExpanded
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.tertiary,
        size: 24.sp,
      ),
      onExpansionChanged: (bool expanded) {
        setState(() {
          isExpanded = expanded;
        });
      },
      children: [
        Padding(
          padding: EdgeInsets.all(12.r),
          child: Text(
            widget.answer,
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: AppFontSizes.small,
            ),
          ),
        ),
      ],
    );
  }
}
