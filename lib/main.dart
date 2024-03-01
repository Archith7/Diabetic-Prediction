//start date 6th October 2023
//end date 19th January 2024


// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ironman/common_widgets/theme.dart';
import 'package:ironman/forgot_pass.dart';
import 'package:ironman/splash_screen.dart';
import 'package:ironman/verify_email_otp.dart';
import 'package:ironman/verify_phone_otp.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'success_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Check if a user is already logged in
  // User? user = FirebaseAuth.instance.currentUser;

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        // '/': (context) => const HomePage(),
         '/': (context) => const App(),
        '/login': (context) => const LoginPage(),
        '/success': (context) => SuccessPage(),
        '/SignupPage': (context) => const SignupPage(),
        '/verify_phone_otp': (context) => VerifyPhoneOTPPage(),
        '/verify_email_otp':(context)=>VerifyEmailOTPPage(),
        '/forgotpass':(context)=>const ForgotPasswordPage(),
      },
    ),
  );
}

class App extends StatelessWidget {
  // final Widget initialScreen;

   const App({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      transitionDuration: const Duration(milliseconds: 500),
      home: const SplashScreen(),
      getPages: [
    GetPage(
      name: '/verify_email_otp',
      page: () => VerifyEmailOTPPage(),
    ),
    GetPage(
      name: '/verify_phone_otp',
      page: () => VerifyPhoneOTPPage(),
    ),
    ],
    );
  }
}