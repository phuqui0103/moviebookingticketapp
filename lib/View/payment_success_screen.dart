import 'package:flutter/material.dart';
import 'package:movieticketbooking/Components/bottom_nav_bar.dart';
import 'ticket_detail_screen.dart';
import 'movie_list_screen.dart'; // Màn hình trang chủ phim
import '../Model/Showtime.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String movieTitle;
  final String moviePoster;
  final Showtime showtime;
  final String roomName;
  final String cinemaName;
  final List<String> selectedSeats;
  final double totalPrice;

  const PaymentSuccessScreen({
    Key? key,
    required this.movieTitle,
    required this.moviePoster,
    required this.showtime,
    required this.selectedSeats,
    required this.totalPrice,
    required this.roomName,
    required this.cinemaName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Check xanh thành công
              Icon(Icons.check_circle, color: Colors.greenAccent, size: 80),
              SizedBox(height: 16),

              /// Tiêu đề
              Text(
                "Thanh toán thành công!",
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),

              /// Row chứa poster và thông tin phim
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Ảnh poster phim
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      moviePoster,
                      width: 120,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16),

                  /// Thông tin phim
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoText("🎬 Phim", movieTitle),
                        _buildInfoText("📅 Ngày chiếu", showtime.formattedDate),
                        _buildInfoText("⏰ Giờ chiếu", showtime.formattedTime),
                        _buildInfoText("📍 Rạp", cinemaName),
                        _buildInfoText("🏠 Phòng", roomName),
                        _buildInfoText("💺 Ghế", selectedSeats.join(", ")),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              /// Tổng tiền
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "${totalPrice.toStringAsFixed(0)}đ",
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 30),

              /// Hai nút "Xem vé" và "Về trang chủ" ngang nhau, kích thước bằng nhau
              Row(
                children: [
                  /// Nút "Xem vé"
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        //Navigator.pushReplacement(
                        //  context,
                        //  MaterialPageRoute(
                        //    builder: (context) => TicketDetailScreen(
                        //      movieTitle: movieTitle,
                        //      moviePoster: moviePoster,
                        //      showtime: showtime,
                        //      selectedSeats: selectedSeats,
                        //      totalPrice: totalPrice,
                        //    ),
                        //  ),
                        //);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Xem vé",
                          style: TextStyle(fontSize: 18, color: Colors.black)),
                    ),
                  ),
                  SizedBox(width: 16),

                  /// Nút "Về trang chủ"
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomNavBar()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Về trang chủ",
                          style:
                              TextStyle(fontSize: 18, color: Colors.white70)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Hàm tạo dòng thông tin
  Widget _buildInfoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$label: ",
              style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: value,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
