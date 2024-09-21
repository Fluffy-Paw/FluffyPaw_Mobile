import 'package:fluffypawmobile/domain/entities/Account.dart';
import 'package:fluffypawmobile/domain/usecases/register_account.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupViewmodel extends StateNotifier<AsyncValue<void>> {
  final RegisterAccount _registerAccount;

  SignupViewmodel(this._registerAccount) : super(AsyncValue.data(null));

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
    state = AsyncValue.loading();
    final account = Account(
        phone: phone,
        userName: userName,
        passWord: passWord,
        confirmPassword: confirmPassword,
        email: email,
        fullName: fullName,
        address: address,
        dob: dob,
        gender: gender);
    final result = await _registerAccount(account);
    state = result.fold(
        (failure) => AsyncValue.error(failure, StackTrace.current),
        (_) => AsyncValue.data(null),
    );
  }
}
