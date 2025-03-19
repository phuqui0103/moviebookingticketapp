import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:movieticketbooking/Model/Ticket.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../Components/bottom_nav_bar.dart';
import '../../Data/data.dart';
import '../../Model/Cinema.dart';
import '../../Model/Room.dart';
import '../../Model/Showtime.dart';
import '../../Model/Food.dart';

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

    return Scaffold(
      body: Stack(
        children: [
          /// Hình nền poster
          Positioned.fill(
            child: Image.network(
              moviePoster,
              fit: BoxFit.cover,
            ),
          ),

          /// Hiệu ứng mờ cho hình nền
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),

          /// Nội dung chính
          SafeArea(
            child: Column(
              children: [
                /// Nút quay lại
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                /// Thông tin vé
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                          _buildInfoRow(Icons.calendar_today, "Ngày",
                              showtime.formattedDate),
                          _buildInfoRow(Icons.event_seat, "Ghế",
                              selectedSeats.join(", ")),

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

                          /// Danh sách bắp & nước
                          _buildFoodTable(),

                          SizedBox(height: 10),

                          /// Mã QR
                          Center(
                            child: QrImageView(
                              data: "${showtime.id}",
                              version: QrVersions.auto,
                              size: 160,
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  Colors.transparent, // Giữ giao diện đẹp
                            ),
                          ),

                          SizedBox(height: 12),

                          /// Tổng tiền
                          _buildInfoRow(Icons.attach_money, "Tổng tiền",
                              "${totalPrice.toStringAsFixed(0)}đ",
                              isBold: true),

                          SizedBox(height: 16),

                          /// Nút về trang chủ
                          Center(
                            child: ElevatedButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BottomNavBar())),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent,
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 30),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text("Về Trang Chủ",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Hàm hiển thị thông tin
  Widget _buildInfoRow(IconData icon, String label, String value,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.orangeAccent, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "$label: $value",
              style: TextStyle(
                color: Colors.white,
                fontSize: isBold ? 18 : 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Hiển thị bảng bắp & nước
  Widget _buildFoodTable() {
    if (selectedFoods.isEmpty) {
      return Center(
        child: Text("Không có",
            style: TextStyle(color: Colors.white54, fontSize: 16)),
      );
    }

    return Table(
      columnWidths: {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
      },
      children: [
        ...selectedFoods.entries.map((entry) {
          Food? food = foodItems.firstWhere(
            (f) => f.id == entry.key,
            orElse: () => Food(
                id: "",
                name: "Không xác định",
                price: 0,
                image: '',
                description: ''),
          );
          return TableRow(
            children: [
              _buildTableCell(food.name),
              _buildTableCell("x${entry.value}"),
              _buildTableCell(
                  "${(food.price * entry.value).toStringAsFixed(0)}đ"),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildTableHeader(String title) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(title,
            style: TextStyle(
                color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
      );

  Widget _buildTableCell(String content) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(content, style: TextStyle(color: Colors.white)),
      );
}
