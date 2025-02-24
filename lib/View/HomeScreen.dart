import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../Components/backgroud_widget.dart';
import '../../Components/movie_card_widget.dart';
import '../../Data/data.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController controller = PageController();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundWidget(
              controller: controller), // Đặt BackgroundWidget ở dưới cùng
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
                            color: Colors.white,
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
                                onPressed: () {
                                  // Xử lý tìm kiếm ở đây
                                },
                                icon: const Icon(Icons.search),
                                color: Colors.white,
                              ),
                              border: InputBorder.none,
                              hintText: "Search Products",
                              hintStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.white24,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.white24,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                      height:
                          40), // Khoảng cách giữa thanh tìm kiếm và carousel
                  CarouselSlider(
                    items:
                        movies.map((e) => MovieCardWidget(movie: e)).toList(),
                    options: CarouselOptions(
                      enableInfiniteScroll: false,
                      viewportFraction: 0.75,
                      height: MediaQuery.of(context).size.height * 0.7,
                      enlargeCenterPage: true,
                      onPageChanged: (index, _) => controller.animateToPage(
                        index,
                        duration: Duration(seconds: 1),
                        curve: Curves.ease,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
