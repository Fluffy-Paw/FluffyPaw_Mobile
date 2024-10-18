import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/domain/usecases/get_store_by_id.dart';
import 'package:fluffypawmobile/domain/usecases/get_store_service_by_store_id.dart';
import 'package:fluffypawmobile/presentation/state/store_detail_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluffypawmobile/data/models/store_model.dart';
import 'package:fluffypawmobile/data/models/store_service_model.dart';

class StoreDetailViewModel extends StateNotifier<StoreDetailState> {
  final GetStoreByID getStoreByID;
  final GetStoreServiceByStoreID getStoreServiceByStoreID;

  StoreDetailViewModel(this.getStoreByID, this.getStoreServiceByStoreID, int id)
      : super(StoreDetailState.initial()) {
    _init(id);
  }

  void _init(int id) async {
    await loadStoreById(id);
    await loadStoreServices(id);
  }

  Future<void> loadStoreById(int id) async {
    print("Loading store with ID: $id");

    state = state.copyWith(isLoading: true);

    final Either<Failures, StoreModel> result = await getStoreByID(id);

    result.fold(
          (failure) {
        print("Failed to load store: ${failure.message}");
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load store: ${failure.message}',
        );
      },
          (storeModel) {
        print("Store loaded successfully: ${storeModel.name}");
        state = state.copyWith(
          isLoading: false,
          errorMessage: null,
          storeModel: storeModel,
        );
      },
    );
  }

  Future<void> loadStoreServices(int storeId) async {
    state = state.copyWith(isLoading: true);

    final result = await getStoreServiceByStoreID(storeId);

    result.fold(
          (failure) {
        // Handle all failures except NotFoundFailure
        if (failure is NotFoundFailure) {
          state = state.copyWith(
            isLoading: false,
            storeServiceList: [], // Return an empty list if no services are found
            errorMessage: null,   // No error message in this case
          );
        } else {
          // Handle genuine errors
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'Failed to load store services: ${failure.message}',
          );
        }
      },
          (serviceList) {
        // Populate state with services if they exist
        state = state.copyWith(
          isLoading: false,
          storeServiceList: serviceList,
          errorMessage: null,
        );
      },
    );
  }


}