import 'package:fluffypawmobile/domain/entities/behavior_category.dart';
import 'package:fluffypawmobile/domain/entities/pet.dart';
import 'package:fluffypawmobile/domain/entities/pet_type.dart';

class PetModel extends Pet {
  PetModel({
    required int id,
    required String name,
    String? image,
    String? sex,
    double? weight,
    DateTime? dob,
    int? age,
    String? allergy,
    String? microchipNumber,
    String? description,
    bool? isNeuter,
    PetType? petType,
    dynamic behaviorCategory,
  }) : super(
          id: id,
          name: name,
          image: image,
          sex: sex,
          weight: weight,
          age: age,
          dob: dob,
          allergy: allergy,
          microchipNumber: microchipNumber,
          description: description ?? '',
          isNeuter: isNeuter,
          petType: petType,
          // Handle both cases for behaviorCategory
          behaviorCategory: behaviorCategory is String
              ? BehaviorCategory(
                  id: 0,
                  name:
                      behaviorCategory) // Assign a default id of 0 for the string case
              : behaviorCategory
                  as BehaviorCategory, // Ensure it is BehaviorCategory in other cases
        );

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      sex: json['sex'],
      weight: json['weight']?.toDouble(),
      description: json['description'] ?? '',
      // Assuming description is required
      microchipNumber: json['microchipNumber'],
      allergy: json['allergy'],
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      petType:
          json['petType'] != null ? PetType.fromJson(json['petType']) : null,
      // Handle both the case where behaviorCategory is an object or a string
      behaviorCategory: json['behaviorCategory'] is Map<String, dynamic>
          ? BehaviorCategory.fromJson(json['behaviorCategory'])
          : json['behaviorCategory'] is String
              ? json['behaviorCategory'] // Handle as string
              : null,
    );
  }
}
