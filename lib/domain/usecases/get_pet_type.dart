import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/domain/entities/pet_type.dart';
import 'package:fluffypawmobile/domain/repositories/pet_repository.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';

class GetPetType implements UseCase<ApiResponse<List<PetType>>, int> {
  final PetRepository repository;

  GetPetType(this.repository);

  @override
  Future<Either<Failures, ApiResponse<List<PetType>>>> call(int id) async {
    return await repository.getPetType(id);
  }
}
