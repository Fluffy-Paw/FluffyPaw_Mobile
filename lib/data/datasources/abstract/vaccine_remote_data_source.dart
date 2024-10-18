import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/vaccine_model.dart';

abstract class VaccineRemoteDataSource{
  Future<ApiResponse<List<VaccineModel>>> getPetVaccineByID(String token, int id);
  Future<ApiResponse<VaccineModel>> getVaccineDetail(String token, int id);
  Future<ApiResponse<bool>> addVaccine(String token, Map<String, dynamic> vaccineData);
  Future<ApiResponse<bool>> updateVaccine(String token,int id, Map<String, dynamic> vaccineData);
  Future<ApiResponse<bool>> deleteVaccine(String token, int id);

}