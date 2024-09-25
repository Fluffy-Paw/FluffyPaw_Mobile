import 'dart:async';  // Thêm thư viện Timer
import 'package:fluffypawmobile/presentation/pages/on_boarding/onBoarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Tạo timer để dừng ở màn hình SplashScreen 3 giây rồi chuyển qua Onboarding
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Onboarding()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svg/fluffypaw_logo.svg',
                  width: 190,
                  height: 190,
                ),
                SizedBox(height: 16),
                Text(
                  'Fluffy Paw',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 36,
                    color: Color(0xFFF6C8E1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
