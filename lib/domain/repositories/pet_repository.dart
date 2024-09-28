import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/pet_model.dart';

abstract class PetRepository{
  Future<Either<Failures,ApiResponse<List<PetModel>>>>getPetList();
}