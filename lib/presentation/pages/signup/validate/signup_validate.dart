class SignupValidate{

  SignupValidate();

  String? validateSignUpInputs(String userName, String passWord, String confirmPassword, String fullName ) {
    // Add validation logic here
    Map<String, String> fields = {
      'Username' : userName,
      'Password' : passWord,
      'Confirm Password' : confirmPassword,
      'Full Name' : fullName
    };
    for ( var entry in fields.entries) {
      if(entry.value.isEmpty){
        return '${entry.key} không được bỏ trống';
      }
    }
    if (passWord != confirmPassword){
      return 'Password và Confirm Password không khớp';
    }

    return null;
  }
  bool validateSignUpPhoneInput(String phone){
    return phone.isNotEmpty;
  }
}
