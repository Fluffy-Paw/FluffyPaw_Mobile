import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/domain/entities/Account.dart';
import 'package:fluffypawmobile/domain/usecases/register_account.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupViewmodel extends StateNotifier<AsyncValue<ApiResponse>> {
  final RegisterAccount _registerAccount;

  SignupViewmodel(this._registerAccount)
      : super( AsyncValue.data(ApiResponse<Account>(
    statusCode: 0,
    message: '',
    data: null,
  )));

  Future<void> register(
      String phone,
      String userName,
      String passWord,
      String confirmPassword,
      String? email,
      String fullName,
      String? address,
      DateTime? dob,
      String? gender,
      ) async {
    state = const AsyncValue.loading();
    final account = Account(
      phone: phone,
      userName: userName,
      passWord: passWord,
      confirmPassword: confirmPassword,
      email: email,
      fullName: fullName,
      address: address,
      dob: dob,
      gender: gender,
    );

    final result = await _registerAccount(account);
    result.fold(
          (failure) => print('Error: $failure'),
          (apiResponse) => print('Success: ${apiResponse.message}'),
    );

    state = result.fold(
          (failure) => AsyncValue.error(failure, StackTrace.current),
          (apiResponse) => AsyncValue.data(apiResponse),
    );
  }
}