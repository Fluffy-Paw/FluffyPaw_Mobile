import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/models/pet_model.dart';
import 'package:fluffypawmobile/domain/usecases/pet_info_by_id.dart';
import 'package:fluffypawmobile/presentation/state/pet_info_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PetProfileViewmodel extends StateNotifier<PetInfoState> {
  final PetInfoById petInfoById;

  // Constructor that calls loadPetById when initialized
  PetProfileViewmodel(this.petInfoById, int id) : super(PetInfoState.initial()) {
    _init(id); // Calls the asynchronous method to load pet data by id
  }

  // Private method to handle asynchronous loading on init
  void _init(int id) async {
    await loadPetById(id); // Call the method to load pet data by ID
  }

  // Asynchronous method to load pet by ID
  Future<void> loadPetById(int id) async {
    print("Loading pet with ID: $id");

    // Update state to reflect loading process
    state = state.copyWith(isLoading: true);

    // Fetch pet data by ID
    final Either<Failures, PetModel> result = await petInfoById(id);

    // Handle the result of fetching pet data
    result.fold(
          (failure) {
        print("Failed to load pet: ${failure.message}");
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load pet: ${failure.message}',
        );
      },
          (petModel) {
        print("Pet loaded successfully: ${petModel.name}");
        state = state.copyWith(
          isLoading: false,
          errorMessage: null,
          petCategory: petModel.petType?.petCategory.name ?? 'Unknown',
          behaviorCategory: petModel.behaviorCategory?.name ?? 'errorFetchData',
          petTypeName: petModel.petType?.name ?? 'errorFetchData',
          name: petModel.name,
          image: petModel.image ?? '',
          sex: petModel.sex,
          weight: petModel.weight,
          dob: petModel.dob,
          allergy: petModel.allergy,
          microchipNumber: petModel.microchipNumber,
          description: petModel.description,
          isNeuter: petModel.isNeuter,
        );
      },
    );
  }
}
