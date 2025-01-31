import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/generated/l10n.dart';
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
  late AnimationController _loadingController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(30.r),
          child: Column(
            children: [
              _buildBodyPage(context),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
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
        S.current.history_title,
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

  Widget _buildLoadingIndicator() {
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
            return _buildLoadingIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
                    S.current.history_empty,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 20.sp,
                      fontFamily: 'CustomFont',
                    ),
                  ),
                ],
              ),
            );
          } else {
            final historyEntries = snapshot.data!.docs;
            return ListView.builder(
              itemCount: historyEntries.length,
              itemBuilder: (context, index) {
                final entry =
                    historyEntries[index].data() as Map<String, dynamic>;
                final timestamp = entry['timestamp'] as Timestamp;
                final formattedTimestamp = formatTimestamp(timestamp);
                final imageUrl = entry['imageUrl'] as String? ?? '';
                final operationType = entry['operationType'] as String;

                String localizedOperationType;
                switch (operationType) {
                  case 'Added':
                    localizedOperationType = S.current.history_added;
                    break;
                  case 'Updated':
                    localizedOperationType = S.current.history_updated;
                    break;
                  case 'Deleted':
                    localizedOperationType = S.current.history_deleted;
                    break;
                  default:
                    localizedOperationType = 'Unknown';
                }

                return ListTile(
                  leading: SizedBox(
                    width: 50.w,
                    height: 50.h,
                    child: imageUrl.isNotEmpty
                        ? Card(
                            color: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            elevation: 0,
                            clipBehavior: Clip.antiAlias,
                            child: Image.network(
                              imageUrl,
                              width: 50.w,
                              height: 50.h,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  MingCuteIcons.mgc_close_fill,
                                  size: 50.sp,
                                  color: AppColors.errorColor,
                                );
                              },
                            ),
                          )
                        : Icon(
                            MingCuteIcons.mgc_close_fill,
                            size: 50.sp,
                            color: AppColors.errorColor,
                          ),
                  ),
                  title: Text(
                    localizedOperationType,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'CustomFont',
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedTimestamp,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 16.sp,
                          fontFamily: 'CustomFont',
                        ),
                      ),
                      Text(
                        '${entry['shoesId']}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 16.sp,
                          fontFamily: 'CustomFont',
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
