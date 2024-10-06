import 'package:fluffypawmobile/domain/entities/behavior_category.dart';
import 'package:fluffypawmobile/domain/entities/pet_type.dart';

class Pet {
  final int id;
  final int? petOwnerId;
  final int? petCategoryId;
  final int? petTypeId;
  final int? behaviorCategoryId;
  final String name;
  final String? image;
  final String? sex;
  final double? weight;
  final DateTime? dob;
  final String? allergy;
  final String? microchipNumber;
  final String? description;
  final bool? isNeuter;
  final String? status;
  final int? age;
  final PetType? petType;
  final BehaviorCategory? behaviorCategory;

  // Constructor
  Pet({
    required this.id,
    this.petOwnerId,
    this.petCategoryId,
    this.petTypeId,
    this.behaviorCategoryId,
    required this.name,
    this.image,
    this.sex,
    this.weight,
    this.dob,
    this.allergy,
    this.microchipNumber,
    required this.description,
    this.isNeuter,
    this.status,
    this.age,
    this.petType,
    this.behaviorCategory
  });
}
