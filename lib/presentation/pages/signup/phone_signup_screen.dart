import 'package:fluffypawmobile/presentation/pages/login/login_screen.dart';
import 'package:fluffypawmobile/presentation/pages/signup/component/or_divider.dart';
import 'package:fluffypawmobile/presentation/pages/signup/validate/signup_validate.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'component/custom_button.dart';
import 'component/custom_input_field.dart';
import 'verify_otp_screen.dart';

class PhoneSignupScreen extends StatelessWidget {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 17, 24, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CustomHeader(
              //   title: 'Sign Up',
              //   onBackPress: () => Navigator.pop(context),
              // ),

              CustomInputField(
                label: 'Phone Number',
                hintText: "Enter Your Phone Number",
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: 40),
              CustomButton(
                text: 'Continue',
                onPressed: () {
                  if(SignupValidate().validateSignUpPhoneInput(_phoneController.text)){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerifyOtpScreen(phone: _phoneController.text),
                      ),
                    );
                  }else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Số điện thoại không được để trống',
                            style: TextStyle(fontSize: 16), // Tăng kích thước chữ
                            textAlign: TextAlign.center, // Canh giữa nội dung
                          ),
                          backgroundColor: Colors.red, // Màu nền đỏ cho lỗi
                          duration: const Duration(milliseconds: 1500),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0, // Tăng padding trên dưới
                            horizontal: 20.0, // Tăng padding hai bên
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0), // Tăng độ bo góc
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 24.0), // Khoảng cách từ các cạnh màn hình
                        ),

                    );
                  }

                },
              ),

              SizedBox(height: 28),
              OrDivider(),
              SizedBox(height: 20),
              _buildLoginLink(
                context
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account?',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0xFF838383),
            ),
          ),
          TextButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LogIn(),
                ),
              );
            },
            child: Text(
              'Login',
              style: TextStyle(color: Color(0xFFF6C8E1)), // Color for the button text
            ),
          ),
        ],
      ),
    );
  }

}