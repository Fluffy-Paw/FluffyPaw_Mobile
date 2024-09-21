import 'package:fluffypawmobile/data/datasources/abstract/auth_remote_data_source.dart';
import 'package:fluffypawmobile/data/datasources/authRemoteDataSourceImpl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/register_account.dart';

final httpClientProvider = Provider<http.Client>((ref) => http.Client());

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDatasourceImpl(client: ref.read(httpClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(remoteDataSource: ref.read(authRemoteDataSourceProvider));
});

final registerAccountProvider = Provider<RegisterAccount>((ref) {
  return RegisterAccount(ref.read(authRepositoryProvider));
});