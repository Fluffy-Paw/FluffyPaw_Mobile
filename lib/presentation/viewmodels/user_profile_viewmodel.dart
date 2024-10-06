import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';
import 'package:fluffypawmobile/data/models/pet_owner_model.dart';
import 'package:fluffypawmobile/domain/usecases/pet_owner_detail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/user_profile_state.dart';

class UserProfileViewModel extends StateNotifier<UserProfileState>{
  final PetOwnerDetail petOwnerDetail;
  UserProfileViewModel(this.petOwnerDetail) : super(UserProfileState.initial()){
    loadPetOwnerDetail();

  }
  Future<void> loadPetOwnerDetail() async {
    state = state.copyWith(isLoading: true);
    final Either<Failures, PetOwner> result = await petOwnerDetail(NoParams());
    result.fold(
            (failure) {
          state = state.copyWith(
              isLoading: false,
              errorMessage: 'Failed to load pet owner info: ${failure.message}'
          );
          throw Exception(state.errorMessage);
        },

            (petOwner) {
          state = state.copyWith(
              isLoading: false,
              fullName: petOwner.fullName,
              email: petOwner.email ?? "example@gmail.com",
            avatar: petOwner.avatar,

            phone: petOwner.phone,
            address: petOwner.address
          );
        }
    );
  }

}
