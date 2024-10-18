class Service{
  final int id;
  final int storeId;
  final int serviceId;
  final DateTime startTime;
  final int limitPetOwner;
  final int currentPetOwner;
  final String status;
  Service({
    required this.id,
    required this.storeId,
    required this.serviceId,
    required this.startTime,
    required this.limitPetOwner,
    required this.currentPetOwner,
    required this.status,
  });
}