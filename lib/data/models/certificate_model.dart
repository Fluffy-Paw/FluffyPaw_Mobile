import 'package:fluffypawmobile/domain/entities/certificate.dart';

class CertificateModel extends Certificate {
  CertificateModel({
    required super.id,
    required super.name,
    required super.description,
    super.file,
  });

  // Factory method to parse JSON and create a CertificateModel object
  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      file: json['file'], // Nullable field (can be null or a string)
    );
  }
}
