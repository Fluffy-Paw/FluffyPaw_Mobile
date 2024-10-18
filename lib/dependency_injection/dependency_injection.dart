import 'package:fluffypawmobile/core/auth_service.dart';
import 'package:fluffypawmobile/data/datasources/abstract/auth_remote_data_source.dart';
import 'package:fluffypawmobile/data/datasources/abstract/pet_remote_data_source.dart';
import 'package:fluffypawmobile/data/datasources/abstract/service_remote_data_source.dart';
import 'package:fluffypawmobile/data/datasources/abstract/user_remote_data_source.dart';
import 'package:fluffypawmobile/data/datasources/abstract/vaccine_remote_data_source.dart';
import 'package:fluffypawmobile/data/datasources/authRemoteDataSourceImpl.dart';
import 'package:fluffypawmobile/data/datasources/pet_remote_data_source_impl.dart';
import 'package:fluffypawmobile/data/datasources/service_remote_data_source_impl.dart';
import 'package:fluffypawmobile/data/datasources/user_remote_data_source_impl.dart';
import 'package:fluffypawmobile/data/datasources/vaccine_remote_data_source_impl.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/models/pet_model.dart';
import 'package:fluffypawmobile/data/models/vaccine_model.dart';
import 'package:fluffypawmobile/data/repositories/auth_repository_impl.dart';
import 'package:fluffypawmobile/data/repositories/pet_owner_repository_impl.dart';
import 'package:fluffypawmobile/data/repositories/pet_repository_impl.dart';
import 'package:fluffypawmobile/data/repositories/service_repository_impl.dart';
import 'package:fluffypawmobile/data/repositories/vaccine_repository_impl.dart';
import 'package:fluffypawmobile/domain/repositories/auth_repository.dart';
import 'package:fluffypawmobile/domain/repositories/pet_owner_repository.dart';
import 'package:fluffypawmobile/domain/repositories/pet_repository.dart';
import 'package:fluffypawmobile/domain/repositories/service_repository.dart';
import 'package:fluffypawmobile/domain/repositories/vaccine_repository.dart';
import 'package:fluffypawmobile/domain/usecases/add_pet.dart';
import 'package:fluffypawmobile/domain/usecases/add_vaccine.dart';
import 'package:fluffypawmobile/domain/usecases/create_booking.dart';
import 'package:fluffypawmobile/domain/usecases/delete_pet.dart';
import 'package:fluffypawmobile/domain/usecases/delete_vaccine.dart';
import 'package:fluffypawmobile/domain/usecases/get_all_store_service_by_service_id.dart';
import 'package:fluffypawmobile/domain/usecases/get_behavior_category.dart';
import 'package:fluffypawmobile/domain/usecases/get_pet_category.dart';
import 'package:fluffypawmobile/domain/usecases/get_pet_type.dart';
import 'package:fluffypawmobile/domain/usecases/get_store_by_id.dart';
import 'package:fluffypawmobile/domain/usecases/get_store_list.dart';
import 'package:fluffypawmobile/domain/usecases/get_store_service_by_store_id.dart';
import 'package:fluffypawmobile/domain/usecases/get_vaccine_detail.dart';
import 'package:fluffypawmobile/domain/usecases/login_account.dart';
import 'package:fluffypawmobile/domain/usecases/pet_account.dart';
import 'package:fluffypawmobile/domain/usecases/pet_info_by_id.dart';
import 'package:fluffypawmobile/domain/usecases/pet_owner_detail.dart';
import 'package:fluffypawmobile/domain/usecases/register_account.dart';
import 'package:fluffypawmobile/domain/usecases/service_type_list.dart';
import 'package:fluffypawmobile/domain/usecases/update_pet.dart';
import 'package:fluffypawmobile/domain/usecases/update_vaccine.dart';
import 'package:fluffypawmobile/domain/usecases/vaccine_history_pet.dart';
import 'package:fluffypawmobile/presentation/state/booking_state.dart';
import 'package:fluffypawmobile/presentation/state/pet_info_state.dart';
import 'package:fluffypawmobile/presentation/state/pet_state.dart';
import 'package:fluffypawmobile/presentation/state/store_detail_state.dart';
import 'package:fluffypawmobile/presentation/state/user_profile_state.dart';
import 'package:fluffypawmobile/presentation/viewmodels/add_pet_view_model.dart';
import 'package:fluffypawmobile/presentation/viewmodels/booking_viewmodel.dart';
import 'package:fluffypawmobile/presentation/viewmodels/home_viewmodel.dart';
import 'package:fluffypawmobile/presentation/viewmodels/login_viewmodel.dart';
import 'package:fluffypawmobile/presentation/viewmodels/pet_form_view_model.dart';
import 'package:fluffypawmobile/presentation/viewmodels/pet_info_viewmodel.dart';
import 'package:fluffypawmobile/presentation/viewmodels/pet_profile_viewmodel.dart';
import 'package:fluffypawmobile/presentation/viewmodels/pet_viewmodels.dart';
import 'package:fluffypawmobile/presentation/viewmodels/signup_viewmodel.dart';
import 'package:fluffypawmobile/presentation/viewmodels/store_detail_viewmodel.dart';
import 'package:fluffypawmobile/presentation/viewmodels/update_pet_view_model.dart';
import 'package:fluffypawmobile/presentation/viewmodels/user_profile_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final httpClientProvider =
    Provider.autoDispose<http.Client>((ref) => http.Client());
