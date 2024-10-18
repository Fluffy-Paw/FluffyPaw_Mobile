
import 'package:fluffypawmobile/domain/entities/vaccine.dart';

class VaccineModel extends Vaccine {
  VaccineModel(
      {required super.id, super.petId,
      required super.name,
      required super.image,
       super.petCurrentWeight,
      required super.vaccineDate,
       super.nextVaccineDate,
      required super.description, super.status,
      });
  factory VaccineModel.fromJson(Map<String, dynamic> json) {
      return VaccineModel(
          id: json['id'] as int? ?? 1,
          petId: json['petId'] as int?,
          name: json['name'] as String,
          image: json['image'] as String,
          vaccineDate:  DateTime.parse(json['vaccineDate']),
          nextVaccineDate: json['nextVaccineDate'] != null ? DateTime.parse(json['nextVaccineDate']): null,
          description: json['description'],
          status: json['status'],
        petCurrentWeight: json['petCurrentWeight']





      );
  }
}
