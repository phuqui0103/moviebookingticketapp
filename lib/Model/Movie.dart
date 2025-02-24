class Movie {
  final String title; // Tên phim
  final String imagePath; // Đường dẫn ảnh
  final String duration; // Thời lượng phim
  final String genre; // Thể loại phim
  final double rating; // Điểm đánh giá IMDb
  final bool isShowingNow; // True: Đang chiếu | False: Sắp chiếu

  // Constructor đầy đủ
  Movie({
    required this.title,
    required this.imagePath,
    required this.duration,
    required this.genre,
    required this.rating,
    required this.isShowingNow,
  });

  // Chuyển đổi từ JSON sang Movie object
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      imagePath: json['imagePath'],
      duration: json['duration'],
      genre: json['genre'],
      rating: (json['rating'] as num).toDouble(),
      isShowingNow: json['isShowingNow'],
    );
  }

  // Chuyển đổi từ Movie object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imagePath': imagePath,
      'duration': duration,
      'genre': genre,
      'rating': rating,
      'isShowingNow': isShowingNow,
    };
  }
}
