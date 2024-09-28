
class UserProfileState {
  final String fullName;
  final String email;
  final bool isLoading;
  final String avatar;
  final String? errorMessage;
  final String userName;
  final String phone;
  final String address;

  UserProfileState({
    required this.fullName,
    required this.email,
    required this.isLoading,
    required this.avatar,
    this.errorMessage,
    required this.userName,
    required this.phone,
    required this.address
});
  factory UserProfileState.initial()=>UserProfileState(
    fullName: "User",
    email: "example@gmail.com",
    isLoading: false,
    errorMessage: null,
      avatar: "",
    userName: "user",
    phone: "phone",
    address: "address"

  );

  UserProfileState copyWith({
    String? fullName,
    String? email,
    bool? isLoading,
    String? errorMessage,
    String? avatar,
    String? userName,
    String? phone,
    String? address,
}){
    return UserProfileState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      avatar: avatar ?? this.avatar,
        userName: userName ?? this.userName,
      phone: phone ?? this.phone,
      address: address ?? this.address
    );
  }

}