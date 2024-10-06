import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/domain/entities/pet_category.dart';
import 'package:fluffypawmobile/domain/repositories/pet_repository.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';

class GetPetCategory implements UseCase<ApiResponse<List<PetCategory>>, NoParams> {
  final PetRepository repository;

  GetPetCategory(this.repository);

  @override
  Future<Either<Failures, ApiResponse<List<PetCategory>>>> call(NoParams params) async {
    return await repository.getPetCategory();
  }
}
