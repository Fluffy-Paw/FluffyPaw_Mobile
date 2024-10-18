class ServiceType{
  int id;
  String name;
  ServiceType({required this.id, required this.name});
  factory ServiceType.fromJson(Map<String, dynamic> json) {
    return ServiceType(
        id: json['id'],
        name: json['name'],
    );
  }
}