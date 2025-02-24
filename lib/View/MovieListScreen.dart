import 'package:flutter/material.dart';
import 'package:movieticketbooking/Components/bottom_nav_bar.dart';

import '../Data/data.dart';
import '../Model/Movie.dart';

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  int selectedTab = 0; // 0: Phim đang chiếu, 1: Phim sắp chiếu
  String selectedGenre = "Tất cả";

  final List<String> genres = ["Tất cả", "Action", "Sci-fi", "Fantasy"];

  @override
  Widget build(BuildContext context) {
    List<Movie> filteredMovies = movies
        .where((movie) {
          return (selectedTab == 0
                  ? movie.isShowingNow
                  : !movie.isShowingNow) &&
              (selectedGenre == "Tất cả" || movie.genre == selectedGenre);
        })
        .cast<Movie>()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Danh sách phim",
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255), // Màu chữ
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Căn giữa tiêu đề
        backgroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BottomNavBar())); // Quay lại màn hình trước
            //Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // TabBar Phim đang chiếu | Phim sắp chiếu
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTab = 0;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          "Phim đang chiếu",
                          style: TextStyle(
                            color:
                                selectedTab == 0 ? Colors.orange : Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4), // Khoảng cách với đường line
                        Container(
                          height: 3,
                          width: 120,
                          color: selectedTab == 0
                              ? Colors.orange
                              : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 60), // Khoảng cách giữa hai mục
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTab = 1;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          "Phim sắp chiếu",
                          style: TextStyle(
                            color:
                                selectedTab == 1 ? Colors.orange : Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2), // Khoảng cách với đường line
                        Container(
                          height: 3,
                          width: 120,
                          color: selectedTab == 1
                              ? Colors.orange
                              : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10), // Khoảng cách trước đường line chính
            ],
          ),

          const SizedBox(height: 10),

          // Danh sách thể loại (lọc)
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: genres.length,
              itemBuilder: (context, index) {
                return _buildGenreChip(genres[index]);
              },
            ),
          ),
          const SizedBox(height: 10),

          // Danh sách phim
          Expanded(
            child: filteredMovies.isEmpty
                ? const Center(
                    child: Text(
                      "Không có phim nào!",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredMovies.length,
                    itemBuilder: (context, index) {
                      final movie = filteredMovies[index];
                      return _buildMovieCard(movie);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Widget Tab Button
  Widget _buildTabButton(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: selectedTab == index ? Colors.orange : Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selectedTab == index ? Colors.black : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Widget Genre Chip
  Widget _buildGenreChip(String genre) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGenre = genre;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: selectedGenre == genre ? Colors.orange : Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          genre,
          style: TextStyle(
            color: selectedGenre == genre ? Colors.black : Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // Widget Movie Card
  Widget _buildMovieCard(Movie movie) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              movie.imagePath,
              width: 80,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  movie.duration,
                  style: TextStyle(color: Colors.grey[400]),
                ),
                const SizedBox(height: 4),
                Text(
                  movie.genre,
                  style: TextStyle(color: Colors.grey[400]),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.yellow, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      "${movie.rating}/10",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.orange),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
