import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';
import 'package:fluffypawmobile/data/models/pet_model.dart';
import 'package:fluffypawmobile/domain/repositories/pet_repository.dart';


class PetInfoById implements UseCase<PetModel, int> {
  final PetRepository repository;

  PetInfoById(this.repository);

  @override
  Future<Either<Failures, PetModel>> call(int id) async {
    final result = await repository.getPetByID(id);

    return result.fold(
          (failure) => Left(failure),
          (response) {
        // Check if response.data is null and handle it
        if (response.data != null) {
          return Right(response.data!);
        } else {
          // Return a specific failure if the pet is not found (you can define a custom failure)
          return Left(NotFoundFailure());
        }
      },
    );
  }
}
