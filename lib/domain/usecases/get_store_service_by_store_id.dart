import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';
import 'package:fluffypawmobile/data/models/store_service_model.dart';
import 'package:fluffypawmobile/domain/repositories/service_repository.dart';

class GetStoreServiceByStoreID implements UseCase<List<StoreServiceModel>, int> {
  final ServiceRepository serviceRepository;

  GetStoreServiceByStoreID(this.serviceRepository);

  @override
  Future<Either<Failures, List<StoreServiceModel>>> call(int id) async {
    final result = await serviceRepository.getStoreServiceByStoreID(id);

    return result.fold(
          (failure) => Left(failure),
          (apiResponse) {
        if (apiResponse.data == null) {
          // Handle case when data is null (e.g., 404 Not Found)
          return Left(NotFoundFailure(message: apiResponse.message ?? 'No services found for this store.'));
        } else {
          return Right(apiResponse.data!);
        }
      },
    );
  }
}
