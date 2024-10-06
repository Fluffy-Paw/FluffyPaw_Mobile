import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/domain/entities/behavior_category.dart';
import 'package:fluffypawmobile/domain/repositories/pet_repository.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';

class GetBehaviorCategory implements UseCase<ApiResponse<List<BehaviorCategory>>, NoParams> {
  final PetRepository repository;

  GetBehaviorCategory(this.repository);

  @override
  Future<Either<Failures, ApiResponse<List<BehaviorCategory>>>> call(NoParams params) async {
    return await repository.getBehaviorCategory();
  }
}
