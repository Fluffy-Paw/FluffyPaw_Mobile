import 'package:fluffypawmobile/data/models/account_model.dart';
import 'package:fluffypawmobile/domain/entities/Account.dart';

class PetOwner {
  final String fullName;
  final String gender;
  final DateTime dob;
  final String phone;
  final String email;
  final String address;
  final String avatar;



  PetOwner({
    required this.fullName,
    required this.gender,
    required this.dob,
    required this.phone,
    required this.email,
    required this.avatar,
    required this.address

  });

  factory PetOwner.fromJson(Map<String, dynamic> json) {
    return PetOwner(
      fullName: json['fullName'],
      gender: json['gender'],
      dob: DateTime.parse(json['dob']),
      phone: json['phone'],
        email: json['email'],
      avatar: json['avatar'],
      address: json['address']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'gender': gender,
      'dob': dob,
      'phone': phone,
      'address': address,
      'email' : email,
      'avatar' : avatar,


    };
  }
}
