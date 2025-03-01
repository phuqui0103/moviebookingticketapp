class Seat {
  final String id;
  final String roomId; // Thuộc phòng nào
  final String type; // VIP, Standard, Couple,...
  String status; // available | booked | reserved

  Seat({
    required this.id,
    required this.roomId,
    required this.type,
    required this.status,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      id: json['id'],
      roomId: json['roomId'],
      type: json['type'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'type': type,
      'status': status,
    };
  }
}
