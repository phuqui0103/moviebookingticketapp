import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movieticketbooking/Model/Cinema.dart';

class CinemaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tạo rạp mới
  Future<void> createCinema(Cinema cinema) async {
    try {
      await _firestore
          .collection('cinemas')
          .doc(cinema.id)
          .set(cinema.toJson());
    } catch (e) {
      print('Error creating cinema: $e');
      throw e;
    }
  }

  // Lấy thông tin rạp theo ID
  Future<Cinema?> getCinemaById(String cinemaId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('cinemas').doc(cinemaId).get();
      if (doc.exists) {
        return Cinema.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting cinema: $e');
      throw e;
    }
  }

  // Cập nhật thông tin rạp
  Future<void> updateCinema(String cinemaId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('cinemas').doc(cinemaId).update(data);
    } catch (e) {
      print('Error updating cinema: $e');
      throw e;
    }
  }

  // Xóa rạp
  Future<void> deleteCinema(String cinemaId) async {
    try {
      await _firestore.collection('cinemas').doc(cinemaId).delete();
    } catch (e) {
      print('Error deleting cinema: $e');
      throw e;
    }
  }

  // Lấy danh sách tất cả rạp
  Stream<List<Cinema>> getAllCinemas() {
    return _firestore.collection('cinemas').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Cinema.fromJson(doc.data());
      }).toList();
    });
  }

  // Lấy danh sách rạp theo tỉnh/thành phố
  Stream<List<Cinema>> getCinemasByProvince(String province) {
    return _firestore
        .collection('cinemas')
        .where('province', isEqualTo: province)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Cinema.fromJson(doc.data());
      }).toList();
    });
  }

  // Lấy danh sách rạp theo quận/huyện
  Stream<List<Cinema>> getCinemasByDistrict(String district) {
    return _firestore
        .collection('cinemas')
        .where('district', isEqualTo: district)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Cinema.fromJson(doc.data());
      }).toList();
    });
  }
}
