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
      physics: const NeverScrollableScrollPhysics(),
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
        // Background Image with Blur Effect
        Positioned.fill(
          child: ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.9),
                ],
              ).createShader(bounds);
            },
            blendMode: BlendMode.darken,
            child: Image.network(
              movie.imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        // Gradient Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.3, 0.7, 1.0],
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.9),
                ],
              ),
            ),
          ),
        ),
        // Animated Gradient Border
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.orange.withOpacity(0.1),
                  Colors.transparent,
                  Colors.orange.withOpacity(0.1),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
