import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/models/pet_model.dart';
import 'package:fluffypawmobile/domain/usecases/add_vaccine.dart';
import 'package:fluffypawmobile/domain/usecases/delete_pet.dart';
import 'package:fluffypawmobile/domain/usecases/delete_vaccine.dart';
import 'package:fluffypawmobile/domain/usecases/get_vaccine_detail.dart';
import 'package:fluffypawmobile/domain/usecases/pet_info_by_id.dart';
import 'package:fluffypawmobile/domain/usecases/update_vaccine.dart';
import 'package:fluffypawmobile/domain/usecases/vaccine_history_pet.dart';
import 'package:fluffypawmobile/presentation/state/pet_info_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PetProfileViewmodel extends StateNotifier<PetInfoState> {
  final PetInfoById petInfoById;
  final DeletePet deletePet;
  final VaccineHistoryPet vaccineHistoryPet;
  final AddVaccine addVaccine;
  final DeleteVaccine deleteVaccine;
  final GetVaccineDetail getVaccineDetail;
  final UpdateVaccine updateVaccine;

  // Constructor that calls loadPetById when initialized
  PetProfileViewmodel(this.petInfoById, this.deletePet, int id, this.vaccineHistoryPet, this.addVaccine,
       this.deleteVaccine,
       this.getVaccineDetail,
       this.updateVaccine,) : super(PetInfoState.initial()) {
    _init(id);
  }

  // Private method to handle asynchronous loading on init
  void _init(int id) async {
    await loadPetById(id); // Call the method to load pet data by ID
    await loadVaccineHistoryByPetId(id);
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
          petId: petModel.id

        );
      },
    );
  }
  Future<Either<Failures, bool>> deletePetById(int id) async {
    // Call the deletePet use case
    final result = await deletePet(id);

    // Transform ApiResponse<bool> into bool by extracting the data field
    return result.fold(
          (failure) => Left(failure),
          (apiResponse) {
        // Return the data (which is a boolean value) from the ApiResponse
        return Right(apiResponse.data ?? false); // If data is null, return false
      },
    );
  }
  Future<void> loadVaccineHistoryByPetId(int petId) async {
    state = state.copyWith(isLoading: true);

    final result = await vaccineHistoryPet(petId);

    result.fold(
          (failure) {
        if (failure is NotFoundFailure) {
          // This is not an error, just no vaccines found
          state = state.copyWith(
            isLoading: false,
            vaccineList: [], // Empty list, not null
            errorMessage: null, // No error message for this case
          );
        } else {
          // This is an actual error
          state = state.copyWith(
            isLoading: false,
            vaccineList: [],
            errorMessage: null,
          );
        }
      },
          (vaccineList) {
        state = state.copyWith(
          isLoading: false,
          vaccineList: vaccineList,
          errorMessage: null,
        );
      },
    );
  }
  Future<void> addNewVaccine(Map<String, dynamic> vaccineData) async {
    state = state.copyWith(isLoading: true);
    final result = await addVaccine(vaccineData);
    result.fold(
          (failure) {
        state = state.copyWith(isLoading: false, errorMessage: 'Failed to add vaccine');
      },
          (response) {
        state = state.copyWith(isLoading: false);
        loadVaccineHistoryByPetId(state.petId!); // Reload the vaccine list
      },
    );
  }
  Future<void> getVaccineDetailById(int vaccineId) async {
    state = state.copyWith(isLoading: true);

    // Fetch the vaccine details
    final result = await getVaccineDetail(vaccineId);

    result.fold(
          (failure) {
        // Handle failure by updating the errorMessage and stopping the loading state
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load vaccine details',
        );
      },
          (apiResponse) {
        final vaccineDetail = apiResponse.data;

        state = state.copyWith(
          isLoading: false,
          selectedVaccine: vaccineDetail,
        );
      },
    );
  }
  Future<void> deleteVaccineById(int vaccineId) async {
    state = state.copyWith(isLoading: true);
    final result = await deleteVaccine(vaccineId);
    result.fold(
          (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
          (success) {
            loadVaccineHistoryByPetId(state.petId!); // Reload vaccine history
      },
    );
  }
  Future<void> updateVaccineById(int vaccineId, Map<String, dynamic> vaccineData) async {
    state = state.copyWith(isLoading: true);
    final result = await updateVaccine(UpdateVaccineParams(id: vaccineId, vaccineData: vaccineData));
    result.fold(
          (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
          (success) {
        // Assuming you want to reload the vaccine history after updating
        if (state.vaccineList != null) {
          loadVaccineHistoryByPetId(state.petId!);
        } else {
          state = state.copyWith(isLoading: false, errorMessage: 'Pet ID is null');
        }
      },
    );
  }




}
