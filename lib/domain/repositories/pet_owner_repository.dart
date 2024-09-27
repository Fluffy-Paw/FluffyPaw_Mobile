import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/pet_owner_model.dart';

abstract class PetOwnerRepository{
  Future<Either<Failures, ApiResponse<PetOwner>>> getPetOwnerInfo();
}