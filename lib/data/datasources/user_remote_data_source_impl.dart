import 'dart:convert';

import 'package:fluffypawmobile/core/auth_service.dart';
import 'package:fluffypawmobile/core/error/exceptions.dart';
import 'package:fluffypawmobile/core/utils/constants.dart';
import 'package:fluffypawmobile/data/datasources/abstract/user_remote_data_source.dart';
import 'package:fluffypawmobile/data/models/account_model.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/pet_owner_model.dart';
import 'package:fluffypawmobile/domain/entities/account.dart';
import 'package:http/http.dart' as http;

class UserRemoteDataSourceImpl implements UserRemoteDataSource{
  final http.Client client;

  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<ApiResponse<PetOwner>> getPetOwnerInfo(String token) async{
    try{
      if(token == null) {
        throw UnauthorizedException(message: "Token is not available");
      }

      final response = await client.get(
        Uri.parse(baseUrl + "/PetOwner/GetPetOwnerDetail"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization' : 'Bearer $token',
      },
      );
      print("INFO: Response body: ${response.body}");
      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body) as Map<String, dynamic>;
        return ApiResponse<PetOwner>.fromJson(
            decodedResponse,
            (json) => PetOwner.fromJson(json as Map<String, dynamic>),
        );
      } else {
        print("ERROR: Failed to fetch pet owner info with status code: ${response.statusCode}");
        throw ServerException(message: 'Failed to fetch pet owner info');
      }
      
    } on http.ClientException {
      throw NetworkException(message: '');
    } catch (e){
      throw ServerException(message: e is ServerException ? e.message: '');
    }
  }

}