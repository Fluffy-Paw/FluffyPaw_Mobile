import 'package:equatable/equatable.dart';

class Account{
  final String phone;
  final String userName;
  final String passWord;
  final String confirmPassword;
  final String? email;
  final String fullName;
  final String? address;
  final DateTime? dob;
  final String? gender;
  final String? avatar;

  const Account({
    required this.phone,
    required this.userName,
    required this.passWord,
    required this.confirmPassword,
    this.email,
    required this.fullName,
    this.address,
    this.dob,
    this.gender,
    this.avatar
  });


}