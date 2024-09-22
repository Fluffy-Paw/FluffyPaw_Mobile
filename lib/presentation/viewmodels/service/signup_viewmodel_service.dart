import 'package:fluffypawmobile/dependency_injection/dependency_injection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupViewmodelService {
  final WidgetRef ref;

  SignupViewmodelService(this.ref);

  Future<void> registerUser({
    required String phone,
    required String userName,
    required String password,
    required String confirmPassword,
    String? email,
    required String fullName,
    String? address,
    DateTime? dob,
    String? gender,
    required Function(String message) onError,
    required Function onSuccess,
  }) async {
    final signupViewModel = ref.read(signupViewModelProvider.notifier); // Đọc provider từ ref

    final result = await signupViewModel.register(
      phone,
      userName,
      password,
      confirmPassword,
      email,
      fullName,
      address,
      dob,
      gender,
    );
    result.fold(
          (failure) {
        onError(failure.message);
      },
          (account) {
        onSuccess();
      },
    );
  }
}