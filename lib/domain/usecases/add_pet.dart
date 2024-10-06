import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/domain/repositories/pet_repository.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';

class AddPet implements UseCase<ApiResponse<bool>, Map<String, dynamic>> {
  final PetRepository repository;

  AddPet(this.repository);

  @override
  Future<Either<Failures, ApiResponse<bool>>> call(Map<String, dynamic> params) async {
    return await repository.addPet(params);
  }
}
