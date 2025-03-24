import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movieticketbooking/Model/Ticket.dart';

class TicketService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tạo vé mới
  Future<void> createTicket(Ticket ticket) async {
    try {
      await _firestore
          .collection('tickets')
          .doc(ticket.id)
          .set(ticket.toJson());
    } catch (e) {
      print('Error creating ticket: $e');
      throw e;
    }
  }

  // Lấy thông tin vé theo ID
  Future<Ticket?> getTicketById(String ticketId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('tickets').doc(ticketId).get();
      if (doc.exists) {
        return Ticket.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting ticket: $e');
      throw e;
    }
  }

  // Cập nhật thông tin vé
  Future<void> updateTicket(String ticketId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('tickets').doc(ticketId).update(data);
    } catch (e) {
      print('Error updating ticket: $e');
      throw e;
    }
  }

  // Xóa vé
  Future<void> deleteTicket(String ticketId) async {
    try {
      await _firestore.collection('tickets').doc(ticketId).delete();
    } catch (e) {
      print('Error deleting ticket: $e');
      throw e;
    }
  }

  // Lấy danh sách tất cả vé
  Stream<List<Ticket>> getAllTickets() {
    return _firestore.collection('tickets').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Ticket.fromJson(doc.data());
      }).toList();
    });
  }

  // Lấy danh sách vé theo người dùng
  Stream<List<Ticket>> getTicketsByUser(String userId) {
    return _firestore
        .collection('tickets')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Ticket.fromJson(doc.data());
      }).toList();
    });
  }

  // Lấy danh sách vé theo lịch chiếu
  Stream<List<Ticket>> getTicketsByShowtime(String showtimeId) {
    return _firestore
        .collection('tickets')
        .where('showtimeId', isEqualTo: showtimeId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Ticket.fromJson(doc.data());
      }).toList();
    });
  }

  // Lấy danh sách vé theo trạng thái
  Stream<List<Ticket>> getTicketsByStatus(String status) {
    return _firestore
        .collection('tickets')
        .where('status', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Ticket.fromJson(doc.data());
      }).toList();
    });
  }
}
