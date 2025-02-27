import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../Components/movie_card_widget.dart';
import '../Components/backgroud_widget.dart';
import '../Data/data.dart';
import 'login_screen.dart';
import 'movie_list_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController controller = PageController();
  final TextEditingController _searchController = TextEditingController();
  bool isLoggined = false;
  bool checkUserLoginStatus() {
    // Giả sử lấy trạng thái từ SharedPreferences
    return isLoggined ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách phim chỉ lấy phim đang chiếu
    final showingMovies = movies.where((movie) => movie.isShowingNow).toList();

    return Scaffold(
      body: Stack(
        children: [
          BackgroundWidget(
            controller: controller,
            movies: showingMovies,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 12.0, right: 12.0, top: 50.0, bottom: 8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.end, // Đưa tất cả về bên phải
                    children: [
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // Hình tròn
                          border: Border.all(
                              color: Colors.orange, width: 1.5), // Viền cam
                        ),
                        padding:
                            EdgeInsets.all(1), // Khoảng cách giữa icon và viền
                        child: Center(
                          // Căn icon vào giữa hình tròn
                          child: IconButton(
                            icon: Icon(Icons.notifications,
                                color: Colors.orange, size: 24),
                            onPressed: () {
                              // TODO: Thêm chức năng thông báo
                            },
                            padding:
                                EdgeInsets.zero, // Loại bỏ padding mặc định
                            constraints: BoxConstraints(), // Giữ icon nhỏ gọn
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 60,
                        child: GestureDetector(
                          onTap: () {
                            // Kiểm tra trạng thái đăng nhập
                            bool isLoggedIn =
                                checkUserLoginStatus(); // Hàm kiểm tra đăng nhập
                            if (isLoggedIn) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileScreen()), // Màn hình hồ sơ
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LoginScreen()), // Màn hình đăng nhập
                              );
                            }
                          },
                          child: Center(
                            child: Image.asset(
                              "assets/icons/user.png",
                              height: 40,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  if (showingMovies.isNotEmpty)
                    CarouselSlider(
                      items: showingMovies
                          .map((movie) => MovieCardWidget(movie: movie))
                          .toList(),
                      options: CarouselOptions(
                        enableInfiniteScroll: true,
                        viewportFraction: 0.75,
                        height: MediaQuery.of(context).size.height * 0.7,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          controller.animateToPage(
                            index,
                            duration: const Duration(seconds: 1),
                            curve: Curves.ease,
                          );
                        },
                      ),
                    )
                  else
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "Hiện tại không có phim nào đang chiếu!",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
