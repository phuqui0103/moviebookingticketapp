import 'package:flutter/material.dart';
import 'package:movieticketbooking/View/home_screen.dart';
import 'package:movieticketbooking/View/login_screen.dart';
import 'package:movieticketbooking/View/movie_list_screen.dart';
import 'package:movieticketbooking/View/RegisterScreen.dart';
import 'package:movieticketbooking/View/showtime_picker_screen.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;
  bool isBottomNavBarVisible = true; // Biến để kiểm tra hiển thị BottomNavBar
  final List<Widget> pages = [
    HomeScreen(),
    MovieListScreen(),
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
          height: 220, // Chiều cao của modal
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Chọn cách mua vé',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                  ),
                ),
              ),
              SizedBox(height: 20),
              buildTicketOption(
                icon: Icons.movie,
                text: 'Mua vé theo phim',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieListScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              buildTicketOption(
                icon: Icons.theater_comedy,
                text: 'Mua vé theo rạp',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieListScreen(),
                    ),
                  );
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

    // Xác định nếu đang ở các trang Login hoặc Register thì ẩn BottomNavBar
    if (currentIndex == 1 ||
        currentIndex == 2 ||
        currentIndex == 3 ||
        currentIndex == 4) {
      isBottomNavBarVisible = false;
    } else {
      isBottomNavBarVisible = true;
    }

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
            child: Visibility(
              visible:
                  isBottomNavBarVisible, // Điều chỉnh trạng thái visibility
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            // Để chiều cao của Column chỉ đủ cho nội dung
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setBottomBarIndex(1);
                                },
                                child: Container(
                                  child: Image.asset(
                                    'assets/icons/film.png', // Đường dẫn đến hình ảnh của bạn
                                    height: 35.0, // Chiều cao của hình ảnh
                                    width: 35.0, // Chiều rộng của hình ảnh
                                    color: currentIndex == 1
                                        ? Colors.orangeAccent
                                        : Colors
                                            .black, // Thay đổi màu sắc nếu cần
                                  ),
                                ),
                              ),
                              Text(
                                'Phim', // Nhãn phía dưới
                                style: TextStyle(
                                  fontSize: 14,
                                  color: currentIndex == 1
                                      ? Colors.orangeAccent
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 80),
                            child: Column(
                              mainAxisSize: MainAxisSize
                                  .min, // Để chiều cao của Column chỉ đủ cho nội dung
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setBottomBarIndex(2);
                                  },
                                  child: Container(
                                    child: Image.asset(
                                      'assets/icons/sale.png', // Đường dẫn đến hình ảnh của bạn
                                      height: 35.0, // Chiều cao của hình ảnh
                                      width: 35.0, // Chiều rộng của hình ảnh
                                      color: currentIndex == 2
                                          ? Colors.orangeAccent
                                          : Colors
                                              .black, // Thay đổi màu sắc nếu cần
                                    ),
                                  ),
                                ),
                                Text(
                                  'Ưu đãi', // Nhãn phía dưới
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: currentIndex == 2
                                        ? Colors.orangeAccent
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize
                                .min, // Để chiều cao của Column chỉ đủ cho nội dung
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setBottomBarIndex(3);
                                },
                                child: Container(
                                  child: Image.asset(
                                    'assets/icons/theater.png', // Đường dẫn đến hình ảnh của bạn
                                    height: 35.0, // Chiều cao của hình ảnh
                                    width: 35.0, // Chiều rộng của hình ảnh
                                    color: currentIndex == 3
                                        ? Colors.orangeAccent
                                        : const Color.fromARGB(255, 0, 0,
                                            0), // Thay đổi màu sắc nếu cần
                                  ),
                                ),
                              ),
                              Text(
                                'Rạp', // Nhãn phía dưới
                                style: TextStyle(
                                  fontSize: 14,
                                  color: currentIndex == 3
                                      ? Colors.orangeAccent
                                      : const Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize
                                .min, // Để chiều cao của Column chỉ đủ cho nội dung
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setBottomBarIndex(4);
                                },
                                child: Container(
                                  child: Image.asset(
                                    'assets/icons/myticket.png', // Đường dẫn đến hình ảnh của bạn
                                    height: 35.0, // Chiều cao của hình ảnh
                                    width: 35.0, // Chiều rộng của hình ảnh
                                    color: currentIndex == 4
                                        ? Colors.orangeAccent
                                        : Colors
                                            .black, // Thay đổi màu sắc nếu cần
                                  ),
                                ),
                              ),
                              Text(
                                'Vé', // Nhãn phía dưới
                                style: TextStyle(
                                  fontSize: 14,
                                  color: currentIndex == 4
                                      ? Colors.orangeAccent
                                      : const Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
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
      ..color = Colors.orange
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

Widget buildTicketOption(
    {required IconData icon,
    required String text,
    required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orangeAccent, size: 28),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.orangeAccent, size: 20),
        ],
      ),
    ),
  );
}
