import 'package:fluffypawmobile/dependency_injection/dependency_injection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';
import 'package:fluffypawmobile/domain/usecases/update_pet.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:dartz/dartz.dart';



class UpdatePetViewModel extends StateNotifier<AsyncValue<void>> {
  final UpdatePet updatePetUseCase;

  UpdatePetViewModel(this.updatePetUseCase) : super(const AsyncValue.data(null));

  Future<void> updatePet(int petId, Map<String, dynamic> petData) async {
    state = const AsyncValue.loading();
    final result = await updatePetUseCase({"id": petId, ...petData});
    state = result.fold(
          (failure) => AsyncValue.error(failure, StackTrace.current),
          (success) => const AsyncValue.data(null),
    );
  }
}