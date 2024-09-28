import 'package:fluffypawmobile/domain/entities/pet.dart';

class PetModel extends Pet {
  final String? petCategory;
  final String? behaviorCategory;

  PetModel({
    required int id,
    required String name,
    String? image,
    String? sex,
    double? weight,
    this.petCategory,
    this.behaviorCategory,
    String? status,
    int? petOwnerId,
    int? petCategoryId,
    int? petTypeId,
    int? behaviorCategoryId,
    DateTime? dob,
    String? allergy,
    String? microchipNumber,
    required String description,
    bool? isNeuter,
  }) : super(
    id: id,
    name: name,
    image: image,
    sex: sex,
    weight: weight,
    status: status,
    petOwnerId: petOwnerId,
    petCategoryId: petCategoryId,
    petTypeId: petTypeId,
    behaviorCategoryId: behaviorCategoryId,
    dob: dob,
    allergy: allergy,
    microchipNumber: microchipNumber,
    description: description,
    isNeuter: isNeuter,
  );

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      sex: json['sex'],
      weight: json['weight']?.toDouble(),
      petCategory: json['petCategory'],
      behaviorCategory: json['behaviorCategory'],
      description: json['description'] ?? '',  // Assuming description is required
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'sex': sex,
      'weight': weight,
      'petCategory': petCategory,
      'behaviorCategory': behaviorCategory,
    };
  }
}