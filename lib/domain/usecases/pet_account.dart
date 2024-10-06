import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/pet_model.dart';
import 'package:fluffypawmobile/domain/repositories/pet_repository.dart';

class PetAccount implements UseCase<List<PetModel>, NoParams>{
  final PetRepository petRepository;
  PetAccount(this.petRepository);
  @override
  Future<Either<Failures, List<PetModel>>> call(NoParams params) async {
    final result = await petRepository.getPetList();
    return result.fold(
          (failure) => Left(failure),
          (apiResponse) => Right(apiResponse.data ?? []),
    );
  }

  //Future<Either<Failures,ApiResponse<PetModel>>> call
}