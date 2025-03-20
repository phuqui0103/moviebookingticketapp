import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../../Components/movie_card_widget.dart';
import '../../Components/backgroud_widget.dart';
import '../../Data/data.dart';
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
