import 'package:fluffypawmobile/presentation/pages/signup/user_details_screen.dart';
import 'package:flutter/material.dart';
import 'component/custom_button.dart';
import 'component/custom_header.dart';
import 'component/custom_input_field.dart';

class VerifyOtpScreen extends StatelessWidget {
  final String phone;
  final TextEditingController _otpController = TextEditingController();

  VerifyOtpScreen({required this.phone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24, 17, 24, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomHeader(
                  title: 'Verify OTP',
                  onBackPress: () => Navigator.pop(context),
                ),

                CustomInputField(
                  label: "Enter Your OTP",
                  hintText: "Enter your OTP sent to" + " "+ phone,
                  controller: _otpController,
                ),
                SizedBox(height: 40),
                CustomButton(
                  text: 'Verify',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailsScreen(phone: phone),
                      ),
                    );
                  }
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
