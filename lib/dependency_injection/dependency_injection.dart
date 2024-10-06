import 'package:fluffypawmobile/core/auth_service.dart';
import 'package:fluffypawmobile/data/datasources/abstract/auth_remote_data_source.dart';
import 'package:fluffypawmobile/data/datasources/abstract/pet_remote_data_source.dart';
import 'package:fluffypawmobile/data/datasources/abstract/user_remote_data_source.dart';
import 'package:fluffypawmobile/data/datasources/authRemoteDataSourceImpl.dart';
import 'package:fluffypawmobile/data/datasources/pet_remote_data_source_impl.dart';
import 'package:fluffypawmobile/data/datasources/user_remote_data_source_impl.dart';
import 'package:fluffypawmobile/data/models/api_response.dart';
import 'package:fluffypawmobile/data/repositories/auth_repository_impl.dart';
import 'package:fluffypawmobile/data/repositories/pet_owner_repository_impl.dart';
import 'package:fluffypawmobile/data/repositories/pet_repository_impl.dart';
import 'package:fluffypawmobile/domain/repositories/auth_repository.dart';
import 'package:fluffypawmobile/domain/repositories/pet_owner_repository.dart';
import 'package:fluffypawmobile/domain/repositories/pet_repository.dart';
import 'package:fluffypawmobile/domain/usecases/add_pet.dart';
import 'package:fluffypawmobile/domain/usecases/get_behavior_category.dart';
import 'package:fluffypawmobile/domain/usecases/get_pet_category.dart';
import 'package:fluffypawmobile/domain/usecases/get_pet_type.dart';
import 'package:fluffypawmobile/domain/usecases/login_account.dart';
import 'package:fluffypawmobile/domain/usecases/pet_account.dart';
import 'package:fluffypawmobile/domain/usecases/pet_info_by_id.dart';
import 'package:fluffypawmobile/domain/usecases/pet_owner_detail.dart';
import 'package:fluffypawmobile/domain/usecases/register_account.dart';
import 'package:fluffypawmobile/domain/usecases/update_pet.dart';
import 'package:fluffypawmobile/presentation/state/pet_info_state.dart';
import 'package:fluffypawmobile/presentation/state/pet_state.dart';
import 'package:fluffypawmobile/presentation/state/user_profile_state.dart';
import 'package:fluffypawmobile/presentation/viewmodels/add_pet_view_model.dart';
import 'package:fluffypawmobile/presentation/viewmodels/home_viewmodel.dart';
import 'package:fluffypawmobile/presentation/viewmodels/login_viewmodel.dart';
import 'package:fluffypawmobile/presentation/viewmodels/pet_form_view_model.dart';
import 'package:fluffypawmobile/presentation/viewmodels/pet_profile_viewmodel.dart';
import 'package:fluffypawmobile/presentation/viewmodels/pet_viewmodels.dart';
import 'package:fluffypawmobile/presentation/viewmodels/signup_viewmodel.dart';
import 'package:fluffypawmobile/presentation/viewmodels/update_pet_view_model.dart';
import 'package:fluffypawmobile/presentation/viewmodels/user_profile_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;



final httpClientProvider = Provider.autoDispose<http.Client>((ref) => http.Client());
final authServiceProvider = Provider.autoDispose<AuthService>((ref) {
  return AuthService();
});
final authRemoteDataSourceProvider = Provider.autoDispose<AuthRemoteDataSource>((ref) {
  return AuthRemoteDatasourceImpl(client: ref.read(httpClientProvider), authService: ref.read(authServiceProvider));
});

final userRemoteDataSourceProvider = Provider.autoDispose<UserRemoteDataSource>((ref){
  return UserRemoteDataSourceImpl(client: ref.read(httpClientProvider));
});

final petRemoteDataSourceProvider = Provider.autoDispose<PetRemoteDataSource>((ref){
  return  PetRemoteDataSourceImpl(client: ref.read(httpClientProvider));
});

final petOwnerRepositoryProvider = Provider.autoDispose<PetOwnerRepository>((ref){
  return PetOwnerRepositoryImpl(userRemoteDataSource: ref.read(userRemoteDataSourceProvider), authService: ref.read(authServiceProvider));
});

