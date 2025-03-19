import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Thêm thư viện CachedNetworkImage
import '../../Data/data.dart';
import '../../Model/Movie.dart';
import 'movie_edit_screen.dart';

class MovieManagementScreen extends StatefulWidget {
  const MovieManagementScreen({Key? key}) : super(key: key);

  @override
  _MovieManagementScreenState createState() => _MovieManagementScreenState();
}

class _MovieManagementScreenState extends State<MovieManagementScreen> {
  String searchQuery = ""; // Chuỗi tìm kiếm phim
  final TextEditingController _searchController = TextEditingController();
  int selectedTab =
      0; // Chỉ số của tab được chọn (0: Phim đang chiếu, 1: Phim sắp chiếu)

  @override
  Widget build(BuildContext context) {
    // Lọc phim theo trạng thái
    List<Movie> showingNowMovies = _filterMovies(isShowingNow: true);
    List<Movie> comingSoonMovies = _filterMovies(isShowingNow: false);

    return Scaffold(
      appBar: AppBar(
        title: _buildSearchField(),
        centerTitle: true,
        backgroundColor: const Color(0xff252429),
        elevation: 0,
      ),
      backgroundColor: const Color(0xff252429),
      body: Column(
        children: [
          _buildTabBar(), // TabBar tùy chỉnh
          Expanded(
            child: selectedTab == 0
                ? _buildMovieList(showingNowMovies) // Tab "Phim đang chiếu"
                : _buildMovieList(comingSoonMovies), // Tab "Phim sắp chiếu"
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToEditScreen,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Tìm kiếm phim
  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => searchQuery = value),
      decoration: const InputDecoration(
        hintText: "Tìm kiếm phim...",
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
        suffixIcon: Icon(Icons.search, color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 18),
    );
  }

  // TabBar tùy chỉnh
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

  // Tab Button
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

  // Danh sách phim
  Widget _buildMovieList(List<Movie> movies) {
    return movies.isEmpty
        ? _buildNoMoviesMessage()
        : ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) => _buildMovieCard(movies[index]),
          );
  }

  // Thông báo nếu không có phim nào
  Widget _buildNoMoviesMessage() {
    return const Center(
      child: Text(
        "Không có phim nào!",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  // Card hiển thị phim
  Widget _buildMovieCard(Movie movie) {
    return GestureDetector(
      onTap: () => _navigateToEditScreen(movie: movie),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: movie.imagePath.isNotEmpty
                  ? (movie.imagePath.startsWith('http') ||
                          movie.imagePath.startsWith('https'))
                      ? CachedNetworkImage(
                          imageUrl: movie.imagePath,
                          width: 80,
                          height: 100,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )
                      : Image.file(
                          File(movie.imagePath),
                          width: 80,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                  : const Icon(Icons.image, size: 80, color: Colors.grey),
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
            Column(
              children: [
                // Nút xóa
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteMovie(movie.id),
                ),
                // Nút chỉnh sửa
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: () {
                    // Chuyển hướng đến màn hình chỉnh sửa phim
                    _navigateToEditScreen(movie: movie);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Hàm lọc phim theo trạng thái
  List<Movie> _filterMovies({required bool isShowingNow}) {
    return movies.where((movie) {
      bool matchesSearch = searchQuery.isEmpty ||
          movie.title.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesSearch && movie.isShowingNow == isShowingNow;
    }).toList();
  }

  void _refreshMovies() {
    setState(() {
      // Reset search query
      searchQuery = "";
      _searchController.clear();
    });

    // Hiển thị thông báo thành công
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cập nhật thành công!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Cập nhật hàm xóa phim
  void _deleteMovie(String id) {
    setState(() {
      movies.removeWhere((movie) => movie.id == id);
    });
    _refreshMovies(); // Refresh sau khi xóa
  }

  // Cập nhật hàm điều hướng đến MovieEditScreen
  void _navigateToEditScreen({Movie? movie}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieEditScreen(
          isEdit: movie != null,
          movie: movie,
        ),
      ),
    );

    // Cập nhật UI khi có kết quả trả về
    if (result != null) {
      setState(() {
        // Nếu đang ở tab không có phim vừa thêm/sửa, chuyển sang tab có phim đó
        if (result is Movie) {
          if (result.isShowingNow && selectedTab != 0) {
            selectedTab = 0;
          } else if (!result.isShowingNow && selectedTab != 1) {
            selectedTab = 1;
          }
        }
      });
      _refreshMovies(); // Refresh sau khi thêm/sửa
    }
  }
}
