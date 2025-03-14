import 'package:flutter/material.dart';
import 'package:movieticketbooking/Model/Ticket.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../Data/data.dart';
import '../Model/Cinema.dart';
import '../Model/Room.dart';
import '../Model/Showtime.dart';
import '../Model/Food.dart'; // Import danh sách món ăn

class TicketDetailScreen extends StatelessWidget {
  final String movieTitle;
  final String moviePoster;
  final Showtime showtime;
  final List<String> selectedSeats;
  final double totalPrice;
  final Map<String, int> selectedFoods;

  const TicketDetailScreen({
    Key? key,
    required this.movieTitle,
    required this.moviePoster,
    required this.showtime,
    required this.selectedSeats,
    required this.totalPrice,
    required this.selectedFoods,
    required Ticket ticket,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Room? selectedRoom = rooms.firstWhere(
      (room) => room.id == showtime.roomId,
      orElse: () => Room(
          id: "",
          cinemaId: "",
          name: "Không xác định",
          rows: 0,
          seatLayout: [],
          cols: 0),
    );

    Cinema? selectedCinema = cinemas.firstWhere(
      (cinema) => cinema.id == selectedRoom.cinemaId,
      orElse: () =>
          Cinema(id: "", name: "Không xác định", provinceId: '', address: ''),
    );

    String foodInfoQR = selectedFoods.isNotEmpty
        ? selectedFoods.entries.map((entry) {
            Food? foodItem = foodItems.firstWhere(
              (food) => food.id == entry.key,
              orElse: () => Food(
                  id: "",
                  name: "Không xác định",
                  price: 0,
                  image: '',
                  description: ''),
            );
            return "${foodItem.name} x${entry.value}";
          }).join(", ")
        : "Không có";

    String ticketInfo =
        "$movieTitle\nRạp: ${selectedCinema.name}\nPhòng: ${selectedRoom.name}\nSuất: ${showtime.formattedTime}\nNgày: ${showtime.formattedDate}\nGhế: ${selectedSeats.join(", ")}\nBắp & Nước: $foodInfoQR\nTổng tiền: ${totalPrice.toStringAsFixed(0)}đ";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Vé của bạn', style: TextStyle(color: Colors.white)),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            /// Ảnh phim
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                moviePoster,
                width: 140,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),

            /// Thông tin vé
            Card(
              color: Colors.grey[900],
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Tên phim
                    Center(
                      child: Text(
                        movieTitle,
                        style: TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(color: Colors.white24),

                    /// Thông tin suất chiếu
                    _buildInfoRow(
                        Icons.location_on, "Rạp", selectedCinema.name),
                    _buildInfoRow(
                        Icons.meeting_room, "Phòng", selectedRoom.name),
                    _buildInfoRow(
                        Icons.schedule, "Suất", showtime.formattedTime),
                    _buildInfoRow(
                        Icons.calendar_today, "Ngày", showtime.formattedDate),
                    _buildInfoRow(
                        Icons.event_seat, "Ghế", selectedSeats.join(", ")),
                    _buildInfoRow(Icons.attach_money, "Tổng tiền",
                        "${totalPrice.toStringAsFixed(0)}đ"),

                    SizedBox(height: 10),

                    /// Bắp & Nước
                    Text(
                      "Bắp & Nước",
                      style: TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Divider(color: Colors.white24),
                    _buildFoodList(),
                  ],
                ),
              ),
            ),

            SizedBox(height: 12),

            /// Mã QR
            QrImageView(
              data: ticketInfo,
              version: QrVersions.auto,
              size: 160,
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
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
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("Về Trang Chủ",
                  style: TextStyle(fontSize: 18, color: Colors.black)),
            ),
          ],
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
              style: TextStyle(color: Colors.white, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodList() {
    if (selectedFoods.isEmpty) {
      return Center(
        child: Text("Không có",
            style: TextStyle(color: Colors.white54, fontSize: 16)),
      );
    }

    return Column(
      children: selectedFoods.entries.map((entry) {
        Food? food = foodItems.firstWhere(
          (f) => f.id == entry.key,
          orElse: () => Food(
              id: "",
              name: "Không xác định",
              price: 0,
              image: '',
              description: ''),
        );

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(food.name,
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              Text("x${entry.value}",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
