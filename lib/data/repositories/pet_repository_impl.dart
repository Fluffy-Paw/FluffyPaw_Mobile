import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/auth_service.dart';
import 'package:fluffypawmobile/core/error/exceptions.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/datasources/abstract/pet_remote_data_source.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/pet_model.dart';
import 'package:fluffypawmobile/domain/repositories/pet_repository.dart';

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

}