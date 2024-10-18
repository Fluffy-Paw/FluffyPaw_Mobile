import 'package:fluffypawmobile/domain/entities/service_type.dart';

class ServiceTypeModel extends ServiceType {
  ServiceTypeModel({required int id, required String name})
      : super(id: id, name: name);

  factory ServiceTypeModel.fromJson(Map<String, dynamic> json) {
    return ServiceTypeModel(
        id: json['id'] as int? ?? 1, name: json['name'] as String? ?? '');
  }
}