final petRepositoryProvider = Provider.autoDispose<PetRepository>((ref){
  return PetRepositoryImpl(petRemoteDataSource: ref.read(petRemoteDataSourceProvider), authService: ref.read(authServiceProvider));
});

final petOwnerProvider = Provider.autoDispose<PetOwnerDetail>((ref){
  return PetOwnerDetail(ref.read(petOwnerRepositoryProvider));
});




final authRepositoryProvider = Provider.autoDispose<AuthRepository>((ref) {
  return AuthRepositoryImpl(remoteDataSource: ref.read(authRemoteDataSourceProvider), authService: ref.read(authServiceProvider),);
});

final registerAccountProvider = Provider.autoDispose<RegisterAccount>((ref) {
  return RegisterAccount(ref.read(authRepositoryProvider));
});

final petAccountProvider = Provider.autoDispose<PetAccount>((ref){
  return PetAccount(ref.read(petRepositoryProvider));
});

final signupViewModelProvider = StateNotifierProvider.autoDispose<SignupViewmodel, AsyncValue<ApiResponse>>((ref) {
  return SignupViewmodel(ref.read(registerAccountProvider));
});

final loginAccountProvider = Provider.autoDispose<LoginAccount>((ref){
  return LoginAccount(ref.read(authRepositoryProvider));
});

final petInformationByIDProvider = Provider.autoDispose<PetInfoById>((ref){
  return PetInfoById(ref.read(petRepositoryProvider));
});

final loginViewModelProvider = StateNotifierProvider.autoDispose<LoginViewmodel, AsyncValue<String?>>((ref) {
  final loginAccount = ref.read(loginAccountProvider);
  return LoginViewmodel(loginAccount);
});
final homeViewModelProvider = StateNotifierProvider.autoDispose<HomeViewModel, HomeState>((ref) {
  return HomeViewModel(ref.read(petOwnerProvider));
});
final petViewModelProvider = StateNotifierProvider.autoDispose<PetViewModel, PetState>((ref){
  return PetViewModel(ref.read(petAccountProvider));
});
final userProfileViewModelProvider = StateNotifierProvider.autoDispose<UserProfileViewModel, UserProfileState>((ref){
  return UserProfileViewModel(ref.read(petOwnerProvider));
});

final petProfileViewModelProvider = StateNotifierProvider.autoDispose.family<PetProfileViewmodel, PetInfoState, int>((ref, id) {
  return PetProfileViewmodel(ref.read(petInformationByIDProvider), id);
});
final getPetCategoryProvider = Provider.autoDispose<GetPetCategory>((ref) {
  return GetPetCategory(ref.read(petRepositoryProvider));
});

final getPetTypeProvider = Provider.autoDispose<GetPetType>((ref) {
  return GetPetType(ref.read(petRepositoryProvider));
});
final addPetProvider = Provider.autoDispose<AddPet>((ref) {
  return AddPet(ref.read(petRepositoryProvider));
});
final updatePetProvider = Provider.autoDispose<UpdatePet>((ref){
  return UpdatePet(ref.read(petRepositoryProvider));
});


final getBehaviorCategoryProvider = Provider.autoDispose<GetBehaviorCategory>((ref) {
  return GetBehaviorCategory(ref.read(petRepositoryProvider));
});
final petFormViewModelProvider = StateNotifierProvider.autoDispose<PetCategoryViewModel, AsyncValue<void>>((ref) {
  return PetCategoryViewModel(
    getPetCategory: ref.read(getPetCategoryProvider),
    getPetType: ref.read(getPetTypeProvider),
    getBehaviorCategory: ref.read(getBehaviorCategoryProvider)
  );
});
final updatePetViewModelProvider = StateNotifierProvider<UpdatePetViewModel, AsyncValue<void>>(
      (ref) => UpdatePetViewModel(ref.read(updatePetProvider)),
);
final addPetViewModelProvider = StateNotifierProvider<AddPetViewModel, AsyncValue<void>>((ref) {
  final addPet = ref.read(addPetProvider);  // Sử dụng AddPet từ provider đã đăng ký
  return AddPetViewModel(addPet: addPet);  // Khởi tạo AddPetViewModel với AddPet
});






