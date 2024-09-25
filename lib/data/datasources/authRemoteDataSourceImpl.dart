import 'dart:convert';
import 'package:fluffypawmobile/core/auth_service.dart';
import 'package:fluffypawmobile/core/error/exceptions.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/core/utils/constants.dart';
import 'package:fluffypawmobile/data/datasources/abstract/auth_remote_data_source.dart';
import 'package:fluffypawmobile/data/models/account_model.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/login_model.dart';
import 'package:fluffypawmobile/domain/entities/Account.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDatasourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final AuthService authService;


  AuthRemoteDatasourceImpl({required this.client, required this.authService});

  @override
  Future<ApiResponse<AccountModel>> registerAccount(AccountModel accountModel) async {
    try {
      final response = await client.post(
        Uri.parse(baseUrl + '/Authentication/RegisterPO'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(accountModel.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody.containsKey('data') && responseBody['data'] is Map<String, dynamic>) {
          final accountData = AccountModel.fromJson(responseBody['data']);
          return ApiResponse<AccountModel>(
            statusCode: response.statusCode,
            message: responseBody['message'],
            data: accountData,
          );
        } else {
          return ApiResponse<AccountModel>(
            statusCode: response.statusCode,
            message: responseBody['message'] ?? 'No account data found',
            data: null,
          );
        }
      } else {
        // Handle error responses and throw exception with message from server
        final Map<String, dynamic> errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'] ?? 'An error occurred';
        throw ServerException(message: errorMessage); // Only pass the server error message
      }
    } on http.ClientException {
      throw NetworkException(message: 'Network error: Unable to connect to the server');
    } catch (e) {
      // Do not add extra "Unexpected error" to the message, just throw original message
      throw ServerException(message: e is ServerException ? e.message : 'An unexpected error occurred');
    }
  }




  @override
  Future<ApiResponse<String>> login(LoginModel loginModel) async {
    final response = await client.post(
      Uri.parse(baseUrl + '/Authentication/Login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(loginModel.toJson()),  // Gửi yêu cầu đăng nhập với loginModel
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      final String token = jsonResponse['data'];
      await authService.saveToken(token);


      // Trả về ApiResponse chứa token trong 'data'
      return ApiResponse<String>(
        statusCode: jsonResponse['statusCode'],
        message: jsonResponse['message'],
        data: jsonResponse['data'],  // 'data' là token dạng chuỗi
      );
    } else {
      final errorMessage = json.decode(response.body)['message'] ?? 'Unknown error occurred';
      print('Error message: $errorMessage');
      throw ServerException(message: errorMessage);
    }
  }


}