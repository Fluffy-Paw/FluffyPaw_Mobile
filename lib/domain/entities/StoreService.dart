import 'package:fluffypawmobile/domain/entities/certificate.dart';

class StoreService {
  int id;
  int? serviceTypeId;
  int? brandId;
  String name;
  String image;
  String duration;
  int cost;
  String description;
  int bookingCount;
  int totalRating;
  bool status;
  String serviceTypeName;
  List<Certificate>? certificates;

  StoreService({
    required this.id,
    this.serviceTypeId,
    this.brandId,
    required this.name,
    required this.image,
    required this.duration,
    required this.cost,
    required this.description,
    required this.bookingCount,
    required this.totalRating,
    required this.status,
    required this.serviceTypeName,
    this.certificates,
  });


}