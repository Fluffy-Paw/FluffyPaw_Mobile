

import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/login_model.dart';
import 'package:fluffypawmobile/domain/usecases/login_account.dart';
import 'package:fluffypawmobile/presentation/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginViewmodel extends StateNotifier<AsyncValue<String?>> {
  final LoginAccount _loginAccount;

  LoginViewmodel(this._loginAccount) : super(const AsyncValue.data(null));

  Future<Either<Failures, ApiResponse<String>>> login(
      String username, String password,BuildContext context
      ) async {
    state = AsyncValue.loading();
    final loginModel = LoginModel(username: username, password: password);

    final result = await _loginAccount(loginModel);

    state = result.fold(
          (failure) => AsyncValue.error(failure, StackTrace.current),
          (apiResponse) {
        if (apiResponse.statusCode == 200) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => Home()),
          );
          return AsyncValue.data(apiResponse.message); // Token
        } else {
          return AsyncValue.error(apiResponse.message, StackTrace.current);
        }
      },
    );

    return result;
  }
}