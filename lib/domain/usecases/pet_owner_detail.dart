import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';
import 'package:fluffypawmobile/data/models/pet_owner_model.dart';
import 'package:fluffypawmobile/domain/repositories/pet_owner_repository.dart';

class PetOwnerDetail implements UseCase<PetOwner, NoParams>{

  final PetOwnerRepository petOwnerRepository;

  PetOwnerDetail(this.petOwnerRepository);

  @override
  Future<Either<Failures, PetOwner>> call(NoParams params) async{
    // TODO: implement call
    final result = await petOwnerRepository.getPetOwnerInfo();
    return result.fold(
          (failure) => Left(failure),
          (apiResponse) => Right(apiResponse.data!), // Truy xuất PetOwner từ ApiResponse
    );
  }

}