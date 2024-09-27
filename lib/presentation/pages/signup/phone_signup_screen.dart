import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'component/custom_button.dart';
import 'component/custom_input_field.dart';
import 'verify_otp_screen.dart';

class PhoneSignupScreen extends StatelessWidget {
  final TextEditingController _phoneController = TextEditingController();

  Future<void> _submitPhoneNumber(BuildContext context) async {
    String phone = _phoneController.text.trim();
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.verifyPhoneNumber(
        phoneNumber:"+84"+phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Tính năng này chỉ hoạt động trên Android, bỏ qua cho iOS
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Verification failed: ${e.message}");
          if (e.code == 'invalid-phone-number') {
            print('Số điện thoại không hợp lệ.');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Số điện thoại không hợp lệ.'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          } else {
            print('Error code: ${e.code}');
            print('Error message: ${e.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Lỗi: ${e.message}'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          print("Verification code sent. VerificationId: $verificationId");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyOtpScreen(
                phone: phone,
                verificationId: verificationId,
              ),
            ),
          );
        },
        // Tắt tính năng auto-retrieval bằng cách đặt thời gian chờ rất ngắn
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Code auto-retrieval timeout: $verificationId");
        },
        // Đặt thời gian timeout rất ngắn để không sử dụng APNs
        timeout: Duration(seconds: 0),
      );
    } catch (e) {
      print("Error during phone verification: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xảy ra lỗi trong quá trình xác minh.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

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
                  if (_phoneController.text.isNotEmpty) {
                    _submitPhoneNumber(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Số điện thoại không được để trống.'),
                        backgroundColor: Colors.red,
                        duration: const Duration(milliseconds: 1500),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
