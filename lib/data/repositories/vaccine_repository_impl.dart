import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/auth_service.dart';
import 'package:fluffypawmobile/core/error/exceptions.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/datasources/abstract/vaccine_remote_data_source.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/vaccine_model.dart';
import 'package:fluffypawmobile/domain/repositories/vaccine_repository.dart';

class VaccineRepositoryImpl extends VaccineRepository{
  final VaccineRemoteDataSource vaccineRemoteDataSource;
  final AuthService authService;
  VaccineRepositoryImpl({required this.vaccineRemoteDataSource, required this.authService});
  @override
  Future<Either<Failures, ApiResponse<List<VaccineModel>>>> getPetVaccineHistory(int id) async{
    try{
      final token = await authService.getToken();
      if (token == null) {
        return Left(GeneralFailure(message: 'Token not found'));
      }
      final pet = await vaccineRemoteDataSource.getPetVaccineByID(token, id);
      return Right(pet);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(message: '${e.toString()}'));
    }
  }
  @override
  Future<Either<Failures, ApiResponse<bool>>> addVaccine(Map<String, dynamic> vaccineData) async {
    try {
      final token = await authService.getToken();
      if (token == null) {
        return Left(GeneralFailure(message: 'Token not found'));
      }
      final result = await vaccineRemoteDataSource.addVaccine(token, vaccineData);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(message: '${e.toString()}'));
    }
  }
  @override
  Future<Either<Failures, ApiResponse<bool>>> deleteVaccine(int id) async {
    try {
      final token = await authService.getToken();
      if (token == null) {
        return Left(GeneralFailure(message: 'Token not found'));
      }
      final result = await vaccineRemoteDataSource.deleteVaccine(token, id);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(message: '${e.toString()}'));
    }
  }
  @override
  Future<Either<Failures, ApiResponse<VaccineModel>>> getVaccineDetail(int id) async {
    try {
      final token = await authService.getToken();
      if (token == null) {
        return Left(GeneralFailure(message: 'Token not found'));
      }
      final result = await vaccineRemoteDataSource.getVaccineDetail(token, id);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(message: '${e.toString()}'));
    }
  }
  @override
  Future<Either<Failures, ApiResponse<bool>>> updateVaccine(int id, Map<String, dynamic> vaccineData) async {
    try {
      final token = await authService.getToken();
      if (token == null) {
        return Left(GeneralFailure(message: 'Token not found'));
      }
      final result = await vaccineRemoteDataSource.updateVaccine(token, id, vaccineData);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(message: '${e.toString()}'));
    }
  }
  
}