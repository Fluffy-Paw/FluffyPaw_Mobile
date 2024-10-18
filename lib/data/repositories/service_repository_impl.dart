import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/auth_service.dart';
import 'package:fluffypawmobile/core/error/exceptions.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/datasources/abstract/service_remote_data_source.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/service_model.dart';
import 'package:fluffypawmobile/data/models/service_type_model.dart';
import 'package:fluffypawmobile/data/models/store_model.dart';
import 'package:fluffypawmobile/data/models/store_service_model.dart';
import 'package:fluffypawmobile/domain/repositories/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository{
  final ServiceRemoteDataSource serviceRemoteDataSource;
  final AuthService authService;
  ServiceRepositoryImpl({required this.serviceRemoteDataSource, required this.authService});
  @override
  Future<Either<Failures, ApiResponse<List<ServiceTypeModel>>>> getServiceTypeList() async {
    try{
      final pet = await serviceRemoteDataSource.getPetList();
      return Right(pet);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(message: '${e.toString()}'));
    }
  }

  @override
  Future<Either<Failures, ApiResponse<List<StoreModel>>>> getStoreList() async{

    try{
      final token = await authService.getToken();
      if (token == null) {
        return Left(GeneralFailure(message: 'Token not found'));
      }
      final pet = await serviceRemoteDataSource.getAllStore(token);
      return Right(pet);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(message: '${e.toString()}'));
    }
  }
  @override
  Future<Either<Failures, ApiResponse<StoreModel>>> getStoreByID(int id) async {
    try {
      final token = await authService.getToken();
      if (token == null) {
        return Left(GeneralFailure(message: 'Token not found'));
      }
      final store = await serviceRemoteDataSource.getStoreByID(token, id);
      return Right(store);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(message: '${e.toString()}'));
    }
  }

  @override
  Future<Either<Failures, ApiResponse<List<StoreServiceModel>?>>> getStoreServiceByStoreID(int id) async {
    try {
      final token = await authService.getToken();
      if (token == null) {
        return Left(GeneralFailure(message: 'Token not found'));
      }
      final storeServices = await serviceRemoteDataSource.getStoreServiceByStoreID(token, id);
      return Right(storeServices);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(message: '${e.toString()}'));
    }
  }
  @override
  Future<Either<Failures, ApiResponse<List<ServiceModel>>>> getAllStoreServiceByServiceId(int serviceId) async {
    try {
      final token = await authService.getToken();
      if (token == null) {
        return Left(GeneralFailure(message: 'Token not found'));
      }
      final services = await serviceRemoteDataSource.getAllStoreServiceByServiceId(token, serviceId);
      return Right(services);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(message: '${e.toString()}'));
    }
  }
  @override
  Future<Either<Failures, void>> createBooking({
    required List<int> petIds, // Update petId to petIds as a List<int>
    required int storeServiceId,
    required String paymentMethod,
    required String description,
  }) async {
    try {
      final token = await authService.getToken();
      if (token == null) {
        return Left(GeneralFailure(message: 'Token not found'));
      }

      await serviceRemoteDataSource.createBooking(
        token: token,
        petIds: petIds, // Pass petIds as the list
        storeServiceId: storeServiceId,
        paymentMethod: paymentMethod,
        description: description,
      );
      return Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }


}