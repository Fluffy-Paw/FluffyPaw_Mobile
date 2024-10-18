import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/domain/repositories/vaccine_repository.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';

class DeleteVaccine implements UseCase<ApiResponse<bool>, int> {
  final VaccineRepository repository;

  DeleteVaccine(this.repository);

  @override
  Future<Either<Failures, ApiResponse<bool>>> call(int id) async {
    return await repository.deleteVaccine(id);
  }
}
