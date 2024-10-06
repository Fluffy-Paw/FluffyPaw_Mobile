import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';
import 'package:fluffypawmobile/data/models/pet_owner_model.dart';
import 'package:fluffypawmobile/domain/usecases/pet_owner_detail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeViewModel extends StateNotifier<HomeState> {
  final PetOwnerDetail petOwnerDetail;
  HomeViewModel(this.petOwnerDetail) : super(HomeState.initial()) {
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
              userName: petOwner.fullName,
              avatarUrl: petOwner.avatar ?? "https://static.vecteezy.com/system/resources/thumbnails/002/318/271/small_2x/user-profile-icon-free-vector.jpg",
              greeting: "Xin chào, ${petOwner.fullName}"
          );
        }
    );
  }
}

class HomeState {
  final String userName;
  final String greeting;
  final String avatarUrl;
  final bool isLoading;
  final String? errorMessage;

  HomeState({
    required this.userName,
    required this.greeting,
    required this.avatarUrl,
    required this.isLoading,
    this.errorMessage
  });

  factory HomeState.initial() => HomeState(
    userName: "User",
    greeting: "Xin chào,",
    avatarUrl: "https://static.vecteezy.com/system/resources/thumbnails/002/318/271/small_2x/user-profile-icon-free-vector.jpg",
    isLoading: false,
    errorMessage: null,
  );

  HomeState copyWith({
    String? userName,
    String? greeting,
    String? avatarUrl,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomeState(
      userName: userName ?? this.userName,
      greeting: greeting ?? this.greeting,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}