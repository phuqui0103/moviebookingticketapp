import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movieticketbooking/Model/Comment.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tạo bình luận mới
  Future<void> createComment(Comment comment) async {
    try {
      await _firestore
          .collection('comments')
          .doc(comment.id)
          .set(comment.toJson());
    } catch (e) {
      print('Error creating comment: $e');
      throw e;
    }
  }

  // Lấy thông tin bình luận theo ID
  Future<Comment?> getCommentById(String commentId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('comments').doc(commentId).get();
      if (doc.exists) {
        return Comment.fromJson(doc.data() as Map<String, dynamic>);
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
        return Comment.fromJson(doc.data());
      }).toList();
    });
  }

  // Lấy danh sách bình luận theo phim
  Stream<List<Comment>> getCommentsByMovie(String movieId) {
    return _firestore
        .collection('comments')
        .where('movieId', isEqualTo: movieId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Comment.fromJson(doc.data());
      }).toList();
    });
  }

  // Lấy danh sách bình luận theo người dùng
  Stream<List<Comment>> getCommentsByUser(String userId) {
    return _firestore
        .collection('comments')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Comment.fromJson(doc.data());
      }).toList();
    });
  }

  // Lấy danh sách bình luận mới nhất
  Stream<List<Comment>> getLatestComments({int limit = 10}) {
    return _firestore
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Comment.fromJson(doc.data());
      }).toList();
    });
  }
}
