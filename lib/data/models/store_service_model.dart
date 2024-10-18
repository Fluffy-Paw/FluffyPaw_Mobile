
import '../../domain/entities/StoreService.dart';
import 'certificate_model.dart'; // Import the CertificateModel class

class StoreServiceModel extends StoreService {
    StoreServiceModel({
        required super.id,
        required super.serviceTypeId,
        required super.brandId,
        required super.name,
        required super.image,
        required super.duration,
        required super.cost,
        required super.description,
        required super.bookingCount,
        required super.totalRating,
        required super.status,
        required super.serviceTypeName,
        required super.certificates,
    });

    // Factory constructor to create a StoreServiceModel object from JSON
    factory StoreServiceModel.fromJson(Map<String, dynamic> json) {
        return StoreServiceModel(
            id: json['id'],
            serviceTypeId: json['serviceTypeId'],
            brandId: json['brandId'],
            name: json['name'],
            image: json['image'],
            duration: json['duration'],
            cost: json['cost'],
            description: json['description'],
            bookingCount: json['bookingCount'],
            totalRating: json['totalRating'],
            status: json['status'],
            serviceTypeName: json['serviceTypeName'],
            certificates: json['certificate'] != null
                ? (json['certificate'] as List)
                .map((e) => CertificateModel.fromJson(e))
                .toList()
                : null, // Use CertificateModel to parse the certificate list
        );
    }
}
