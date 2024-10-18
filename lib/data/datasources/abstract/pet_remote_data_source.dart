import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/pet_model.dart';
import 'package:fluffypawmobile/domain/entities/behavior_category.dart';
import 'package:fluffypawmobile/domain/entities/pet_category.dart';
import 'package:fluffypawmobile/domain/entities/pet_type.dart';

abstract class PetRemoteDataSource{
  Future<ApiResponse<List<PetModel>>> getPetList(String token);
  Future<ApiResponse<PetModel>> getPetByID(String token, int id);
  Future<ApiResponse<List<PetCategory>>> getPetCategory(String token);
  Future<ApiResponse<List<PetType>>> getPetType(String token, int id);
  Future<ApiResponse<List<BehaviorCategory>>> getBehaviorCategory(String token);
  Future<ApiResponse<bool>> addPet(String token, Map<String, dynamic> petData);
  Future<ApiResponse<bool>> updatePet(String token,int id, Map<String, dynamic> petData);
  Future<ApiResponse<bool>> deletePet(String token, int id);


}