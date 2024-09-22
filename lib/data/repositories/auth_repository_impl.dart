import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/exceptions.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/datasources/abstract/auth_remote_data_source.dart';
import 'package:fluffypawmobile/data/models/account_model.dart';
import 'package:fluffypawmobile/domain/entities/Account.dart';
import 'package:fluffypawmobile/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failures, Account>> register(Account account) async {
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
      await remoteDataSource.registerAccount(accountModel);
      //print(account);
      return Right(account);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }
}