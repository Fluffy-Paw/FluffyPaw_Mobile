import 'package:fluffypawmobile/domain/entities/file.dart';

class Store{
  int id;
  int? accountId;
  int? brandId;
  String brandName;
  String name;
  String address;
  String phone;
  int? totalRating;
  bool? status;
  File? file;
  Store(
      {required this.id,
        this.accountId,
        this.brandId,
        required this.name,
        required this.brandName,
        required this.address,
        this.totalRating,
        required this.phone,
        this.status,
        this.file});
}