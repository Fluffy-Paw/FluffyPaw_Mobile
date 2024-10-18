import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/vaccine_model.dart';

abstract class VaccineRepository{
  Future<Either<Failures,ApiResponse<List<VaccineModel>>>>getPetVaccineHistory(int id);
  Future<Either<Failures, ApiResponse<bool>>> addVaccine(Map<String, dynamic> vaccineData);
  Future<Either<Failures, ApiResponse<bool>>> deleteVaccine(int id);
  Future<Either<Failures, ApiResponse<VaccineModel>>> getVaccineDetail(int id);
  Future<Either<Failures, ApiResponse<bool>>> updateVaccine(int id, Map<String, dynamic> vaccineData);
}