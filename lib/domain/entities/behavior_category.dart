class BehaviorCategory{
  int id;
  String name;

  BehaviorCategory({required this.id, required this.name});
  factory BehaviorCategory.fromJson(Map<String, dynamic> json) {
    return BehaviorCategory(
      id: json['id'],
      name: json['name'],
    );
  }
}