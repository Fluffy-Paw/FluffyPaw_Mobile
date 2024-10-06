import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/auth_service.dart';
import 'package:fluffypawmobile/core/error/exceptions.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/datasources/abstract/pet_remote_data_source.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/pet_model.dart';
import 'package:fluffypawmobile/domain/entities/behavior_category.dart';
import 'package:fluffypawmobile/domain/entities/pet_category.dart';
import 'package:fluffypawmobile/domain/repositories/pet_repository.dart';

import '../../domain/entities/pet_type.dart';

class PetRepositoryImpl implements PetRepository{

  final PetRemoteDataSource petRemoteDataSource;
  final AuthService authService;

  PetRepositoryImpl({required this.petRemoteDataSource, required this.authService});

  @override
  Future<Either<Failures, ApiResponse<List<PetModel>>>> getPetList() async{
    try{
      final token = await authService.getToken();
      if (token == null) {
        return Left(GeneralFailure(message: 'Token not found'));
      }
      final pet = await petRemoteDataSource.getPetList(token);
      return Right(pet);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(message: '${e.toString()}'));
    }
  }

  @override
  Future<Either<Failures, ApiResponse<PetModel>>> getPetByID(int id) async{
    // TODO: implement getPetByID
    try{
      final token = await authService.getToken();
      if (token == null) {
        return Left(GeneralFailure(message: 'Token not found'));
      }
      final pet = await petRemoteDataSource.getPetByID(token, id);
      return Right(pet);
    }on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(message: '${e.toString()}'));
    }
  }
  @override
  Future<Either<Failures, ApiResponse<List<PetCategory>>>> getPetCategory() async {
    try {
      final token = await authService.getToken();
      if (token == null) {
        return Left(GeneralFailure(message: 'Token not found'));
      }
      final petCategory = await petRemoteDataSource.getPetCategory(token);
      return Right(petCategory);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(message: '${e.toString()}'));
    }
  }

  @override
  Future<Either<Failures, ApiResponse<List<PetType>>>> getPetType(int id) async {
    try {
      final token = await authService.getToken();
      if (token == null) {
        return Left(GeneralFailure(message: 'Token not found'));
      }
      final petType = await petRemoteDataSource.getPetType(token, id);
      return Right(petType);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(message: '${e.toString()}'));
    }
  }

  @override
  Future<Either<Failures, ApiResponse<List<BehaviorCategory>>>> getBehaviorCategory() async {
    try {
      final token = await authService.getToken();
      if (token == null) {
        return Left(GeneralFailure(message: 'Token not found'));
      }
      final behaviorCategory = await petRemoteDataSource.getBehaviorCategory(token);
      return Right(behaviorCategory);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(message: '${e.toString()}'));
    }
  }
  @override
  Future<Either<Failures, ApiResponse<bool>>> addPet(Map<String, dynamic> petData) async {
    try {
      final token = await authService.getToken();
      if (token == null) {
        return Left(GeneralFailure(message: 'Token not found'));
      }
      final result = await petRemoteDataSource.addPet(token, petData);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failures, ApiResponse<bool>>> updatePet(int id, Map<String, dynamic> petData) async{
    // TODO: implement updatePet
    try{
      final token = await authService.getToken();
      if(token == null){
        return Left(GeneralFailure(message: 'Token not found'));
      }
      final result = await petRemoteDataSource.updatePet(token, id, petData);
      return Right(result);
    } catch (e){
      return Left(ServerFailure(message: e.toString()));
    }
  }

}