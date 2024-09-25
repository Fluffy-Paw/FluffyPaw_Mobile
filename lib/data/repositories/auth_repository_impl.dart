import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/auth_service.dart';
import 'package:fluffypawmobile/core/error/exceptions.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/datasources/abstract/auth_remote_data_source.dart';
import 'package:fluffypawmobile/data/models/account_model.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/login_model.dart';
import 'package:fluffypawmobile/domain/entities/Account.dart';
import 'package:fluffypawmobile/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthService authService;

  AuthRepositoryImpl({required this.remoteDataSource,required this.authService});

  @override
  Future<Either<Failures, ApiResponse<AccountModel>>> register(Account account) async {
    try {
      final accountModel = AccountModel(
        phone: account.phone,
        userName: account.userName,
        password: account.passWord,
        confirmPassword: account.confirmPassword,
        email: account.email ?? '', // Provide a default empty string if null
        fullName: account.fullName,
        address: account.address ?? '', // Provide a default empty string if null
        dob: account.dob,
        gender: account.gender ?? '', // Provide a default empty string if null
      );
      final apiResponse = await remoteDataSource.registerAccount(accountModel);

      return Right(apiResponse);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      // Catching any other unexpected exceptions
      return Left(ServerFailure(message: '${e.toString()}'));
    }
  }


  @override
  Future<Either<Failures, ApiResponse<String>>> login(LoginModel loginModel) async{
    // TODO: implement login
    try{
      final apiResponse = await remoteDataSource.login(loginModel);
      final String? token = apiResponse.data;
      if (token != null) {
        await authService.saveToken(token);  // Lưu token
        authService.getToken();
      }
      return Right(apiResponse);

    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }
}