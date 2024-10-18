import 'package:fluffypawmobile/domain/entities/service.dart';

class ServiceModel extends Service {
    ServiceModel({
        required super.id,
        required super.storeId,
        required super.serviceId,
        required super.startTime,
        required super.limitPetOwner,
        required super.currentPetOwner,
        required super.status,
    });

    // Phương thức hỗ trợ từ JSON
    factory ServiceModel.fromJson(Map<String, dynamic> json) {
        return ServiceModel(
            id: json['id'],
            storeId: json['storeId'],
            serviceId: json['serviceId'],
            startTime: DateTime.parse(json['startTime']),
            limitPetOwner: json['limitPetOwner'],
            currentPetOwner: json['currentPetOwner'],
            status: json['status'],
        );
    }

    // Chuyển đổi đối tượng thành JSON
    Map<String, dynamic> toJson() {
        return {
            'id': id,
            'storeId': storeId,
            'serviceId': serviceId,
            'startTime': startTime.toIso8601String(),
            'limitPetOwner': limitPetOwner,
            'currentPetOwner': currentPetOwner,
            'status': status,
        };
    }
}
