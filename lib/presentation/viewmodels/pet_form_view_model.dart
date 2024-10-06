import 'package:fluffypawmobile/core/usecases/usecase.dart';
import 'package:fluffypawmobile/domain/usecases/get_behavior_category.dart';
import 'package:fluffypawmobile/domain/usecases/get_pet_category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/behavior_category.dart';
import '../../domain/entities/pet_category.dart';
import '../../domain/entities/pet_type.dart';
import '../../domain/usecases/get_pet_type.dart';

class PetCategoryViewModel extends StateNotifier<AsyncValue<void>> {
  final GetPetCategory getPetCategory;
  final GetPetType getPetType;
  final GetBehaviorCategory getBehaviorCategory;

  List<PetCategory> petCategories = [];
  List<PetType> petTypes = [];
  List<BehaviorCategory> behaviorCategories = [];

  PetCategoryViewModel({
    required this.getPetCategory,
    required this.getPetType,
    required this.getBehaviorCategory,
  }) : super(const AsyncValue.loading()) {
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      final petCategoryResponse = await getPetCategory(NoParams());
      final behaviorCategoryResponse = await getBehaviorCategory(NoParams());

      petCategories = petCategoryResponse.fold((l) => [], (r) => r.data as List<PetCategory>);
      behaviorCategories = behaviorCategoryResponse.fold((l) => [], (r) => r.data as List<BehaviorCategory>);

      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Function to get pet types based on selected category (Dog or Cat)
  Future<void> getPetTypeWithId(int id) async {
    try {
      final petTypeResponse = await getPetType(id);
      petTypes = petTypeResponse.fold((l) => [], (r) => r.data as List<PetType>);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
