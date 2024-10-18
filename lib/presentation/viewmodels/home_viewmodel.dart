import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';
import 'package:fluffypawmobile/data/models/pet_owner_model.dart';
import 'package:fluffypawmobile/data/models/service_type_model.dart';
import 'package:fluffypawmobile/data/models/store_model.dart';
import 'package:fluffypawmobile/domain/usecases/get_store_list.dart';
import 'package:fluffypawmobile/domain/usecases/pet_owner_detail.dart';
import 'package:fluffypawmobile/domain/usecases/service_type_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeViewModel extends StateNotifier<HomeState> {
  final PetOwnerDetail petOwnerDetail;
  final ServiceTypeList serviceTypeList;
  final GetStoreList storeList;
  HomeViewModel(this.petOwnerDetail, this.serviceTypeList, this.storeList) : super(HomeState.initial()) {
    loadPetOwnerDetail();
    loadServiceTypeList();
    load5Store();
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
  Future<void> loadServiceTypeList() async{
    state = state.copyWith(isLoading: true);
    final Either<Failures, List<ServiceTypeModel>> result = await serviceTypeList(NoParams());
    result.fold(
        (failure){
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'Failed to load Pet Service: ${failure.message}'
          );
          throw Exception(state.errorMessage);
        }
    , (serviceType){
      if (serviceType.isNotEmpty) {
        state = state.copyWith(
          isLoading: false,
            serviceTypeNames: serviceType.map((serviceType) => serviceType.name ?? 'Unknown').toList(),
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'No service types available',
        );
      }
    }
    );

  }
  Future<void> load5Store() async {
    state = state.copyWith(isLoading: true);
    final result = await storeList(NoParams());

    result.fold(
          (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load vaccine history: ${failure.message}',
        );
      },
          (storeList) {
        state = state.copyWith(
          isLoading: false,
          storeList: storeList.toList(),
        );
      },
    );
  }
}

class HomeState {
  final String userName;
  final String greeting;
  final String avatarUrl;
  final bool isLoading;
  final String? name;
  final String? brandName;
  final double? totalRating;
  final List<String> serviceTypeNames;
  final String? errorMessage;
  final List<StoreModel>? storeList;

  HomeState({
    required this.userName,
    required this.greeting,
    required this.avatarUrl,
    required this.isLoading,
    required this.serviceTypeNames,
    this.errorMessage,
    this.brandName,
    this.name,
    this.totalRating,
    this.storeList
  });

  factory HomeState.initial() => HomeState(
    userName: "User",
    greeting: "Xin chào,",
    avatarUrl: "https://static.vecteezy.com/system/resources/thumbnails/002/318/271/small_2x/user-profile-icon-free-vector.jpg",
    isLoading: false,
    errorMessage: null,
    serviceTypeNames: [],
    brandName: "default brandName",
    name: "name",
    totalRating: 0,
    storeList: []

  );

  HomeState copyWith({
    String? userName,
    String? greeting,
    String? avatarUrl,
    bool? isLoading,
    String? errorMessage,
    List<String>? serviceTypeNames,
    String? name,
    String? brandName,
    double? totalRating,
    List<StoreModel>? storeList
  }) {
    return HomeState(
      userName: userName ?? this.userName,
      greeting: greeting ?? this.greeting,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      serviceTypeNames: serviceTypeNames ?? this.serviceTypeNames,
      name: name ?? this.name,
      brandName: brandName ?? this.brandName,
      totalRating: totalRating ?? this.totalRating,
      storeList: storeList ?? this.storeList,
    );
  }
}