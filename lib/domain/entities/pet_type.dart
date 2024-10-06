import 'package:fluffypawmobile/domain/entities/pet_category.dart';

class PetType{
  int id;
  String name;
  //String image;
  PetCategory petCategory;

  PetType({required this.id, required this.name, required this.petCategory});
  factory PetType.fromJson(Map<String, dynamic> json) {
    return PetType(
      id: json['id'],
      name: json['name'],
      //image: json['image'],
        petCategory: PetCategory.fromJson(json['petCategory'])
    );
  }
}