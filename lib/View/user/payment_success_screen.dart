import 'package:flutter/material.dart';
import 'package:movieticketbooking/Model/Showtime.dart';
import '../../Components/bottom_nav_bar.dart';
import '../../Data/data.dart';
import '../../Model/Ticket.dart';
import 'ticket_detail_screen.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String movieTitle;
  final String moviePoster;
  final Showtime showtime;
  final String roomName;
  final String cinemaName;
  final List<String> selectedSeats;
  final double totalPrice;
  final Map<String, int> selectedFoods;

  const PaymentSuccessScreen({
    Key? key,
    required this.movieTitle,
    required this.moviePoster,
    required this.showtime,
    required this.selectedSeats,
    required this.totalPrice,
    required this.roomName,
    required this.cinemaName,
    required this.selectedFoods,
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
              Icon(Icons.check_circle, color: Colors.greenAccent, size: 80),
              SizedBox(height: 16),
              Text(
                "Thanh toán thành công!",
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      moviePoster,
                      width: 120,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16),
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
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Tạo một vé mới từ thông tin thanh toán
                        Ticket newTicket = Ticket(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          showtime: showtime,
                          selectedSeats: selectedSeats,
                          selectedFoods: selectedFoods,
                          totalPrice: totalPrice,
                          isUsed: false, // Vé chưa được sử dụng
                        );

                        // Thêm vé vào danh sách myTickets
                        myTickets.add(newTicket);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TicketDetailScreen(
                              movieTitle: movieTitle,
                              moviePoster: moviePoster,
                              showtime: showtime,
                              selectedSeats: selectedSeats,
                              totalPrice: totalPrice,
                              selectedFoods: selectedFoods,
                            ),
                          ),
                        );
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
