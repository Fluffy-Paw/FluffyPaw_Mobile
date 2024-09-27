import 'package:fluffypawmobile/domain/entities/account.dart';

class AccountModel extends Account {
  AccountModel({
    required String phone,
    required String userName,
    required String password,
    required String confirmPassword,
    required String email,
    required String fullName,
    required String address,
    DateTime? dob,
    required String gender,
    String? avatar
  }) : super(
    phone: phone,
    userName: userName,
    passWord: password,
    confirmPassword: confirmPassword,
    email: email,
    fullName: fullName,
    address: address,
    dob: dob,
    gender: gender,
    avatar: avatar
  );

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      phone: json['phone'] as String? ?? '',  // Use empty string if null
      userName: json['userName'] as String? ?? '',  // Handle null case
      password: json['password'] as String? ?? '',
      confirmPassword: json['comfirmPassword'] as String? ?? '',  // Handle typo or null case
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      address: json['address'] as String? ?? '',
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,  // Check for null date
      gender: json['gender'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'userName': userName,
      'password': passWord,
      'comfirmPassword': confirmPassword, // Note the typo in API
      'email': email,
      'fullName': fullName,
      'address': address,
      'dob': dob?.toIso8601String(),
      'gender': gender,
      'avatar': avatar,
    };
  }
}