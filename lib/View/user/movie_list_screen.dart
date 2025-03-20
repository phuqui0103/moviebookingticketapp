import 'package:flutter/material.dart';
import 'package:movieticketbooking/Components/bottom_nav_bar.dart';
import 'package:movieticketbooking/View/user/movie_detail_screen.dart';
import '../../Data/data.dart' as app_data;
import '../../Model/Movie.dart';
import '../../Model/Genre.dart';

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  int selectedTab = 0;
  Genre? selectedGenre;
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  List<Genre> genres = [];

  @override
  void initState() {
    super.initState();
    _loadGenres();
  }

  void _loadGenres() {
    setState(() {
      genres = app_data.genres;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Movie> filteredMovies = _filterMovies();

    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: const Color(0xff252429),
      body: Column(
        children: [
          _buildTabBar(),
          const SizedBox(height: 16),
          _buildGenreFilter(),
          const SizedBox(height: 16),
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
      backgroundColor: const Color(0xff252429),
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
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        prefixIcon: const Icon(Icons.search, color: Colors.white70),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTabButton("Phim đang chiếu", 0),
          const SizedBox(width: 80),
          _buildTabButton("Phim sắp chiếu", 1),
        ],
      ),
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
              color: selectedTab == index ? Colors.orange : Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 3,
            width: 120,
            decoration: BoxDecoration(
              color: selectedTab == index ? Colors.orange : Colors.transparent,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreFilter() {
    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,
        itemBuilder: (context, index) => _buildGenreChip(genres[index]),
      ),
    );
  }

  Widget _buildGenreChip(Genre genre) {
    return GestureDetector(
      onTap: () => setState(() => selectedGenre = genre),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: selectedGenre?.id == genre.id
              ? Colors.orange
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: selectedGenre?.id == genre.id
                ? Colors.orange
                : Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Text(
          genre.name,
          style: TextStyle(
            color: selectedGenre?.id == genre.id ? Colors.black : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
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
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                movie.imagePath,
                width: 90,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      buildTag(movie.releaseDate),
                      const SizedBox(width: 8),
                      buildTag(movie.duration),
                    ],
                  ),
                  const SizedBox(height: 8),
                  buildTag(movie.genres.map((genre) => genre.name).join(" | ")),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
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
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      );

  List<Movie> _filterMovies() {
    return app_data.movies.where((movie) {
      bool matchesTab =
          selectedTab == 0 ? movie.isShowingNow : !movie.isShowingNow;

      bool matchesGenre = selectedGenre == null ||
          movie.genres.any((genre) => genre.id == selectedGenre?.id);

      bool matchesSearch = searchQuery.isEmpty ||
          movie.title.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesTab && matchesGenre && matchesSearch;
    }).toList();
  }
}
