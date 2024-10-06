import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/domain/repositories/pet_repository.dart';

class UpdatePet implements UseCase<ApiResponse<bool>, Map<String, dynamic>> {
  final PetRepository repository;

  UpdatePet(this.repository);

  @override
  Future<Either<Failures, ApiResponse<bool>>> call(Map<String, dynamic> params) async {
    int id = params["id"];
    params.remove("id");
    return await repository.updatePet(id, params);
  }
}