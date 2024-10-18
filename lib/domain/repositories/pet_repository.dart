import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/pet_model.dart';
import 'package:fluffypawmobile/domain/entities/behavior_category.dart';
import 'package:fluffypawmobile/domain/entities/pet_category.dart';
import 'package:fluffypawmobile/domain/entities/pet_type.dart';

abstract class PetRepository{
  Future<Either<Failures,ApiResponse<List<PetModel>>>>getPetList();
  Future<Either<Failures,ApiResponse<PetModel>>>getPetByID(int id);
  Future<Either<Failures, ApiResponse<List<PetCategory>>>> getPetCategory();
  Future<Either<Failures, ApiResponse<List<PetType>>>> getPetType(int id);
  Future<Either<Failures, ApiResponse<List<BehaviorCategory>>>> getBehaviorCategory();
  Future<Either<Failures, ApiResponse<bool>>> addPet(Map<String, dynamic> petData);
  Future<Either<Failures, ApiResponse<bool>>> updatePet(int id, Map<String, dynamic> petData);
  Future<Either<Failures, ApiResponse<bool>>> deletePet(int id);

}