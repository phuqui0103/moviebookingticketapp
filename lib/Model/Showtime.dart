class Showtime {
  final String id;
  final String movieId; // Phim nào
  final String roomId; // Phòng nào
  final DateTime dateTime; // Thời gian chiếu
  final String format; // 2D, 3D, IMAX,...
  int availableSeats; // Số ghế còn trống

  Showtime({
    required this.id,
    required this.movieId,
    required this.roomId,
    required this.dateTime,
    required this.format,
    required this.availableSeats,
  });

  factory Showtime.fromJson(Map<String, dynamic> json) {
    return Showtime(
      id: json['id'],
      movieId: json['movieId'],
      roomId: json['roomId'],
      dateTime: json['dateTime'],
      format: json['format'],
      availableSeats: json['availableSeats'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'movieId': movieId,
      'roomId': roomId,
      'dateTime': dateTime,
      'format': format,
      'availableSeats': availableSeats,
    };
  }
}
