

import 'package:fluffypawmobile/core/auth_service.dart';
import 'package:fluffypawmobile/data/datasources/abstract/auth_remote_data_source.dart';
import 'package:fluffypawmobile/data/datasources/authRemoteDataSourceImpl.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/repositories/auth_repository_impl.dart';
import 'package:fluffypawmobile/domain/repositories/auth_repository.dart';
import 'package:fluffypawmobile/domain/usecases/login_account.dart';
import 'package:fluffypawmobile/domain/usecases/register_account.dart';
import 'package:fluffypawmobile/presentation/viewmodels/login_viewmodel.dart';
import 'package:fluffypawmobile/presentation/viewmodels/signup_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../domain/entities/account.dart';

final httpClientProvider = Provider.autoDispose<http.Client>((ref) => http.Client());
final authServiceProvider = Provider.autoDispose<AuthService>((ref) {
  return AuthService();
});
final authRemoteDataSourceProvider = Provider.autoDispose<AuthRemoteDataSource>((ref) {
  return AuthRemoteDatasourceImpl(client: ref.read(httpClientProvider), authService: ref.read(authServiceProvider));
});



final authRepositoryProvider = Provider.autoDispose<AuthRepository>((ref) {
  return AuthRepositoryImpl(remoteDataSource: ref.read(authRemoteDataSourceProvider), authService: ref.read(authServiceProvider),);
});

final registerAccountProvider = Provider.autoDispose<RegisterAccount>((ref) {
  return RegisterAccount(ref.read(authRepositoryProvider));
});

final signupViewModelProvider = StateNotifierProvider.autoDispose<SignupViewmodel, AsyncValue<ApiResponse>>((ref) {
  return SignupViewmodel(ref.read(registerAccountProvider));
});

final loginAccountProvider = Provider.autoDispose<LoginAccount>((ref){
  return LoginAccount(ref.read(authRepositoryProvider));
});
final loginViewModelProvider = StateNotifierProvider.autoDispose<LoginViewmodel, AsyncValue<String?>>((ref) {
  final loginAccount = ref.read(loginAccountProvider);
  return LoginViewmodel(loginAccount);
});

