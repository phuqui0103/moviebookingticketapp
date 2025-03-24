import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movieticketbooking/Model/User.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tạo user mới
  Future<void> createUser(User user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());
    } catch (e) {
      print('Error creating user: $e');
      throw e;
    }
  }

  // Lấy thông tin user theo ID
  Future<User?> getUserById(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return User.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      throw e;
    }
  }

  // Cập nhật thông tin user
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      print('Error updating user: $e');
      throw e;
    }
  }

  // Xóa user
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      print('Error deleting user: $e');
      throw e;
    }
  }

  // Lấy danh sách tất cả users
  Stream<List<User>> getAllUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return User.fromJson(doc.data());
      }).toList();
    });
  }

  // Kiểm tra email đã tồn tại chưa
  Future<bool> isEmailExists(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking email: $e');
      throw e;
    }
  }

  // Kiểm tra số điện thoại đã tồn tại chưa
  Future<bool> isPhoneNumberExists(String phoneNumber) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking phone number: $e');
      throw e;
    }
  }
}
