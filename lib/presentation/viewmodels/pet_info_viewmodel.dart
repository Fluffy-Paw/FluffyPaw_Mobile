import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/data/models/pet_model.dart';
import 'package:fluffypawmobile/domain/usecases/pet_info_by_id.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PetInfoNotifier extends StateNotifier<AsyncValue<PetModel?>> {
  final PetInfoById getPetInfoById;
  final int petId;

  PetInfoNotifier({
    required this.getPetInfoById,
    required this.petId,
  }) : super(const AsyncValue.loading()) {
    fetchPetInfo();
  }

  Future<void> fetchPetInfo() async {
    state = const AsyncValue.loading();
    final result = await getPetInfoById(petId);
    state = result.fold(
          (failure) => AsyncValue.error(_mapFailureToMessage(failure), StackTrace.current),
          (pet) => AsyncValue.data(pet),
    );
  }

  String _mapFailureToMessage(Failures failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Lỗi máy chủ';
      case NetworkFailure:
        return 'Lỗi kết nối';
      case NotFoundFailure:
        return 'Không tìm thấy thú cưng';
      default:
        return 'Đã xảy ra lỗi';
    }
  }
}