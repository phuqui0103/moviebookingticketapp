import 'package:intl/intl.dart';
import 'package:movieticketbooking/Model/Room.dart';
import '../Data/data.dart';

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

  int get availableSeats {
    Room room = rooms.firstWhere((room) => room.id == roomId);
    int totalSeats = room.cols * room.rows;
    return totalSeats - bookedSeats.length;
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
