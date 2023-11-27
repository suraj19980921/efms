import 'package:efms/Other/AppLocalizations.dart';
import 'package:efms/Authentication/ForgotPassword.dart';
import 'package:efms/Authentication/Login.dart';
import 'package:efms/Authentication/Register.dart';
import 'package:efms/Authentication/ResetPassword.dart';
import 'package:efms/Authentication/VerifyOtp.dart';
import 'package:efms/HomeScreen/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:efms/HomeScreen/SplashScreen.dart';
import 'package:efms/Authentication/ResetPassword.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EFMS',
      theme: ThemeData(primarySwatch: Colors.red),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale('hi'),
      supportedLocales: [Locale('en'), Locale('hi')],
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        // Define your routes here
        'login': (context) => const Login(),
        'register': (context) => const Register(),
        'forgot_password': (context) => const ForgotPassword(),
        'verify_otp': (context) => const VerifyOtp(),
        'home_page': (context) => const MainPage(),
        'reset_password': (context) => ResetPassword(),
      },
    );
  }
}
