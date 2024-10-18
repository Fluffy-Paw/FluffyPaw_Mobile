import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/domain/repositories/vaccine_repository.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';

class UpdateVaccine implements UseCase<ApiResponse<bool>, UpdateVaccineParams> {
  final VaccineRepository repository;

  UpdateVaccine(this.repository);

  @override
  Future<Either<Failures, ApiResponse<bool>>> call(UpdateVaccineParams params) async {
    return await repository.updateVaccine(params.id, params.vaccineData);
  }
}

class UpdateVaccineParams {
  final int id;
  final Map<String, dynamic> vaccineData;

  UpdateVaccineParams({required this.id, required this.vaccineData});
}
