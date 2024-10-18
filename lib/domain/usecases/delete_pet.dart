import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/domain/repositories/pet_repository.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';

class DeletePet implements UseCase<ApiResponse<bool>, int> {
  final PetRepository repository;

  DeletePet(this.repository);

  @override
  Future<Either<Failures, ApiResponse<bool>>> call(int id) async {
    return await repository.deletePet(id);
  }
}
