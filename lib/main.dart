import 'package:flutter/material.dart';
import 'package:movieticketbooking/View/ShowtimePickerScreen.dart';
import 'package:movieticketbooking/View/HomeScreen.dart';
import 'package:movieticketbooking/View/LoginScreen.dart';
import 'package:movieticketbooking/View/RegisterScreen.dart';

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
          bodyMedium: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
      home: BottomNavBarV2(),
      //initialRoute: '/home',
      routes: {
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/details': (context) => Showtimepickerscreen(title: 'PhuQui')
      },
    );
  }
}

class BottomNavBarV2 extends StatefulWidget {
  @override
  _BottomNavBarV2State createState() => _BottomNavBarV2State();
}

class _BottomNavBarV2State extends State<BottomNavBarV2> {
  int currentIndex = 0;
  final List<Widget> pages = [
    HomeScreen(),
    LoginScreen(),
    RegisterScreen(),
  ];
  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

// Hàm hiển thị modal bottom sheet
  void _showPurchaseOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          height: 200, // Chiều cao của modal
          child: Column(
            children: [
              Text(
                'Chọn cách mua vé',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.movie),
                title: Text('Mua vé theo phim'),
                onTap: () {
                  // Xử lý hành động khi chọn "Mua vé theo phim"
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Showtimepickerscreen(
                              title: 'Ròm',
                            )),
                    // Thay thế bằng widget của bạn
                  ); // Đóng modal
                  // Chuyển đến trang mua vé theo phim
                },
              ),
              ListTile(
                leading: Icon(Icons.theater_comedy),
                title: Text('Mua vé theo rạp'),
                onTap: () {
                  // Xử lý hành động khi chọn "Mua vé theo rạp"
                  Navigator.pop(context); // Đóng modal
                  // Chuyển đến trang mua vé theo rạp
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          IndexedStack(
            index: currentIndex,
            children: pages,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: size.width,
              height: 80,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    size: Size(size.width, 80),
                    painter: BNBCustomPainter(),
                  ),
                  Center(
                    heightFactor: 0.6,
                    child: FloatingActionButton(
                      backgroundColor: Colors.orangeAccent,
                      child: Image.asset(
                        'assets/icons/buyticket.png',
                        height: 40.0,
                        width: 40.0,
                        fit: BoxFit.contain,
                      ),
                      elevation: 0.1,
                      onPressed: () {
                        _showPurchaseOptions();
                      },
                    ),
                  ),
                  Container(
                    width: size.width,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.home,
                            color: currentIndex == 0
                                ? Colors.orangeAccent
                                : Colors.white,
                          ),
                          onPressed: () {
                            setBottomBarIndex(0);
                          },
                          splashColor: Colors.white,
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.restaurant_menu,
                              color: currentIndex == 1
                                  ? Colors.orangeAccent
                                  : Colors.white,
                            ),
                            onPressed: () {
                              setBottomBarIndex(1);
                            }),
                        Container(
                          width: size.width * 0.20,
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.bookmark,
                              color: currentIndex == 2
                                  ? Colors.orangeAccent
                                  : Colors.white,
                            ),
                            onPressed: () {
                              setBottomBarIndex(2);
                            }),
                        IconButton(
                            icon: Icon(
                              Icons.notifications,
                              color: currentIndex == 3
                                  ? Colors.orangeAccent
                                  : Colors.white,
                            ),
                            onPressed: () {
                              setBottomBarIndex(3);
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = const Color.fromARGB(255, 197, 197, 197)
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
