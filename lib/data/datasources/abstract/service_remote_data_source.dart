import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/service_model.dart';
import 'package:fluffypawmobile/data/models/service_type_model.dart';
import 'package:fluffypawmobile/data/models/store_model.dart';
import 'package:fluffypawmobile/data/models/store_service_model.dart';

abstract class ServiceRemoteDataSource {
  Future<ApiResponse<List<ServiceTypeModel>>> getPetList();

  Future<ApiResponse<List<StoreModel>>> getAllStore(String token);

  Future<ApiResponse<StoreModel>> getStoreByID(String token, int id);

  Future<ApiResponse<List<StoreServiceModel>?>> getStoreServiceByStoreID(
      String token, int id);

  Future<ApiResponse<List<ServiceModel>>> getAllStoreServiceByServiceId(
      String token, int serviceId);

  Future<void> createBooking({
    required String token,
    required List<int> petIds, // Update petId to petIds as a List<int>
    required int storeServiceId,
    required String paymentMethod,
    required String description,
  }) ;
}
