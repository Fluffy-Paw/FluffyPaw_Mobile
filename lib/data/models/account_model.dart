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
  );

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      phone: json['phone'] as String,
      userName: json['userName'] as String,
      password: json['password'] as String,
      confirmPassword: json['comfirmPassword'] as String, // Note the typo in API
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      address: json['address'] as String,
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      gender: json['gender'] as String,
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
    };
  }
}