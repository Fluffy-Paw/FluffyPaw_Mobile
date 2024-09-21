import 'dart:convert';
import 'package:fluffypawmobile/core/error/exceptions.dart';
import 'package:fluffypawmobile/data/datasources/abstract/auth_remote_data_source.dart';
import 'package:fluffypawmobile/data/models/account_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDatasourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDatasourceImpl({required this.client});

  @override
  Future<void> registerAccount(AccountModel accountModel) async {
    try {
      final response = await client.post(
        Uri.parse('https://fluffypaw.azurewebsites.net/api/Authentication/RegisterPO'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(accountModel.toJson()),
      );

      if (response.statusCode == 200) {
        print('Registration successful');
        return;
      }

      // Attempt to parse the error response
      Map<String, dynamic> errorResponse;
      try {
        errorResponse = json.decode(response.body);
      } catch (e) {
        errorResponse = {'message': 'Unable to parse error response'};
      }

      final errorMessage = errorResponse['message'] ?? 'Unknown error occurred';
      final errorCode = response.statusCode;

      // Log the detailed error information
      print('API call failed:');
      print('Status code: $errorCode');
      print('Error message: $errorMessage');
      print('Full response body: ${response.body}');

      // If you want to throw an exception, you can still do so:
      // throw ServerException('Error $errorCode: $errorMessage');
    } catch (e) {
      // Log any exceptions that occur during the API call
      print('Exception occurred during API call:');
      print(e.toString());

      // If you want to rethrow the exception:
      // throw NetworkException('Network error: ${e.toString()}');
    }
  }
}