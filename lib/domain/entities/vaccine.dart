import 'package:fluffypawmobile/domain/entities/pet.dart';

class Vaccine {
  final int id;
  final int? petId;
  final String name;
  final String image;
  final int? petCurrentWeight;
  final DateTime vaccineDate;
  final DateTime? nextVaccineDate;
  final String description;
  final String? status;
  final Pet? pet;

  Vaccine(
      {required this.id,
        this.petId,
      required this.name,
      required this.image,
      this.petCurrentWeight,
      required this.vaccineDate,
      this.nextVaccineDate,
      required this.description,
      this.status,
      this.pet});
}
