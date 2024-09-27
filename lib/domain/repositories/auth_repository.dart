import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/models/account_model.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/login_model.dart';
import 'package:fluffypawmobile/data/models/pet_owner_model.dart';
import 'package:fluffypawmobile/domain/entities/Account.dart';

abstract class AuthRepository {
  Future<Either<Failures, ApiResponse<AccountModel>>> register(Account account);
  Future<Either<Failures, ApiResponse<String>>> login (LoginModel loginModel);
}