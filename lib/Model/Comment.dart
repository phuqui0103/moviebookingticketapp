/// 🔹 Model bình luận của người dùng
class Comment {
  final String userName; // Tên người dùng
  final String content; // Nội dung bình luận
  final double rating; // Điểm đánh giá của người dùng

  const Comment({
    required this.userName,
    required this.content,
    required this.rating,
  });

  /// Chuyển đổi từ JSON sang Comment object
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      userName: json['userName'] as String,
      content: json['content'] as String,
      rating: (json['rating'] as num).toDouble(),
    );
  }

  /// Chuyển đổi từ Comment object sang JSON
  Map<String, dynamic> toJson() => {
        'userName': userName,
        'content': content,
        'rating': rating,
      };
}
