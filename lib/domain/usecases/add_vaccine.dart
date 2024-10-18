import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/domain/repositories/vaccine_repository.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';

class AddVaccine implements UseCase<ApiResponse<bool>, Map<String, dynamic>> {
  final VaccineRepository repository;

  AddVaccine(this.repository);

  @override
  Future<Either<Failures, ApiResponse<bool>>> call(Map<String, dynamic> params) async {
    return await repository.addVaccine(params);
  }
}
