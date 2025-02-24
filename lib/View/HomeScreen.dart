import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../Components/movie_card_widget.dart';
import '../Components/backgroud_widget.dart';
import '../Data/data.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController controller = PageController();
  final TextEditingController _searchController = TextEditingController();

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 50,
                        width: 60,
                        child: Center(
                          child: Image.asset(
                            "assets/icons/user.png",
                            height: 80,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: TextFormField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.search),
                                color: Colors.orangeAccent,
                              ),
                              border: InputBorder.none,
                              hintText: "Tìm kiếm phim...",
                              hintStyle: const TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 15.0,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.orange,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.orangeAccent,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  if (showingMovies.isNotEmpty)
                    CarouselSlider(
                      items: showingMovies
                          .map((movie) => MovieCardWidget(movie: movie))
                          .toList(),
                      options: CarouselOptions(
                        enableInfiniteScroll: false,
                        viewportFraction: 0.75,
                        height: MediaQuery.of(context).size.height * 0.7,
                        enlargeCenterPage: true,
                        onPageChanged: (index, _) => controller.animateToPage(
                          index,
                          duration: const Duration(seconds: 1),
                          curve: Curves.ease,
                        ),
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
