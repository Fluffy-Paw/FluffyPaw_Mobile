import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluffypawmobile/domain/usecases/add_pet.dart';

class AddPetViewModel extends StateNotifier<AsyncValue<void>> {
  final AddPet addPet;

  AddPetViewModel({required this.addPet}) : super(const AsyncValue.data(null));

  Future<void> submitForm(Map<String, dynamic> petData) async {
    final cleanedPetData = <String, dynamic>{};

    petData.forEach((key, value) {
      cleanedPetData[key] = value ?? (key == 'weight' ? 0.0 : (key == 'isNeuter' ? false : ""));
    });

    if (cleanedPetData.isNotEmpty) {
      state = const AsyncValue.loading();
      final result = await addPet(cleanedPetData);
      result.fold(
            (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
            (_) => state = AsyncValue.data(null),
      );
    } else {
      state = AsyncValue.error("Invalid pet data", StackTrace.current);
    }
  }
}
