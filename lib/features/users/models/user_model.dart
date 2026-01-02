import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userEmail;
  final String userName;
  final String? userImage;
  final String? gender;
  final DateTime userDate;

  UserModel({
    required this.userEmail,
    required this.userName,
    this.userImage,
    this.gender,
    DateTime? userDate,
  }) : userDate = userDate ?? DateTime.now();

  Map<String, dynamic> toFirestore() {
    return {
      'userEmail': userEmail,
      'userName': userName,
      'userImage': userImage,
      'gender': gender,
      'userDate': Timestamp.fromDate(userDate),
    };
  }

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      userEmail: data['userEmail'],
      userName: data['userName'],
      userImage: data['userImage'],
      gender: data['gender'],
      userDate: (data['userDate'] as Timestamp).toDate(),
    );
  }

  UserModel copyWith({
    String? userEmail,
    String? userName,
    String? userImage,
    String? gender,
    DateTime? userDate,
  }) {
    return UserModel(
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      userImage: userImage ?? this.userImage,
      gender: gender ?? this.gender,
      userDate: userDate ?? this.userDate,
    );
  }

  static const String genderMale = 'male';
  static const String genderFemale = 'female';
  static const String genderOther = 'other';
}
