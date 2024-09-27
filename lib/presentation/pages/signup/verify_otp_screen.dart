import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluffypawmobile/presentation/pages/signup/user_details_screen.dart';
import 'package:flutter/material.dart';
import 'component/custom_button.dart';
import 'component/custom_input_field.dart';

class VerifyOtpScreen extends StatelessWidget {
  final String phone;
  final String verificationId; // Add verificationId here
  final TextEditingController _otpController = TextEditingController();

  VerifyOtpScreen({required this.phone, required this.verificationId});  // Accept verificationId

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify OTP'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24, 17, 24, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomInputField(
                  label: "Enter Your OTP",
                  hintText: "Enter your OTP sent to" + " "+ phone,
                  controller: _otpController,
                ),
                SizedBox(height: 40),
                CustomButton(
                  text: 'Verify',
                  onPressed: () async {
                    String smsCode = _otpController.text.trim();

                    // Create a PhoneAuthCredential with the code
                    PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: verificationId, // Use the verificationId here
                      smsCode: smsCode,
                    );

                    // Sign in using the credential
                    await FirebaseAuth.instance.signInWithCredential(credential).then((result) {
                      print("Successfully signed in with credential");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailsScreen(phone: phone),
                        ),
                      );
                    }).catchError((e) {
                      print("Error signing in: $e");
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
