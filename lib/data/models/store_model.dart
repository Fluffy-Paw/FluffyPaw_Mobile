import 'package:fluffypawmobile/domain/entities/file.dart';
import 'package:fluffypawmobile/domain/entities/store.dart';

class StoreModel extends Store {
  StoreModel(
      {required super.id,
      required super.name,
      required super.brandName,
      required super.address,
      required super.phone,
        super.totalRating,
        super.status,
      super.file});
  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
        id: json['id'] as int? ?? 1,
        brandName: json['brandName'] as String,
        name: json['name'] as String,
        file: (json['files'] != null && (json['files'] as List).isNotEmpty)
            ? File.fromJson(json['files'][0] as Map<String, dynamic>) // Lấy đối tượng File đầu tiên
            : File.initial(),
        address:  json['address'] as String,
        phone: json['phone'] as String,
        totalRating: json['totalRating'] as int,
        status: json['status'] as bool





    );
  }
  factory StoreModel.initial() {
    return StoreModel(
      id: 0,
      brandName: '',
      name: '',
      address: '',
      phone: '',
      totalRating: 0,
      status: true,
      file: File.initial(),
    );
  }
}
