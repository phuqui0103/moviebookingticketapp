import 'package:movieticketbooking/Model/Showtime.dart';

class Ticket {
  final String id;
  final Showtime showtime;
  final List<String> selectedSeats;
  final List<String> selectedFoods;
  final double totalPrice;
  final bool isUsed; // Trạng thái vé đã sử dụng hay chưa

  Ticket({
    required this.id,
    required this.showtime,
    required this.selectedSeats,
    required this.selectedFoods,
    required this.totalPrice,
    required this.isUsed,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      showtime: Showtime.fromJson(json['showtime']),
      selectedSeats: List<String>.from(json['selectedSeats'] ?? []),
      selectedFoods: List<String>.from(json['selectedFoods'] ?? []),
      totalPrice: json['totalPrice'].toDouble(),
      isUsed: json['isUsed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'showtime': showtime.toJson(),
      'selectedSeats': selectedSeats,
      'selectedFoods': selectedFoods,
      'totalPrice': totalPrice,
      'isUsed': isUsed,
    };
  }
}
