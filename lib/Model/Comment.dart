import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id; // ID của bình luận
  final String userId; // ID của người dùng
  final String movieId; // ID của phim
  final String userName; // Tên người dùng
  final String content; // Nội dung bình luận
  final double rating; // Điểm đánh giá của người dùng
  final DateTime timestamp; // Thời gian bình luận

  const Comment({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.userName,
    required this.content,
    required this.rating,
    required this.timestamp,
  });

  /// Chuyển đổi từ JSON sang Comment object
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      userId: json['userId'] as String,
      movieId: json['movieId'] as String,
      userName: json['userName'] as String,
      content: json['content'] as String,
      rating: (json['rating'] as num).toDouble(),
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  /// Chuyển đổi từ Comment object sang JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'movieId': movieId,
        'userName': userName,
        'content': content,
        'rating': rating,
        'timestamp': Timestamp.fromDate(timestamp),
      };
}
