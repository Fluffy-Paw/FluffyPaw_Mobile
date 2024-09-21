import 'package:fluffypawmobile/presentation/pages/signup/component/or_divider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'component/custom_button.dart';
import 'component/custom_header.dart';
import 'component/custom_input_field.dart';
import 'verify_otp_screen.dart';

class PhoneSignupScreen extends StatelessWidget {
  final TextEditingController _phoneController = TextEditingController();

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
                  title: 'Sign Up',
                  onBackPress: () => Navigator.pop(context),
                ),

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerifyOtpScreen(phone: _phoneController.text),
                      ),
                    );
                  },
                ),

                SizedBox(height: 28),
                OrDivider(),
                SizedBox(height: 20),
                _buildLoginLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xFF838383),
          ),
          children: [
            TextSpan(text: "Already have account? "),
            TextSpan(
              text: 'Login',
              style: TextStyle(color: Color(0xFF007DFC)),
            ),
          ],
        ),
      ),
    );
  }
}