import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';
import 'package:fluffypawmobile/data/models/pet_model.dart';
import 'package:fluffypawmobile/domain/usecases/pet_account.dart';
import 'package:fluffypawmobile/domain/usecases/pet_info_by_id.dart';
import 'package:fluffypawmobile/presentation/state/pet_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PetViewModel extends StateNotifier<PetState>{
  final PetAccount petAccount;

  PetViewModel(this.petAccount) : super(PetState.initial()){
    loadPetList();
  }
  Future<void> loadPetList() async {
    state = state.copyWith(isLoading: true);
    final Either<Failures, List<PetModel>> result = await petAccount(NoParams());
    result.fold(
        (failure) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'Failed to load pet list: ${failure.message}'
          );
          throw Exception(state.errorMessage);
        },
        (petModel) {
          state = state.copyWith(
            isLoading: false,
            pets: petModel,
            errorMessage: null,
          );
        }
    );
  }




}