final authServiceProvider = Provider.autoDispose<AuthService>((ref) {
  return AuthService();
});
final authRemoteDataSourceProvider =
    Provider.autoDispose<AuthRemoteDataSource>((ref) {
  return AuthRemoteDatasourceImpl(
      client: ref.read(httpClientProvider),
      authService: ref.read(authServiceProvider));
});

final userRemoteDataSourceProvider =
    Provider.autoDispose<UserRemoteDataSource>((ref) {
  return UserRemoteDataSourceImpl(client: ref.read(httpClientProvider));
});

final serviceRemoteDataSourceProvider =
    Provider.autoDispose<ServiceRemoteDataSource>((ref) {
  return ServiceRemoteDataSourceImpl(client: ref.read(httpClientProvider));
});

final petRemoteDataSourceProvider =
    Provider.autoDispose<PetRemoteDataSource>((ref) {
  return PetRemoteDataSourceImpl(client: ref.read(httpClientProvider));
});
final vaccineRemoteDataSourceProvider =
    Provider.autoDispose<VaccineRemoteDataSource>((ref) {
  return VaccineRemoteDataSourceImpl(client: ref.read(httpClientProvider));
});

final petOwnerRepositoryProvider =
    Provider.autoDispose<PetOwnerRepository>((ref) {
  return PetOwnerRepositoryImpl(
      userRemoteDataSource: ref.read(userRemoteDataSourceProvider),
      authService: ref.read(authServiceProvider));
});

final petRepositoryProvider = Provider.autoDispose<PetRepository>((ref) {
  return PetRepositoryImpl(
      petRemoteDataSource: ref.read(petRemoteDataSourceProvider),
      authService: ref.read(authServiceProvider));
});
final vaccineRepositoryProvider =
    Provider.autoDispose<VaccineRepository>((ref) {
  return VaccineRepositoryImpl(
      vaccineRemoteDataSource: ref.read(vaccineRemoteDataSourceProvider),
      authService: ref.read(authServiceProvider));
});

final serviceRepositoryProvider =
    Provider.autoDispose<ServiceRepository>((ref) {
  return ServiceRepositoryImpl(
      serviceRemoteDataSource: ref.read(serviceRemoteDataSourceProvider),
      authService: ref.read(authServiceProvider));
});

final petOwnerProvider = Provider.autoDispose<PetOwnerDetail>((ref) {
  return PetOwnerDetail(ref.read(petOwnerRepositoryProvider));
});

final authRepositoryProvider = Provider.autoDispose<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.read(authRemoteDataSourceProvider),
    authService: ref.read(authServiceProvider),
  );
});

final registerAccountProvider = Provider.autoDispose<RegisterAccount>((ref) {
  return RegisterAccount(ref.read(authRepositoryProvider));
});

final petAccountProvider = Provider.autoDispose<PetAccount>((ref) {
  return PetAccount(ref.read(petRepositoryProvider));
});
final vaccineHistoryProvider = Provider.autoDispose<VaccineHistoryPet>((ref) {
  return VaccineHistoryPet(ref.read(vaccineRepositoryProvider));
});
final addVaccineProvider = Provider.autoDispose<AddVaccine>((ref) {
  return AddVaccine(ref.read(vaccineRepositoryProvider));
});
final deleteVaccineProvider = Provider.autoDispose<DeleteVaccine>((ref) {
  return DeleteVaccine(ref.read(vaccineRepositoryProvider));
});
final updateVaccineProvider = Provider.autoDispose<UpdateVaccine>((ref) {
  return UpdateVaccine(ref.read(vaccineRepositoryProvider));
});
final getVaccineDetailProvider = Provider.autoDispose<GetVaccineDetail>((ref) {
  return GetVaccineDetail(ref.read(vaccineRepositoryProvider));
});
final getAllStoreServiceByServiceIdProvider =
    Provider.autoDispose<GetAllStoreServiceByServiceId>((ref) {
  return GetAllStoreServiceByServiceId(ref.read(serviceRepositoryProvider));
});
final serviceTypeListProvider = Provider.autoDispose<ServiceTypeList>((ref) {
  return ServiceTypeList(ref.read(serviceRepositoryProvider));
});

final signupViewModelProvider =
    StateNotifierProvider.autoDispose<SignupViewmodel, AsyncValue<ApiResponse>>(
        (ref) {
  return SignupViewmodel(ref.read(registerAccountProvider));
});

final loginAccountProvider = Provider.autoDispose<LoginAccount>((ref) {
  return LoginAccount(ref.read(authRepositoryProvider));
});
final getStoreListProvider = Provider.autoDispose<GetStoreList>((ref) {
  return GetStoreList(ref.read(serviceRepositoryProvider));
});
final createBookingProvider = Provider.autoDispose<CreateBooking>((ref){
  return CreateBooking(ref.read(serviceRepositoryProvider));
});

