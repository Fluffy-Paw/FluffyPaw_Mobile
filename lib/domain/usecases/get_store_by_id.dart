import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';
import 'package:fluffypawmobile/data/models/store_model.dart';
import 'package:fluffypawmobile/domain/repositories/service_repository.dart';

class GetStoreByID implements UseCase<StoreModel, int> {
  final ServiceRepository serviceRepository;

  GetStoreByID(this.serviceRepository);

  @override
  Future<Either<Failures, StoreModel>> call(int id) async {
    final result = await serviceRepository.getStoreByID(id);
    return result.fold(
          (failure) => Left(failure),
          (apiResponse) => Right(apiResponse.data!),
    );
  }
}

class Params {
  final int id;

  Params({required this.id});
}
