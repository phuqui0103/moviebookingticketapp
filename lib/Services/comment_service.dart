import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movieticketbooking/Model/Comment.dart';
import 'package:movieticketbooking/Model/User.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tạo bình luận mới
  Future<void> createComment(Comment comment) async {
    try {
      print('Creating comment with data:'); // Debug log
      print('ID: ${comment.id}'); // Debug log
      print('MovieID: ${comment.movieId}'); // Debug log
      print('Content: ${comment.content}'); // Debug log
      print('CreatedAt: ${comment.createdAt}'); // Debug log

      final commentData = {
        'id': comment.id,
        'userId': comment.userId,
        'movieId': comment.movieId,
        'content': comment.content,
        'createdAt': Timestamp.fromDate(comment.createdAt),
        'rating': comment.rating,
      };

      print('Saving comment data to Firestore: $commentData'); // Debug log

      await _firestore.collection('comments').doc(comment.id).set(commentData);

      print('Comment saved successfully'); // Debug log
    } catch (e) {
      print('Error creating comment: $e'); // Debug log
      throw e;
    }
  }

  // Lấy thông tin bình luận theo ID
  Future<Comment?> getCommentById(String commentId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('comments').doc(commentId).get();
      if (doc.exists) {
        return Comment.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting comment: $e');
      throw e;
    }
  }

  // Cập nhật thông tin bình luận
  Future<void> updateComment(
      String commentId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('comments').doc(commentId).update(data);
    } catch (e) {
      print('Error updating comment: $e');
      throw e;
    }
  }

  // Xóa bình luận
  Future<void> deleteComment(String commentId) async {
    try {
      await _firestore.collection('comments').doc(commentId).delete();
    } catch (e) {
      print('Error deleting comment: $e');
      throw e;
    }
  }

  // Lấy danh sách tất cả bình luận
  Stream<List<Comment>> getAllComments() {
    return _firestore.collection('comments').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Comment.fromMap(doc.data());
      }).toList();
    });
  }

  // Lấy danh sách bình luận theo phim
  Stream<List<Comment>> getCommentsByMovie(String movieId) {
    print('Fetching comments for movie: $movieId');
    return _firestore
        .collection('comments')
        .where('movieId', isEqualTo: movieId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      print('Received ${snapshot.docs.length} comments from Firestore');
      final comments = <Comment>[];
      for (var doc in snapshot.docs) {
        try {
          print('Processing comment data: ${doc.data()}');
          comments.add(Comment.fromMap(doc.data()));
        } catch (e) {
          print('Error parsing comment ${doc.id}: $e');
          // Skip invalid comments instead of breaking the entire stream
          continue;
        }
      }
      return comments;
    });
  }

  // Lấy danh sách bình luận theo người dùng
  Stream<List<Comment>> getCommentsByUser(String userId) {
    return _firestore
        .collection('comments')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Comment.fromMap(doc.data());
      }).toList();
    });
  }

  // Lấy danh sách bình luận mới nhất
  Stream<List<Comment>> getLatestComments({int limit = 10}) {
    return _firestore
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Comment.fromMap(doc.data());
      }).toList();
    });
  }

  // Lấy thông tin người dùng cho một comment
  Future<User?> getUserForComment(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return User.fromJson(userDoc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user for comment: $e');
      return null;
    }
  }
}