final petInformationByIDProvider = Provider.autoDispose<PetInfoById>((ref) {
  return PetInfoById(ref.read(petRepositoryProvider));
});
final getStoreByIdProvider = Provider.autoDispose<GetStoreByID>((ref) {
  return GetStoreByID(ref.read(serviceRepositoryProvider));
});
final getStoreServiceByStoreIdProvider =
    Provider.autoDispose<GetStoreServiceByStoreID>((ref) {
  return GetStoreServiceByStoreID(ref.read(serviceRepositoryProvider));
});

final loginViewModelProvider =
    StateNotifierProvider.autoDispose<LoginViewmodel, AsyncValue<String?>>(
        (ref) {
  final loginAccount = ref.read(loginAccountProvider);
  return LoginViewmodel(loginAccount);
});
final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeViewModel, HomeState>((ref) {
  return HomeViewModel(ref.read(petOwnerProvider),
      ref.read(serviceTypeListProvider), ref.read(getStoreListProvider));
});
final petViewModelProvider =
    StateNotifierProvider.autoDispose<PetViewModel, PetState>((ref) {
  return PetViewModel(ref.read(petAccountProvider));
});
final userProfileViewModelProvider =
    StateNotifierProvider.autoDispose<UserProfileViewModel, UserProfileState>(
        (ref) {
  return UserProfileViewModel(ref.read(petOwnerProvider));
});
final storeDetailViewModelProvider = StateNotifierProvider.autoDispose
    .family<StoreDetailViewModel, StoreDetailState, int>((ref, id) {
  return StoreDetailViewModel(ref.read(getStoreByIdProvider),
      ref.read(getStoreServiceByStoreIdProvider), id);
});

final getPetCategoryProvider = Provider.autoDispose<GetPetCategory>((ref) {
  return GetPetCategory(ref.read(petRepositoryProvider));
});
final deletePetProvider = Provider.autoDispose<DeletePet>((ref) {
  return DeletePet(ref.read(petRepositoryProvider));
});

final petProfileViewModelProvider = StateNotifierProvider.autoDispose
    .family<PetProfileViewmodel, PetInfoState, int>((ref, id) {
  return PetProfileViewmodel(
      ref.read(petInformationByIDProvider),
      ref.read(deletePetProvider),
      id,
      ref.read(vaccineHistoryProvider),
      ref.read(addVaccineProvider),
      ref.read(deleteVaccineProvider),
      ref.read(getVaccineDetailProvider),
      ref.read(updateVaccineProvider));
});

final getPetTypeProvider = Provider.autoDispose<GetPetType>((ref) {
  return GetPetType(ref.read(petRepositoryProvider));
});
final addPetProvider = Provider.autoDispose<AddPet>((ref) {
  return AddPet(ref.read(petRepositoryProvider));
});
final updatePetProvider = Provider.autoDispose<UpdatePet>((ref) {
  return UpdatePet(ref.read(petRepositoryProvider));
});
final petInformationByIDProvider1 = Provider.autoDispose<PetInfoById>((ref) {
  return PetInfoById(ref.watch(petRepositoryProvider));
});

final petInfoProvider = StateNotifierProvider.autoDispose
    .family<PetInfoNotifier, AsyncValue<PetModel?>, int>(
  (ref, petId) {
    final getPetInfoById = ref.watch(petInformationByIDProvider1);
    return PetInfoNotifier(
      getPetInfoById: getPetInfoById,
      petId: petId,
    );
  },
);

final getBehaviorCategoryProvider =
    Provider.autoDispose<GetBehaviorCategory>((ref) {
  return GetBehaviorCategory(ref.read(petRepositoryProvider));
});
final petFormViewModelProvider =
    StateNotifierProvider.autoDispose<PetCategoryViewModel, AsyncValue<void>>(
        (ref) {
  return PetCategoryViewModel(
      getPetCategory: ref.read(getPetCategoryProvider),
      getPetType: ref.read(getPetTypeProvider),
      getBehaviorCategory: ref.read(getBehaviorCategoryProvider));
});
final bookingViewModelProvider = StateNotifierProvider.autoDispose.family<BookingViewModel, BookingState, int>((ref, serviceId) {
  final getAllStoreServiceByServiceId = ref.read(getAllStoreServiceByServiceIdProvider);
  final createBooking = ref.read(createBookingProvider);
  return BookingViewModel(getAllStoreServiceByServiceId,createBooking, serviceId);
});
final updatePetViewModelProvider =
    StateNotifierProvider<UpdatePetViewModel, AsyncValue<void>>(
  (ref) => UpdatePetViewModel(ref.read(updatePetProvider)),
);
final addPetViewModelProvider = StateNotifierProvider<AddPetViewModel, AsyncValue<void>>((ref) {
  // Injecting the dependencies (AddPet and PetAccount) into the ViewModel
  final addPet = ref.read(addPetProvider);
  final petAccount = ref.read(petAccountProvider);

  return AddPetViewModel(addPet: addPet, petAccount: petAccount);
});
