import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/fluffypaw_logo.svg',
              width: 120,
              height: 120,
            ),
            SizedBox(height: 40),
            LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.pink,
              size: 60,
            ),
            SizedBox(height: 20),
            Text(
              'Đang tải dữ liệu...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
