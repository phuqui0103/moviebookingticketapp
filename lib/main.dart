import 'package:flutter/material.dart';
import 'package:movieticketbooking/Components/bottom_nav_bar.dart';
import 'package:movieticketbooking/View/admin/admin_main_screen.dart';
import 'package:movieticketbooking/View/user/movie_list_screen.dart';
import 'package:movieticketbooking/View/user/showtime_picker_screen.dart';
import 'package:movieticketbooking/View/user/home_screen.dart';
import 'package:movieticketbooking/View/user/login_screen.dart';
import 'package:movieticketbooking/View/user/RegisterScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      home: BottomNavBar(),
      //home: AdminMainScreen(),
    );
  }
}
