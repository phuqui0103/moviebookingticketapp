import 'package:flutter/material.dart';
import '../Model/Movie.dart';
import '../View/user/movie_detail_screen.dart';

class MovieCardWidget extends StatelessWidget {
  final Movie movie;

  const MovieCardWidget({
    required this.movie,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          // Điều hướng đến trang MovieDetailScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailScreen(movie: movie),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(3),
            child: Column(
              children: [
                Expanded(child: buildImage(movie: movie)),
                const SizedBox(height: 8),
                Text(
                  movie.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.orangeAccent,
                  ),
                ),
                const SizedBox(height: 8),
                buildReleaseDateAndDuration(movie: movie),
                const SizedBox(height: 8),
                buildGenre(movie: movie),
                const SizedBox(height: 8),
                buildRating(movie: movie),
              ],
            ),
          ),
        ),
      );

  Widget buildImage({required Movie movie}) => Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(movie.imagePath, fit: BoxFit.cover),
        ),
      );

  Widget buildReleaseDateAndDuration({required Movie movie}) =>
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        buildTag(movie.releaseDate),
        const SizedBox(width: 10),
        buildTag(movie.duration),
      ]);

  Widget buildGenre({required Movie movie}) =>
      buildTag(movie.genres.map((genre) => genre.name).join(" | "));

  Widget buildRating({required Movie movie}) => buildTagWithIcon(
        text: movie.rating.toStringAsFixed(1),
        icon: Icons.star,
      );

  Widget buildTag(String text) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orangeAccent),
          borderRadius: BorderRadius.circular(15),
          color: Colors.black54,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Text(
          text,
          style: const TextStyle(color: Colors.orangeAccent, fontSize: 14),
        ),
      );

  Widget buildTagWithIcon({required String text, required IconData icon}) =>
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orangeAccent),
          borderRadius: BorderRadius.circular(15),
          color: Colors.black54,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
            const SizedBox(width: 5),
            Icon(icon, size: 18, color: Colors.orangeAccent),
          ],
        ),
      );
}
