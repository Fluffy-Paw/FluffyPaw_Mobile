import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';
import 'package:fluffypawmobile/data/models/account_model.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/domain/entities/Account.dart';
import 'package:fluffypawmobile/domain/repositories/auth_repository.dart';

class RegisterAccount implements UseCase<void, Account>{
  final AuthRepository authRepository;

  RegisterAccount(this.authRepository);

  @override
  Future<Either<Failures, ApiResponse<AccountModel>>> call(Account account) async {
    // TODO: implement call
    return await authRepository.register(account);
  }
}