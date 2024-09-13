import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/services/shoes_service.dart';
import 'package:shox/theme/app_colors.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage>
    with TickerProviderStateMixin {
  final ShoesService shoesService = ShoesService();
  late AnimationController _loadingController;

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
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
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.r, horizontal: 30.r),
          child: Column(
            children: [
              Image.asset(
                'assets/images/img_history.png',
                width: 120.r,
                height: 120.r,
              ),
              40.verticalSpace,
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(shoesService.getCurrentUserId())
                      .collection('history')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: AnimatedBuilder(
                          animation: _loadingController,
                          builder: (_, child) {
                            return Transform.rotate(
                              angle: _loadingController.value * 2.0 * 3.14159,
                              child: child,
                            );
                          },
                          child: Icon(
                            MingCuteIcons.mgc_shoe_fill,
                            size: 50.r,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              MingCuteIcons.mgc_package_line,
                              size: 80.r,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            Text(
                              S.current.history_empty,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 20.r,
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
                          final entry = historyEntries[index].data()
                              as Map<String, dynamic>;
                          final timestamp = entry['timestamp'] as Timestamp;
                          final formattedTimestamp = formatTimestamp(timestamp);
                          final imageUrl = entry['imageUrl'] as String? ?? '';
                          final operationType =
                              entry['operationType'] as String;

                          String localizedOperationType;
                          switch (operationType) {
                            case 'Added':
                              localizedOperationType = S.current.history_added;
                              break;
                            case 'Updated':
                              localizedOperationType =
                                  S.current.history_updated;
                              break;
                            case 'Deleted':
                              localizedOperationType =
                                  S.current.history_deleted;
                              break;
                            default:
                              localizedOperationType = 'Unknown';
                          }

                          return ListTile(
                            leading: SizedBox(
                              width: 50,
                              height: 50,
                              child: imageUrl.isNotEmpty
                                  ? Image.network(
                                      imageUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                          MingCuteIcons.mgc_close_fill,
                                          size: 50,
                                          color: AppColors.errorColor,
                                        );
                                      },
                                    )
                                  : const Icon(
                                      MingCuteIcons.mgc_close_fill,
                                      size: 50,
                                      color: AppColors.errorColor,
                                    ),
                            ),
                            title: Text(
                              localizedOperationType,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 18.r,
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
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    fontSize: 16.r,
                                    fontFamily: 'CustomFont',
                                  ),
                                ),
                                Text(
                                  'ID: ${entry['shoesId']}',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    fontSize: 16.r,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
