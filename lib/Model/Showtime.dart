import 'package:intl/intl.dart';
import 'package:movieticketbooking/Model/Room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Showtime {
  final String id;
  final String movieId;
  final String cinemaId;
  final String roomId;
  final DateTime startTime;
  final List<String> bookedSeats;

  Showtime({
    required this.id,
    required this.movieId,
    required this.cinemaId,
    required this.roomId,
    required this.startTime,
    required this.bookedSeats,
  });

  // Getter để định dạng ngày giờ theo "dd/MM/yyyy HH:mm"
  String get formattedTime {
    return DateFormat('HH:mm').format(startTime);
  }

  String get formattedDate {
    return DateFormat('dd/MM/yyyy').format(startTime);
  }

  // Số ghế đã đặt
  int get bookedSeatsCount {
    return bookedSeats.length;
  }

  // Tính số ghế còn trống
  int get availableSeats {
    // Chỉ trả về số ghế đã đặt, giá trị âm không cần dùng với UI
    return bookedSeats.length;
  }

  // Phương thức để lấy thông tin phòng từ Firebase
  Future<Room?> getRoom() async {
    try {
      DocumentSnapshot roomDoc = await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .get();

      if (roomDoc.exists) {
        Map<String, dynamic> data = roomDoc.data() as Map<String, dynamic>;
        return Room(
          id: roomDoc.id,
          cinemaId: data['cinemaId'] ?? '',
          name: data['name'] ?? '',
          rows: data['rows'] ?? 0,
          cols: data['cols'] ?? 0,
          seatLayout: [], // Không cần thiết cho hiển thị
        );
      }
      return null;
    } catch (e) {
      print('Lỗi khi lấy thông tin phòng: $e');
      return null;
    }
  }

  factory Showtime.fromJson(Map<String, dynamic> json) {
    return Showtime(
      id: json['id'],
      movieId: json['movieId'],
      cinemaId: json['cinemaId'],
      roomId: json['roomId'],
      startTime: DateTime.parse(json['startTime']),
      bookedSeats: List<String>.from(json['bookedSeats'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'movieId': movieId,
      'cinemaId': cinemaId,
      'roomId': roomId,
      'startTime': startTime.toIso8601String(),
      'bookedSeats': bookedSeats,
    };
  }
}
