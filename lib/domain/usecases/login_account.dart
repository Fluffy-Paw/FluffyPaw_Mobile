import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/login_model.dart';
import 'package:fluffypawmobile/domain/repositories/auth_repository.dart';

import '../entities/Account.dart';

class LoginAccount {
  final AuthRepository authRepository;
  LoginAccount(this.authRepository);
  Future<Either<Failures, ApiResponse<String>>> call (LoginModel loginModel) async {
    return await authRepository.login(loginModel);
  }
}