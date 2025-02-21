import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/services/shoes_service.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/widgets/custom_loader.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen>
    with TickerProviderStateMixin {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final ShoesService shoesService = ShoesService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(30.r),
          child: Column(
            children: [_buildBodyPage(context)],
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
        AppLocalizations.of(context)!.history_title,
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.secondary,
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Center(
      child: CustomLoader(
        width: 50.w,
        height: 50.h,
      ),
    );
  }

  Widget _buildBodyPage(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .collection('history')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingIndicator(context);
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyHistory(context);
          } else {
            return _buildHistoryList(context, snapshot.data!.docs);
          }
        },
      ),
    );
  }

  Widget _buildEmptyHistory(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            MingCuteIcons.mgc_package_line,
            size: 80.sp,
            color: Theme.of(context).colorScheme.secondary,
          ),
          Text(
            AppLocalizations.of(context)!.history_empty,
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 20.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(
    BuildContext context,
    List<QueryDocumentSnapshot> historyEntries,
  ) {
    return ListView.builder(
      itemCount: historyEntries.length,
      itemBuilder: (context, index) {
        final entry = historyEntries[index].data() as Map<String, dynamic>;
        final timestamp = entry['timestamp'] as Timestamp;
        final formattedTimestamp = formatTimestamp(timestamp);
        final imageUrl = entry['imageUrl'] as String? ?? '';
        final operationType = entry['operationType'] as String;
        final localizedOperationType =
            _getLocalizedOperationType(operationType);

        return ListTile(
          leading: _buildLeadingImage(context, imageUrl),
          title: Text(
            localizedOperationType,
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formattedTimestamp,
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 16.sp,
                ),
              ),
              Text(
                '${entry['shoesId']}',
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLeadingImage(BuildContext context, String imageUrl) {
    if (imageUrl.isNotEmpty) {
      return Card(
        color: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.r),
        ),
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: 50.w,
          height: 50.h,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              Center(child: _buildLoadingIndicator(context)),
          errorWidget: (context, url, error) => Icon(
            MingCuteIcons.mgc_close_fill,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      );
    } else {
      return Icon(
        MingCuteIcons.mgc_close_fill,
        size: 50.sp,
        color: AppColors.errorColor,
      );
    }
  }

  String _getLocalizedOperationType(String operationType) {
    switch (operationType) {
      case 'Added':
        return AppLocalizations.of(context)!.history_added;
      case 'Updated':
        return AppLocalizations.of(context)!.history_updated;
      case 'Deleted':
        return AppLocalizations.of(context)!.history_deleted;
      default:
        return 'Unknown';
    }
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }
}
