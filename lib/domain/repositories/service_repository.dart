import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/service_model.dart';
import 'package:fluffypawmobile/data/models/service_type_model.dart';
import 'package:fluffypawmobile/data/models/store_model.dart';
import 'package:fluffypawmobile/data/models/store_service_model.dart';

abstract class ServiceRepository{
  Future<Either<Failures,ApiResponse<List<ServiceTypeModel>>>>getServiceTypeList();
  Future<Either<Failures,ApiResponse<List<StoreModel>>>>getStoreList();
  Future<Either<Failures, ApiResponse<StoreModel>>> getStoreByID(int id);
  Future<Either<Failures, ApiResponse<List<StoreServiceModel>?>>> getStoreServiceByStoreID(int id);
  Future<Either<Failures, ApiResponse<List<ServiceModel>>>> getAllStoreServiceByServiceId(int serviceId);
  Future<Either<Failures, void>> createBooking({
    required List<int> petIds, // Update petId to petIds as a List<int>
    required int storeServiceId,
    required String paymentMethod,
    required String description,
  }) ;
}