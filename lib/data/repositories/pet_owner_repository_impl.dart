import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/auth_service.dart';
import 'package:fluffypawmobile/core/error/exceptions.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/datasources/abstract/user_remote_data_source.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/pet_owner_model.dart';
import 'package:fluffypawmobile/domain/repositories/pet_owner_repository.dart';

class PetOwnerRepositoryImpl implements PetOwnerRepository {
  final UserRemoteDataSource userRemoteDataSource;
  final AuthService authService;

  PetOwnerRepositoryImpl({required this.userRemoteDataSource, required this.authService});

  @override
  Future<Either<Failures, ApiResponse<PetOwner>>> getPetOwnerInfo() async{
    try{
      final token = await authService.getToken();
      if (token == null) {
        return Left(GeneralFailure(message: 'Token not found'));
      }
      final petOwner = await userRemoteDataSource.getPetOwnerInfo(token);
      return Right(petOwner);

    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(message: '${e.toString()}'));
    }
  }

}