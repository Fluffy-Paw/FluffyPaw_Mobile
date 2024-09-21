import 'package:fluffypawmobile/data/models/account_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> registerAccount(AccountModel accountModel);
}