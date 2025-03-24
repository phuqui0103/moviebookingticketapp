import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movieticketbooking/Model/Seat.dart';

class SeatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tạo ghế mới
  Future<void> createSeat(Seat seat) async {
    try {
      await _firestore.collection('seats').doc(seat.id).set(seat.toJson());
    } catch (e) {
      print('Error creating seat: $e');
      throw e;
    }
  }

  // Lấy thông tin ghế theo ID
  Future<Seat?> getSeatById(String seatId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('seats').doc(seatId).get();
      if (doc.exists) {
        return Seat.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting seat: $e');
      throw e;
    }
  }

  // Cập nhật thông tin ghế
  Future<void> updateSeat(String seatId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('seats').doc(seatId).update(data);
    } catch (e) {
      print('Error updating seat: $e');
      throw e;
    }
  }

  // Xóa ghế
  Future<void> deleteSeat(String seatId) async {
    try {
      await _firestore.collection('seats').doc(seatId).delete();
    } catch (e) {
      print('Error deleting seat: $e');
      throw e;
    }
  }

  // Lấy danh sách tất cả ghế
  Stream<List<Seat>> getAllSeats() {
    return _firestore.collection('seats').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Seat.fromJson(doc.data());
      }).toList();
    });
  }

  // Lấy danh sách ghế theo phòng chiếu
  Stream<List<Seat>> getSeatsByRoom(String roomId) {
    return _firestore
        .collection('seats')
        .where('roomId', isEqualTo: roomId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Seat.fromJson(doc.data());
      }).toList();
    });
  }

  // Lấy danh sách ghế theo loại
  Stream<List<Seat>> getSeatsByType(String type) {
    return _firestore
        .collection('seats')
        .where('type', isEqualTo: type)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Seat.fromJson(doc.data());
      }).toList();
    });
  }

  // Lấy danh sách ghế trống
  Stream<List<Seat>> getAvailableSeats() {
    return _firestore
        .collection('seats')
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Seat.fromJson(doc.data());
      }).toList();
    });
  }

  // Cập nhật trạng thái ghế
  Future<void> updateSeatStatus(String seatId, bool isAvailable) async {
    try {
      await _firestore.collection('seats').doc(seatId).update({
        'isAvailable': isAvailable,
      });
    } catch (e) {
      print('Error updating seat status: $e');
      throw e;
    }
  }
}
