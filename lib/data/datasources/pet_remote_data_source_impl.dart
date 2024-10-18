import 'dart:convert';
import 'package:fluffypawmobile/core/error/exceptions.dart';
import 'package:fluffypawmobile/core/utils/constants.dart';
import 'package:fluffypawmobile/data/datasources/abstract/pet_remote_data_source.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/pet_model.dart';
import 'package:fluffypawmobile/domain/entities/behavior_category.dart';
import 'package:fluffypawmobile/domain/entities/pet_category.dart';
import 'package:fluffypawmobile/domain/entities/pet_type.dart';
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

  @override
  Future<ApiResponse<PetModel>> getPetByID(String token, int id) async{
    // TODO: implement getPetByID
    try{
      if (token.isEmpty) {
        throw UnauthorizedException(message: "Token is not available");
      }
      final response = await client.get(
        Uri.parse(baseUrl + "/Pet/GetPet/${id}"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if(response.statusCode == 200){
        final decodeResponse = json.decode(response.body) as Map<String, dynamic>;
        return ApiResponse<PetModel>.fromJson(
          decodeResponse,
            (json) => PetModel.fromJson(json as Map<String, dynamic>),
        );

      }else{
        throw ServerException(message: 'Failed to fetch pet owner info');
      }
    }on http.ClientException {
      throw NetworkException(message: 'Network error occurred');
    } catch (e) {
      throw ServerException(message: e is ServerException ? e.message : 'An unexpected error occurred');
    }
  }
  @override
  Future<ApiResponse<List<PetCategory>>> getPetCategory(String token) async {
    try {
      if (token.isEmpty) {
        throw UnauthorizedException(message: "Token is not available");
      }

      final response = await client.get(
        Uri.parse(baseUrl + "/Pet/GetAllPetCategory"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body) as Map<String, dynamic>;

        // Check if 'data' exists and is not null
        final data = decodedResponse['data'] as List<dynamic>? ?? [];

        return ApiResponse<List<PetCategory>>.fromJson(
          decodedResponse,
              (json) => data
              .map((categoryJson) => PetCategory.fromJson(categoryJson as Map<String, dynamic>))
              .toList(),
        );
      } else {
        throw ServerException(message: 'Failed to fetch pet categories');
      }
    } catch (e) {
      throw ServerException(message: 'An unexpected error occurred');
    }
  }


  @override
  Future<ApiResponse<List<PetType>>> getPetType(String token, int id) async {
    try {
      if (token.isEmpty) {
        throw UnauthorizedException(message: "Token is not available");
      }

      final response = await client.get(
        Uri.parse(baseUrl + "/Pet/GetAllPetTypeByPetCategory/${id}"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body) as Map<String, dynamic>;

        // Check if 'data' exists and is not null
        final data = decodedResponse['data'] as List<dynamic>? ?? [];

        return ApiResponse<List<PetType>>.fromJson(
          decodedResponse,
              (json) => data
              .map((typeJson) => PetType.fromJson(typeJson as Map<String, dynamic>))
              .toList(),
        );
      } else {
        throw ServerException(message: 'Failed to fetch pet types');
      }
    } catch (e) {
      throw ServerException(message: 'An unexpected error occurred');
    }
  }


  @override
  Future<ApiResponse<List<BehaviorCategory>>> getBehaviorCategory(String token) async {
    try {
      if (token.isEmpty) {
        throw UnauthorizedException(message: "Token is not available");
      }

      final response = await client.get(
        Uri.parse(baseUrl + "/Pet/GetAllBehavior"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body) as Map<String, dynamic>;

        // Check if 'data' exists and is not null
        final data = decodedResponse['data'] as List<dynamic>? ?? [];

        return ApiResponse<List<BehaviorCategory>>.fromJson(
          decodedResponse,
              (json) => data
              .map((behaviorJson) => BehaviorCategory.fromJson(behaviorJson as Map<String, dynamic>))
              .toList(),
        );
      } else {
        throw ServerException(message: 'Failed to fetch behavior categories');
      }
    } catch (e) {
      throw ServerException(message: 'An unexpected error occurred');
    }
  }
  @override
  Future<ApiResponse<bool>> addPet(String token, Map<String, dynamic> petData) async {
    try {
      final uri = Uri.parse(baseUrl + "/Pet/AddPet");

      // Tạo một yêu cầu multipart request
      var request = http.MultipartRequest('POST', uri);

      // Đặt tiêu đề với token
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['accept'] = '*/*';

      // Thêm các trường form data
      request.fields['Allergy'] = petData['allergy'] ?? '';
      request.fields['Sex'] = petData['sex'].toString();
      request.fields['Decription'] = petData['description'] ?? '';
      request.fields['Name'] = petData['name'] ?? '';
      request.fields['BehaviorCategoryId'] = petData['behaviorCategoryId'].toString();
      request.fields['IsNeuter'] = petData['isNeuter'].toString();
      request.fields['PetTypeId'] = petData['petTypeId'].toString();
      request.fields['Dob'] = petData['dob'] ?? '';
      request.fields['Weight'] = petData['weight'].toString();
      request.fields['MicrochipNumber'] = petData['microchipNumber'] ?? '';

      // Thêm file ảnh nếu có
      if (petData['image'] != null && petData['image'].isNotEmpty) {
        var imageFile = await http.MultipartFile.fromPath('PetImage', petData['image']);
        request.files.add(imageFile);
      }

      // Gửi yêu cầu và lấy phản hồi
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body) as Map<String, dynamic>;
        final data = decodedResponse['data'] as bool? ?? false;
        return ApiResponse<bool>.fromJson(decodedResponse, (json) => data);
      } else {
        throw ServerException(message: 'Failed to add pet with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<ApiResponse<bool>> updatePet(String token, int id, Map<String, dynamic> petData) async {
    try {
      final uri = Uri.parse(baseUrl + "/Pet/UpdatePet/${id}");

      // Create a multipart request
      var request = http.MultipartRequest('PATCH', uri);

      // Set headers with token
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['accept'] = '*/*';

      // Add fields from petData to form data
      request.fields['Allergy'] = petData['allergy'] ?? '';
      request.fields['Sex'] = petData['sex'].toString();
      request.fields['Decription'] = petData['description'] ?? '';  // Ensure correct field name here
      request.fields['Name'] = petData['name'] ?? '';
      request.fields['BehaviorCategoryId'] = petData['behaviorCategoryId'].toString();
      request.fields['IsNeuter'] = petData['isNeuter'].toString();
      request.fields['PetTypeId'] = petData['petTypeId'].toString();
      request.fields['Dob'] = petData['dob'] ?? '';
      request.fields['Weight'] = petData['weight'].toString();
      request.fields['MicrochipNumber'] = petData['microchipNumber'] ?? '';

      // Add image file if it exists
      if (petData['image'] != null && petData['image'].isNotEmpty) {
        var imageFile = await http.MultipartFile.fromPath('PetImage', petData['image']);
        request.files.add(imageFile);
      }

      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Print out the full response body for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response body into a Map
        final decodedResponse = json.decode(response.body) as Map<String, dynamic>;

        // Print out the parsed response for debugging
        print('Parsed Response: $decodedResponse');

        final data = decodedResponse['data'] as bool? ?? false;
        return ApiResponse<bool>.fromJson(decodedResponse, (json) => data);
      } else {
        throw ServerException(message: 'Failed to update pet with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: ${e.toString()}');
      throw ServerException(message: 'An unexpected error occurred: ${e.toString()}');
    }
  }
  @override
  Future<ApiResponse<bool>> deletePet(String token, int id) async {
    try {
      // Check if the token is available
      if (token.isEmpty) {
        throw UnauthorizedException(message: "Token is not available");
      }

      // Build the URI for the delete request
      final uri = Uri.parse(baseUrl + "/Pet/DeletePet/$id");

      // Send the DELETE request with headers
      final response = await client.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'accept': '*/*', // Accept any content type
        },
      );

      // Check if the response status is successful
      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body) as Map<String, dynamic>;
        final data = decodedResponse['data'] as bool? ?? false;

        return ApiResponse<bool>.fromJson(decodedResponse, (json) => data);
      } else {
        throw ServerException(message: 'Failed to delete pet with status code: ${response.statusCode}');
      }
    } on http.ClientException {
      throw NetworkException(message: 'Network error occurred');
    } catch (e) {
      throw ServerException(message: 'An unexpected error occurred: ${e.toString()}');
    }
  }



}