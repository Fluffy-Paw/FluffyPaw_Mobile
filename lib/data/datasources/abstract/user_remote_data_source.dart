import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/pet_owner_model.dart';


abstract class UserRemoteDataSource {
  Future<ApiResponse<PetOwner>> getPetOwnerInfo(String token);
}