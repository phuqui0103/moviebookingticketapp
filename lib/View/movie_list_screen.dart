import 'package:flutter/material.dart';
import 'package:movieticketbooking/Components/bottom_nav_bar.dart';
import 'package:movieticketbooking/View/movie_detail_screen.dart';
import '../Data/data.dart';
import '../Model/Movie.dart';

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  int selectedTab = 0;
  String selectedGenre = "Tất cả";
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  final List<String> genres = [
    "Tất cả",
    "Tâm lý",
    "Tình cảm",
    "Hành động",
    "Tài liệu"
  ];

  @override
  Widget build(BuildContext context) {
    List<Movie> filteredMovies = _filterMovies();

    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          _buildTabBar(),
          const SizedBox(
            height: 10,
          ),
          _buildGenreFilter(),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: filteredMovies.isEmpty
                ? _buildNoMoviesMessage()
                : _buildMovieList(filteredMovies),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: _buildSearchField(),
      centerTitle: true,
      backgroundColor: Colors.black87,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavBar()),
        ),
      ),
    );
  }

  TextField _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => searchQuery = value),
      decoration: InputDecoration(
        hintText: "Tìm kiếm phim...",
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
        suffixIcon:
            Icon(Icons.search, color: Colors.white), // Đưa icon qua phải
      ),
      style: TextStyle(color: Colors.white, fontSize: 18),
    );
  }

  Widget _buildTabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTabButton("Phim đang chiếu", 0),
        const SizedBox(width: 70),
        _buildTabButton("Phim sắp chiếu", 1),
      ],
    );
  }

  Widget _buildTabButton(String title, int index) {
    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: selectedTab == index ? Colors.orange : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 3,
            width: 120,
            color: selectedTab == index ? Colors.orange : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildGenreFilter() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,
        itemBuilder: (context, index) => _buildGenreChip(genres[index]),
      ),
    );
  }

  Widget _buildGenreChip(String genre) {
    return GestureDetector(
      onTap: () => setState(() => selectedGenre = genre),
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

  Widget _buildNoMoviesMessage() {
    return const Center(
      child: Text("Không có phim nào!",
          style: TextStyle(color: Colors.white, fontSize: 16)),
    );
  }

  Widget _buildMovieList(List<Movie> movies) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) => _buildMovieCard(movies[index]),
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MovieDetailScreen(movie: movie)),
      ),
      child: Container(
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      buildTag(movie.releaseDate),
                      const SizedBox(width: 8),
                      buildTag(movie.duration),
                    ],
                  ),
                  const SizedBox(height: 6),
                  buildTag(movie.genres.join(", ")),
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
          ],
        ),
      ),
    );
  }

  Widget buildTag(String text) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
          borderRadius: BorderRadius.circular(10),
          color: Colors.black54,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        child: Text(
          text,
          style: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255), fontSize: 14),
        ),
      );

  List<Movie> _filterMovies() {
    return movies.where((movie) {
      bool matchesTab =
          (selectedTab == 0 ? movie.isShowingNow : !movie.isShowingNow);
      bool matchesGenre =
          selectedGenre == "Tất cả" || movie.genres.contains(selectedGenre);
      bool matchesSearch = searchQuery.isEmpty ||
          movie.title.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesTab && matchesGenre && matchesSearch;
    }).toList();
  }
}
