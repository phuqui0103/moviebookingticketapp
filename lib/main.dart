import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movieticketbooking/Components/bottom_nav_bar.dart';
import 'package:movieticketbooking/View/admin/admin_main_screen.dart';
import 'package:movieticketbooking/View/user/movie_list_screen.dart';
import 'package:movieticketbooking/View/user/showtime_picker_screen.dart';
import 'package:movieticketbooking/View/user/home_screen.dart';
import 'package:movieticketbooking/View/user/login_screen.dart';
import 'package:movieticketbooking/View/user/register_screen.dart';
import 'package:movieticketbooking/View/splash_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Khởi tạo Firebase App Check
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Đặt Vé Xem Phim',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 26, color: Colors.grey),
          bodyMedium: TextStyle(
              fontSize: 18, color: const Color.fromARGB(255, 184, 49, 49)),
        ),
      ),
      //home: const LoginScreen(),

      home: const SplashScreen(),
      //home: AdminMainScreen(),
    );
  }
}
