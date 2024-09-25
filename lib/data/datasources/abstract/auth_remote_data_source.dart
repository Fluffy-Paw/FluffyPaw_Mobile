import 'package:fluffypawmobile/data/models/account_model.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/login_model.dart';
import 'package:fluffypawmobile/domain/entities/Account.dart';

abstract class AuthRemoteDataSource {
  Future<ApiResponse<AccountModel>> registerAccount(AccountModel accountModel);
  Future<ApiResponse<String>> login(LoginModel loginModel);
}