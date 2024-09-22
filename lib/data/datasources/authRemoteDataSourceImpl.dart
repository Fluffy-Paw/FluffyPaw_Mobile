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

      // Throw ServerException for all non-200 responses
      throw ServerException(message: ' $errorMessage');
    } on http.ClientException {
      // Catch specific network-related exceptions
      throw NetworkException(message: 'Network error: Unable to connect to the server');
    } catch (e) {
      // For any other unexpected errors, rethrow as ServerException
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }
}