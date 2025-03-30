import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id; // ID của bình luận
  final String userId; // ID của người dùng
  final String movieId; // ID của phim
  final String userName; // Tên người dùng
  final String content; // Nội dung bình luận
  final double rating; // Điểm đánh giá của người dùng

  const Comment({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.userName,
    required this.content,
    required this.rating,
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
      };

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'movieId': movieId,
      'userName': userName,
      'content': content,
      'rating': rating,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      movieId: map['movieId'] ?? '',
      userName: map['userName'] ?? '',
      content: map['content'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
    );
  }
}
