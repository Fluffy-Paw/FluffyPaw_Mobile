import 'package:firebase_core/firebase_core.dart';
import 'package:fluffypawmobile/firebase_options.dart';
import 'package:fluffypawmobile/presentation/pages/Pet/pet_profile.dart';
import 'package:fluffypawmobile/presentation/pages/login/login_screen.dart';
import 'package:fluffypawmobile/presentation/pages/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluffypawmobile/presentation/pages/signup/phone_signup_screen.dart';

import 'presentation/pages/Pet/pet_form.dart';
import 'presentation/pages/home/home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Initialize with options
  );
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}