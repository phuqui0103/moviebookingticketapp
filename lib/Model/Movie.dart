import 'Comment.dart';
import 'Genre.dart';

class Movie {
  final String id;
  final String title;
  final String imagePath;
  final String trailerUrl;
  final String duration;
  final List<Genre> genres;
  final double rating;
  final bool isShowingNow;
  final String description;
  final List<String> cast;
  final int reviewCount;
  final String releaseDate;
  final String director;
  final List<Comment> comments;

  const Movie({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.trailerUrl,
    required this.duration,
    required this.genres,
    required this.rating,
    required this.isShowingNow,
    required this.description,
    required this.cast,
    required this.reviewCount,
    required this.releaseDate,
    required this.director,
    required this.comments,
  });

  /// Chuyển từ JSON sang `Movie`
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? "",
      title: json['title'] ?? "Chưa có tên",
      imagePath: json['imagePath'] ?? "",
      trailerUrl: json['trailerUrl'] ?? "",
      duration: json['duration'] ?? "N/A",
      genres: (json['genres'] as List? ?? [])
          .map((genre) => Genre.fromJson(genre))
          .toList(),
      rating: (json['rating'] ?? 0).toDouble(),
      isShowingNow: json['isShowingNow'] ?? false,
      description: json['description'] ?? "Chưa có mô tả",
      cast: List<String>.from(json['cast'] ?? []),
      reviewCount: json['reviewCount'] ?? 0,
      releaseDate: json['releaseDate'] ?? "Chưa xác định",
      director: json['director'] ?? "Không rõ",
      comments: (json['comments'] as List? ?? [])
          .map((comment) => Comment.fromJson(comment))
          .toList(),
    );
  }

  /// Chuyển từ `Movie` sang JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'imagePath': imagePath,
        'trailerUrl': trailerUrl,
        'duration': duration,
        'genres': genres.map((genre) => genre.toJson()).toList(),
        'rating': rating,
        'isShowingNow': isShowingNow,
        'description': description,
        'cast': cast,
        'reviewCount': reviewCount,
        'releaseDate': releaseDate,
        'director': director,
        'comments': comments.map((comment) => comment.toJson()).toList(),
      };

  /// Cập nhật một phần dữ liệu của `Movie`
  Movie copyWith({
    String? id,
    String? title,
    String? imagePath,
    String? trailerUrl,
    String? duration,
    List<Genre>? genres,
    double? rating,
    bool? isShowingNow,
    String? description,
    List<String>? cast,
    int? reviewCount,
    String? releaseDate,
    String? director,
    List<Comment>? comments,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      trailerUrl: trailerUrl ?? this.trailerUrl,
      duration: duration ?? this.duration,
      genres: genres ?? this.genres,
      rating: rating ?? this.rating,
      isShowingNow: isShowingNow ?? this.isShowingNow,
      description: description ?? this.description,
      cast: cast ?? this.cast,
      reviewCount: reviewCount ?? this.reviewCount,
      releaseDate: releaseDate ?? this.releaseDate,
      director: director ?? this.director,
      comments: comments ?? this.comments,
    );
  }
}
