import 'Comment.dart';

class Movie {
  final String id;
  final String title; // Tên phim
  final String imagePath; // Đường dẫn ảnh
  final String trailerUrl; // Đường dẫn video trailer
  final String duration; // Thời lượng phim
  final List<String> genres; // Danh sách thể loại phim
  final double rating; // Điểm đánh giá IMDb
  final bool isShowingNow; // True: Đang chiếu | False: Sắp chiếu
  final String description; // Mô tả phim
  final List<String> cast; // Danh sách diễn viên
  final int reviewCount; // Số lượng đánh giá
  final String releaseDate; // Ngày công chiếu
  final String director; // Tên đạo diễn
  final List<Comment> comments; // Danh sách đánh giá từ người dùng

  /// Constructor với các tham số bắt buộc
  const Movie({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.trailerUrl, // Thêm đường dẫn video trailer
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

  /// Chuyển đổi từ JSON sang đối tượng Movie
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as String,
      title: json['title'] as String,
      imagePath: json['imagePath'] as String,
      trailerUrl: json['trailerUrl'] as String, // Lấy đường dẫn video từ JSON
      duration: json['duration'] as String,
      genres: List<String>.from(json['genres']),
      rating: (json['rating'] as num).toDouble(),
      isShowingNow: json['isShowingNow'] as bool,
      description: json['description'] as String,
      cast: List<String>.from(json['cast']),
      reviewCount: json['reviewCount'] as int,
      releaseDate: json['releaseDate'] as String,
      director: json['director'] as String,
      comments: (json['comments'] as List)
          .map((comment) => Comment.fromJson(comment))
          .toList(),
    );
  }

  /// Chuyển đổi từ đối tượng Movie sang JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'imagePath': imagePath,
        'trailerUrl': trailerUrl, // Xuất đường dẫn video trailer
        'duration': duration,
        'genres': genres,
        'rating': rating,
        'isShowingNow': isShowingNow,
        'description': description,
        'cast': cast,
        'reviewCount': reviewCount,
        'releaseDate': releaseDate,
        'director': director,
        'comments': comments.map((comment) => comment.toJson()).toList(),
      };
}
