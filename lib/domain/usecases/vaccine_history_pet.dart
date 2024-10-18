import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';
import 'package:fluffypawmobile/data/models/vaccine_model.dart';
import 'package:fluffypawmobile/domain/repositories/vaccine_repository.dart';

class VaccineHistoryPet implements UseCase<List<VaccineModel>, int>{
  final VaccineRepository repository;

  VaccineHistoryPet(this.repository);

  @override
  Future<Either<Failures, List<VaccineModel>>> call(int id) async{
    final result = await repository.getPetVaccineHistory(id);

    return result.fold(
          (failure) => Left(failure),
          (response) {
        // Check if response.data is null and handle it
        if (response.data != null) {
          return Right(response.data!);
        } else {
          // Return a specific failure if the pet is not found (you can define a custom failure)
          return Left(NotFoundFailure(message: response.message ?? 'No vaccine history found'));
        }
      },
    );

  }
  
}