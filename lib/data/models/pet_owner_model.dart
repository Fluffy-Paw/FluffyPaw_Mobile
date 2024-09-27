import 'package:fluffypawmobile/data/models/account_model.dart';
import 'package:fluffypawmobile/domain/entities/Account.dart';

class PetOwner {
  final int id;
  final int accountId;
  final String fullName;
  final String gender;
  final DateTime dob;
  final String phone;
  final String address;
  final String status;
  final AccountModel accountModel;

  PetOwner({
    required this.id,
    required this.accountId,
    required this.fullName,
    required this.gender,
    required this.dob,
    required this.phone,
    required this.address,
    required this.status,
    required this.accountModel,
  });

  factory PetOwner.fromJson(Map<String, dynamic> json) {
    return PetOwner(
      id: json['id'],
      accountId: json['accountId'],
      fullName: json['fullName'],
      gender: json['gender'],
      dob: DateTime.parse(json['dob']),
      phone: json['phone'],
      address: json['address'],
      status: json['status'],
      accountModel: AccountModel.fromJson(json['account']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accountId': accountId,
      'fullName': fullName,
      'gender': gender,
      'dob': dob,
      'phone': phone,
      'address': address,
      'status': status,
      'account': accountModel.toJson(),
    };
  }
}
