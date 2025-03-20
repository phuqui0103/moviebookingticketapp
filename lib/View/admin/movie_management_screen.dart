import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Thêm thư viện CachedNetworkImage
import '../../Data/data.dart';
import '../../Model/Movie.dart';
import '../../Model/Genre.dart';
import 'movie_edit_screen.dart';

class MovieManagementScreen extends StatefulWidget {
  const MovieManagementScreen({Key? key}) : super(key: key);

  @override
  _MovieManagementScreenState createState() => _MovieManagementScreenState();
}

class _MovieManagementScreenState extends State<MovieManagementScreen> {
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    List<Movie> showingNowMovies = _filterMovies(isShowingNow: true);
    List<Movie> comingSoonMovies = _filterMovies(isShowingNow: false);

    return Scaffold(
      backgroundColor: const Color(0xff252429),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          const SizedBox(height: 16),
          Expanded(
            child: selectedTab == 0
                ? _buildMovieList(showingNowMovies)
                : _buildMovieList(comingSoonMovies),
          ),
        ],
      ),
      floatingActionButton: _buildAddButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xff252429),
      elevation: 0,
      title: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Tìm kiếm phim...",
            hintStyle: const TextStyle(color: Colors.white54),
            prefixIcon: const Icon(Icons.search, color: Colors.orange),
            suffixIcon: searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white54),
                    onPressed: () {
                      setState(() {
                        searchQuery = '';
                        _searchController.clear();
                      });
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          onChanged: (value) => setState(() => searchQuery = value),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(child: _buildTabButton("Phim đang chiếu", 0)),
          Expanded(child: _buildTabButton("Phim sắp chiếu", 1)),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white60,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildMovieList(List<Movie> movies) {
    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie_outlined,
                size: 64, color: Colors.white.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              "Không có phim nào!",
              style:
                  TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: movies.length,
      itemBuilder: (context, index) => _buildMovieCard(movies[index]),
    );
  }

  Widget _buildMovieCard(Movie movie) {
    // Lấy tên thể loại từ ID
    List<String> genreNames = movie.genres
        .map((genreId) => genres
            .firstWhere(
              (genre) => genre.id == genreId,
              orElse: () => Genre(id: "genreId", name: "Không rõ"),
            )
            .name)
        .toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: InkWell(
        onTap: () => _navigateToEditScreen(movie: movie),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Poster
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 100,
                  height: 140,
                  child: movie.imagePath.isNotEmpty
                      ? (movie.imagePath.startsWith('http'))
                          ? CachedNetworkImage(
                              imageUrl: movie.imagePath,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.black26,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error, color: Colors.orange),
                            )
                          : Image.file(
                              File(movie.imagePath),
                              fit: BoxFit.cover,
                            )
                      : Container(
                          color: Colors.black26,
                          child: const Icon(
                            Icons.movie,
                            size: 40,
                            color: Colors.orange,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              // Movie Info
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
                    // Thể loại
                    Text(
                      genreNames.join(" • "),
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Rating và Duration
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.orange,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${movie.rating}/10",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.access_time,
                          color: Colors.white70,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          movie.duration,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: movie.isShowingNow
                            ? Colors.green.withOpacity(0.2)
                            : Colors.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: movie.isShowingNow
                              ? Colors.green.withOpacity(0.5)
                              : Colors.blue.withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        movie.isShowingNow ? "Đang chiếu" : "Sắp chiếu",
                        style: TextStyle(
                          color:
                              movie.isShowingNow ? Colors.green : Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Action Buttons
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => _navigateToEditScreen(movie: movie),
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: Colors.orange,
                    ),
                    tooltip: 'Chỉnh sửa',
                  ),
                  IconButton(
                    onPressed: () => _showDeleteDialog(movie),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    tooltip: 'Xóa',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return FloatingActionButton.extended(
      onPressed: () => _navigateToEditScreen(),
      backgroundColor: Colors.orange,
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        "Thêm phim",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showDeleteDialog(Movie movie) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff252429),
        title: const Text(
          'Xóa phim',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Bạn có chắc muốn xóa phim "${movie.title}"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              _deleteMovie(movie.id);
              Navigator.pop(context);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
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
