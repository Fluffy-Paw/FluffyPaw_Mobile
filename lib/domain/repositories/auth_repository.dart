import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/domain/entities/Account.dart';

abstract class AuthRepository {
  Future<Either<Failures, Account>> register (Account account);
}