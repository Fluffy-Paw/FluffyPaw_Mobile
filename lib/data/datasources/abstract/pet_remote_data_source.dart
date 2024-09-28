import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/pet_model.dart';

abstract class PetRemoteDataSource{
  Future<ApiResponse<List<PetModel>>> getPetList(String token);

}