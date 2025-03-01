class Room {
  final String id;
  final String cinemaId; // Thuộc rạp nào
  final String name; // Tên phòng (phòng 1, phòng 2, ...)
  final int seatCount; // Tổng số ghế

  Room({
    required this.id,
    required this.cinemaId,
    required this.name,
    required this.seatCount,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      cinemaId: json['cinemaId'],
      name: json['name'],
      seatCount: json['seatCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cinemaId': cinemaId,
      'name': name,
      'seatCount': seatCount,
    };
  }
}
