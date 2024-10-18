import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/domain/repositories/service_repository.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';

class CreateBookingParams {
  final List<int> petIds; // Updated to a list of pet IDs
  final int storeServiceId;
  final String paymentMethod;
  final String description;

  CreateBookingParams({
    required this.petIds, // Update to petIds as a List<int>
    required this.storeServiceId,
    required this.paymentMethod,
    required this.description,
  });
}

class CreateBooking implements UseCase<void, CreateBookingParams> {
  final ServiceRepository repository;

  CreateBooking(this.repository);

  @override
  Future<Either<Failures, void>> call(CreateBookingParams params) async {
    return await repository.createBooking(
      petIds: params.petIds, // Pass the list of pet IDs
      storeServiceId: params.storeServiceId,
      paymentMethod: params.paymentMethod,
      description: params.description,
    );
  }
}
