import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../Data/data.dart';
import '../Model/Cinema.dart';
import '../Model/Room.dart';
import '../Model/Showtime.dart';

class TicketScreen extends StatelessWidget {
  final String movieTitle;
  final String moviePoster;
  final Showtime showtime;
  final List<String> selectedSeats;
  final double totalPrice;

  const TicketScreen({
    Key? key,
    required this.movieTitle,
    required this.moviePoster,
    required this.showtime,
    required this.selectedSeats,
    required this.totalPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lấy phòng chiếu từ roomId trong showtime
    Room? selectedRoom = rooms.firstWhere(
      (room) => room.id == showtime.roomId,
      orElse: () => Room(
        id: "",
        cinemaId: "",
        name: "Không xác định",
        rows: 0,
        seatLayout: [],
        cols: 0,
      ),
    );

    // Lấy tên rạp từ cinemaId trong showtime
    Cinema? selectedCinema = cinemas.firstWhere(
      (cinema) => cinema.id == selectedRoom.cinemaId,
      orElse: () => Cinema(
        id: "",
        name: "Không xác định",
        provinceId: '',
        address: '',
      ),
    );
    String ticketInfo =
        "$movieTitle\nRạp: ${selectedCinema.name}\nPhòng: ${selectedRoom.name}\nSuất: ${showtime.formattedTime}\nNgày: ${showtime.formattedDate}\nGhế: ${selectedSeats.join(", ")}\nTổng tiền: ${totalPrice.toStringAsFixed(0)}đ";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Vé của bạn', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.orangeAccent, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.orangeAccent.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Ảnh phim
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  moviePoster,
                  width: 160,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 12),

              /// Tiêu đề phim
              Text(
                movieTitle,
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(color: Colors.grey, thickness: 1),

              /// Thông tin vé
              _buildInfoRow(Icons.location_on, "Rạp", selectedCinema.name),
              _buildInfoRow(Icons.meeting_room, "Phòng", selectedRoom.name),
              _buildInfoRow(Icons.schedule, "Suất", showtime.formattedTime),
              _buildInfoRow(
                  Icons.calendar_today, "Ngày", showtime.formattedDate),
              _buildInfoRow(Icons.event_seat, "Ghế", selectedSeats.join(", ")),
              _buildInfoRow(Icons.attach_money, "Tổng tiền",
                  "${totalPrice.toStringAsFixed(0)}đ"),
              SizedBox(height: 12),

              /// Dấu cắt nét đứt ngang
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  20,
                  (index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    child: Container(
                      width: 6,
                      height: 2,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),

              /// Mã QR
              QrImageView(
                data: ticketInfo,
                version: QrVersions.auto,
                size: 180,
                foregroundColor: Colors.black,
              ),
              SizedBox(height: 12),

              /// Nút về trang chủ
              ElevatedButton(
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("Về Trang Chủ",
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.orangeAccent, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "$label: $value",
              style: TextStyle(color: Colors.black87, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
