import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';
import 'package:fluffypawmobile/data/models/store_model.dart';
import 'package:fluffypawmobile/domain/repositories/service_repository.dart';


class GetStoreList implements UseCase<List<StoreModel>, NoParams> {
  final ServiceRepository repository;

  GetStoreList(this.repository);

  @override
  Future<Either<Failures, List<StoreModel>>> call(NoParams params) async {
    final result = await repository.getStoreList();

    return result.fold(
          (failure) => Left(failure),
          (response) {
        // Check if response.data is null and handle it
        if (response.data != null) {
          return Right(response.data!);
        } else {
          // Return a specific failure if the store list is not found (custom failure can be defined)
          return Left(NotFoundFailure());
        }
      },
    );
  }
}
