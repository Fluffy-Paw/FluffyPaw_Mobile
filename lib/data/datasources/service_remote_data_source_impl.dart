import 'dart:convert';

import 'package:fluffypawmobile/core/error/exceptions.dart';
import 'package:fluffypawmobile/core/utils/constants.dart';
import 'package:fluffypawmobile/data/datasources/abstract/service_remote_data_source.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/service_model.dart';
import 'package:fluffypawmobile/data/models/service_type_model.dart';
import 'package:fluffypawmobile/data/models/store_model.dart';
import 'package:fluffypawmobile/data/models/store_service_model.dart';
import 'package:http/http.dart' as http;

class ServiceRemoteDataSourceImpl implements ServiceRemoteDataSource{
  final http.Client client;

  ServiceRemoteDataSourceImpl({required this.client});
  @override
  Future<ApiResponse<List<ServiceTypeModel>>> getPetList() async {
    try {


      final response = await client.get(
        Uri.parse(baseUrl + "/ServiceType/GetAllServiceType"),
        headers: {
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body) as Map<String, dynamic>;
        return ApiResponse<List<ServiceTypeModel>>.fromJson(
          decodedResponse,
              (json) => (json as List<dynamic>)
              .map((petJson) => ServiceTypeModel.fromJson(petJson as Map<String, dynamic>))
              .toList(),
        );
      } else {
        print("ERROR: Failed to fetch service type with status code: ${response.statusCode}");
        throw ServerException(message: 'Failed to fetch service type list');
      }
    } on http.ClientException {
      throw NetworkException(message: 'Network error occurred');
    } catch (e) {
      throw ServerException(message: e is ServerException ? e.message : 'An unexpected error occurred');
    }
  }

  @override
  Future<ApiResponse<List<StoreModel>>> getAllStore(String token) async{
    try {


      final response = await client.get(
        Uri.parse(baseUrl + "/PetOwner/GetAllStore"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization' : 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body) as Map<String, dynamic>;
        return ApiResponse<List<StoreModel>>.fromJson(
          decodedResponse,
              (json) => (json as List<dynamic>)
              .map((storeJson) => StoreModel.fromJson(storeJson as Map<String, dynamic>))
              .toList(),
        );
      } else {
        print("ERROR: Failed to fetch service type with status code: ${response.statusCode}");
        throw ServerException(message: 'Failed to fetch service type list');
      }
    } on http.ClientException {
      throw NetworkException(message: 'Network error occurred');
    } catch (e) {
      throw ServerException(message: e is ServerException ? e.message : 'An unexpected error occurred');
    }
  }

  @override
  Future<ApiResponse<StoreModel>> getStoreByID(String token, int id) async {
    try {
      final response = await client.get(
        Uri.parse(baseUrl + "/PetOwner/GetStoreById/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body) as Map<String, dynamic>;

        // Extract the first item from the 'data' list
        if (decodedResponse['data'] is List<dynamic> && decodedResponse['data'].isNotEmpty) {
          final storeJson = decodedResponse['data'][0] as Map<String, dynamic>;

          return ApiResponse<StoreModel>.fromJson(
            decodedResponse,
                (json) => StoreModel.fromJson(storeJson),
          );
        } else {
          throw ServerException(message: 'No data found');
        }
      } else {
        print("ERROR: Failed to fetch store with status code: ${response.statusCode}");
        throw ServerException(message: 'Failed to fetch store by ID');
      }
    } on http.ClientException {
      throw NetworkException(message: 'Network error occurred');
    } catch (e) {
      throw ServerException(message: e is ServerException ? e.message : 'An unexpected error occurred');
    }
  }


  @override
  Future<ApiResponse<List<StoreServiceModel>?>> getStoreServiceByStoreID(String token, int id) async {
    try {
      final response = await client.get(
        Uri.parse(baseUrl + "/Service/GetAllServiceByStoreId/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body) as Map<String, dynamic>;
        return ApiResponse<List<StoreServiceModel>>.fromJson(
          decodedResponse,
              (json) => (json as List<dynamic>)
              .map((serviceJson) => StoreServiceModel.fromJson(serviceJson as Map<String, dynamic>))
              .toList(),
        );
      } else if (response.statusCode == 404) {
        final errorResponse = json.decode(response.body) as Map<String, dynamic>;
        final message = errorResponse['message'] as String;
        // Trả về ApiResponse với data là null và message từ JSON nếu không tìm thấy dịch vụ
        return ApiResponse<List<StoreServiceModel>?>(statusCode: 404, data: null, message: message);
      } else {
        print("ERROR: Failed to fetch store services with status code: ${response.statusCode}");
        throw ServerException(message: 'Failed to fetch store services by store ID');
      }
    } on http.ClientException {
      throw NetworkException(message: 'Network error occurred');
    } catch (e) {
      throw ServerException(message: e is ServerException ? e.message : 'An unexpected error occurred');
    }
  }




  @override
  Future<ApiResponse<List<ServiceModel>>> getAllStoreServiceByServiceId(String token, int serviceId) async {
    try {
      final response = await client.get(
        Uri.parse(baseUrl + "/PetOwner/GetAllStoreServiceByServiceId/$serviceId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body) as Map<String, dynamic>;

        return ApiResponse<List<ServiceModel>>.fromJson(
          decodedResponse,
              (json) => (json as List<dynamic>)
              .map((serviceJson) => ServiceModel.fromJson(serviceJson as Map<String, dynamic>))
              .toList(),
        );
      } else {
        print("ERROR: Failed to fetch store services by service ID with status code: ${response.statusCode}");
        throw ServerException(message: 'Failed to fetch store services by service ID');
      }
    } on http.ClientException {
      throw NetworkException(message: 'Network error occurred');
    } catch (e) {
      throw ServerException(message: e is ServerException ? e.message : 'An unexpected error occurred');
    }
  }
  @override
  Future<void> createBooking({
    required String token,
    required List<int> petIds, // Update petId to petIds as a List<int>
    required int storeServiceId,
    required String paymentMethod,
    required String description,
  }) async {
    final url = Uri.parse(baseUrl + "/PetOwner/CreateBooking");

    try {
      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "petId": petIds, // Update to petIds to match the List<int>
          "storeServiceId": storeServiceId,
          "paymentMethod": paymentMethod,
          "description": description,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Booking created successfully");
      } else {
        print("ERROR: Failed to create booking with status code: ${response.statusCode}");
        throw ServerException(message: 'Failed to create booking');
      }
    } on http.ClientException {
      throw NetworkException(message: 'Network error occurred');
    } catch (e) {
      throw ServerException(message: e is ServerException ? e.message : 'An unexpected error occurred');
    }
  }




}