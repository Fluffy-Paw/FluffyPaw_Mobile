import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/vaccine_model.dart';
import 'package:fluffypawmobile/domain/repositories/vaccine_repository.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';

class GetVaccineDetail implements UseCase<ApiResponse<VaccineModel>, int> {
  final VaccineRepository repository;

  GetVaccineDetail(this.repository);

  @override
  Future<Either<Failures, ApiResponse<VaccineModel>>> call(int id) async {
    return await repository.getVaccineDetail(id);
  }
}
