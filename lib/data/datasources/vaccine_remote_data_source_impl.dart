import 'dart:convert';

import 'package:fluffypawmobile/core/error/exceptions.dart';
import 'package:fluffypawmobile/core/utils/constants.dart';
import 'package:fluffypawmobile/data/datasources/abstract/vaccine_remote_data_source.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/vaccine_model.dart';
import 'package:http/http.dart' as http;

class VaccineRemoteDataSourceImpl extends VaccineRemoteDataSource{
  final http.Client client;
  VaccineRemoteDataSourceImpl({required this.client});
  @override
  Future<ApiResponse<List<VaccineModel>>> getPetVaccineByID(String token, int id) async{
    try {


      final response = await client.get(
        Uri.parse(baseUrl + "/Vaccine/GetAllVaccineHistories/${id}"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body) as Map<String, dynamic>;
        return ApiResponse<List<VaccineModel>>.fromJson(
          decodedResponse,
              (json) => (json as List<dynamic>)
              .map((petJson) => VaccineModel.fromJson(petJson as Map<String, dynamic>))
              .toList(),
        );
      } else {
        print("ERROR: Failed to fetch pet vaccine with status code: ${response.statusCode}");
        throw ServerException(message: 'Failed to fetch pet vaccine list');
      }
    } on http.ClientException {
      throw NetworkException(message: 'Network error occurred');
    } catch (e) {
      throw ServerException(message: e is ServerException ? e.message : 'An unexpected error occurred');
    }
  }

  @override
  Future<ApiResponse<bool>> addVaccine(String token, Map<String, dynamic> vaccineData) async {
    try {
      final uri = Uri.parse(
          baseUrl + "/Vaccine/AddVaccine");

      // Create a multipart request
      var request = http.MultipartRequest('POST', uri);

      // Set headers including authorization token
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['accept'] = '*/*';

      // Add form fields
      request.fields['PetId'] = vaccineData['petId'].toString();
      request.fields['Name'] = vaccineData['name'].toString();
      request.fields['PetCurrentWeight'] =
          vaccineData['petCurrentWeight'].toString();
      request.fields['VaccineDate'] = vaccineData['vaccineDate']
          .toString(); // Ensure this is in string format
      request.fields['NextVaccineDate'] = vaccineData['nextVaccineDate']
          .toString(); // Ensure this is in string format
      request.fields['Description'] = vaccineData['description'] ?? '';

      // Add the image file if available
      if (vaccineData['image'] != null && vaccineData['image'].isNotEmpty) {
        var imageFile = await http.MultipartFile.fromPath(
            'VaccineImage', vaccineData['image']);
        request.files.add(imageFile);
      }

      // Send the request and get the response
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Check for success response
      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body) as Map<
            String,
            dynamic>;
        final data = decodedResponse['data'] as bool? ?? false;
        return ApiResponse<bool>.fromJson(decodedResponse, (json) => data);
      } else {
        throw ServerException(
            message: 'Failed to add vaccine with status code: ${response
                .statusCode}');
      }
    } catch (e) {
      throw ServerException(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<ApiResponse<bool>> deleteVaccine(String token, int id) async {
    try {
      final uri = Uri.parse(baseUrl + "/Vaccine/DeleteVaccine/$id");

      // Create a DELETE request
      var response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
        },
      );

      // Handle response
      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body) as Map<String, dynamic>;
        final data = decodedResponse['data'] as bool? ?? false;
        return ApiResponse<bool>.fromJson(decodedResponse, (json) => data);
      } else {
        throw ServerException(message: 'Failed to delete vaccine with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<ApiResponse<VaccineModel>> getVaccineDetail(String token, int id) async {
    try {
      final uri = Uri.parse(baseUrl + "/Vaccine/GetVaccineDetail/$id");

      // Create a GET request
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body) as Map<String, dynamic>;
        final data = VaccineModel.fromJson(decodedResponse['data']);
        return ApiResponse<VaccineModel>.fromJson(decodedResponse, (json) => data);
      } else {
        throw ServerException(message: 'Failed to get vaccine details with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<ApiResponse<bool>> updateVaccine(String token, int id, Map<String, dynamic> vaccineData) async {
    try {
      final uri = Uri.parse(baseUrl + "/Vaccine/UpdateVaccine/$id");

      // Create a PATCH request using multipart form data
      var request = http.MultipartRequest('PATCH', uri);

      // Set the headers with token
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['accept'] = '*/*';

      // Add fields to the request
      request.fields['PetId'] = vaccineData['petId'].toString();
      request.fields['Name'] = vaccineData['name'].toString();
      request.fields['PetCurrentWeight'] =
          vaccineData['petCurrentWeight'].toString();
      request.fields['VaccineDate'] = vaccineData['vaccineDate']
          .toString(); // Ensure this is in string format
      request.fields['NextVaccineDate'] = vaccineData['nextVaccineDate']
          .toString(); // Ensure this is in string format
      request.fields['Description'] = vaccineData['description'] ?? '';

      // Add the image file if available
      if (vaccineData['image'] != null && vaccineData['image'].isNotEmpty) {
        var imageFile = await http.MultipartFile.fromPath(
            'VaccineImage', vaccineData['image']);
        request.files.add(imageFile);
      }

      // Send the request and get response
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body) as Map<String, dynamic>;
        if (decodedResponse.containsKey('data') && decodedResponse['data'] is bool) {
          final bool data = decodedResponse['data'];
          return ApiResponse<bool>.fromJson(decodedResponse, (_) => data);
        } else {
          // If 'data' is not a boolean, assume the update was successful
          return ApiResponse<bool>.fromJson(decodedResponse, (_) => true);
        }
      } else {
        throw ServerException(message: 'Failed to update vaccine with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: 'An unexpected error occurred: ${e.toString()}');
    }
  }


}