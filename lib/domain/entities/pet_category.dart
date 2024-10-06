class PetCategory{
  int id;
  String name;

  PetCategory({required this.id, required this.name});
  factory PetCategory.fromJson(Map<String, dynamic> json) {
    return PetCategory(
      id: json['id'],
      name: json['name'],
    );
  }
}