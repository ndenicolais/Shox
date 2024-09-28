import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/generated/l10n.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  InfoPageState createState() => InfoPageState();
}

class InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.r, horizontal: 40.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTopImage(),
              80.verticalSpace,
              _buildDescription(context),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
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
        S.current.info_title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
          fontWeight: FontWeight.bold,
          fontFamily: 'CustomFont',
        ),
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.secondary,
    );
  }

  Widget _buildTopImage() {
    return Image.asset(
      'assets/images/app_logo.png',
      width: 120.r,
      height: 120.r,
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      S.current.info_description,
      style: TextStyle(
        color: Theme.of(context).colorScheme.tertiary,
        fontSize: 22.r,
        fontFamily: 'CustomFont',
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          '${S.current.info_version} 2.3.0',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 14.r,
            fontFamily: 'CustomFont',
          ),
        ),
      ),
    );
  }
}
