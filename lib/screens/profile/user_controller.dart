import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final userName = 'User'.obs;

  @override
  void onInit() {
    super.onInit();
    _listenToUserNameChanges();
  }

  void _listenToUserNameChanges() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    if (user.providerData.isNotEmpty &&
        user.providerData[0].providerId == 'google.com') {
      String? googleUserName = user.displayName;
      userName.value = googleUserName?.split(" ").first ?? 'User';
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen((userSnapshot) {
        if (userSnapshot.exists) {
          userName.value = (userSnapshot.data())?['userName'] ?? 'User';
        } else {
          userName.value = 'User';
        }
      });
    }
  }
}
