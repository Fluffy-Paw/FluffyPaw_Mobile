import 'dart:convert';
import 'package:fluffypawmobile/core/error/exceptions.dart';
import 'package:fluffypawmobile/core/utils/constants.dart';
import 'package:fluffypawmobile/data/datasources/abstract/pet_remote_data_source.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/pet_model.dart';
import 'package:http/http.dart' as http;

class PetRemoteDataSourceImpl implements PetRemoteDataSource {
  final http.Client client;

  PetRemoteDataSourceImpl({required this.client});

  @override
  Future<ApiResponse<List<PetModel>>> getPetList(String token) async {
    try {
      if (token.isEmpty) {
        throw UnauthorizedException(message: "Token is not available");
      }

      final response = await client.get(
        Uri.parse(baseUrl + "/Pet/GetAllPets"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body) as Map<String, dynamic>;
        return ApiResponse<List<PetModel>>.fromJson(
          decodedResponse,
              (json) => (json as List<dynamic>)
              .map((petJson) => PetModel.fromJson(petJson as Map<String, dynamic>))
              .toList(),
        );
      } else {
        print("ERROR: Failed to fetch pet list with status code: ${response.statusCode}");
        throw ServerException(message: 'Failed to fetch pet list');
      }
    } on http.ClientException {
      throw NetworkException(message: 'Network error occurred');
    } catch (e) {
      throw ServerException(message: e is ServerException ? e.message : 'An unexpected error occurred');
    }
  }
}