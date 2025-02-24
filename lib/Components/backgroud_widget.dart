import 'package:flutter/material.dart';
import '../Model/Movie.dart';

class BackgroundWidget extends StatelessWidget {
  final PageController controller;
  final List<Movie> movies; // Nhận danh sách phim từ HomeScreen

  const BackgroundWidget({
    required this.controller,
    required this.movies, // Nhận danh sách phim
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      reverse: true,
      physics: NeverScrollableScrollPhysics(),
      controller: controller,
      itemCount: movies.length, // Sử dụng danh sách phim từ HomeScreen
      itemBuilder: (context, index) {
        final Movie movie = movies[index];
        return buildBackground(movie);
      },
    );
  }

  Widget buildBackground(Movie movie) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            movie.imagePath,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.15, 0.75],
              colors: [
                Color.fromARGB(255, 0, 0, 0).withOpacity(0.0001),
                Color.fromARGB(255, 0, 0, 0),
              ],
            ),
          ),
        )
      ],
    );
  }
}
