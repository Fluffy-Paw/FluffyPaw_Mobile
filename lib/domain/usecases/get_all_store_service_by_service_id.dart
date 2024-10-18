import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';
import 'package:fluffypawmobile/data/models/service_model.dart';
import 'package:fluffypawmobile/domain/repositories/service_repository.dart';

class GetAllStoreServiceByServiceId implements UseCase<List<ServiceModel>, int> {
  final ServiceRepository repository;

  GetAllStoreServiceByServiceId(this.repository);

  @override
  Future<Either<Failures, List<ServiceModel>>> call(int id) async {
    final result = await repository.getAllStoreServiceByServiceId(id);

    return result.fold(
          (failure) => Left(failure),
          (response) {
        // Check if response.data is null and handle it
        if (response.data != null) {
          return Right(response.data!);
        } else {
          // Return a specific failure if no services found
          return Left(NotFoundFailure());
        }
      },
    );
  }
}