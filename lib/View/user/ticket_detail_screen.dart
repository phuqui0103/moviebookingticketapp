import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../Components/bottom_nav_bar.dart';
import '../../Model/Cinema.dart';
import '../../Model/Room.dart';
import '../../Model/Food.dart';
import '../../Model/Ticket.dart';
import '../../Services/room_service.dart';
import '../../Services/cinema_service.dart';
import '../../Services/food_service.dart';

class TicketDetailScreen extends StatefulWidget {
  final Ticket ticket;
  final String movieTitle;
  final String moviePoster;

  const TicketDetailScreen({
    Key? key,
    required this.ticket,
    required this.movieTitle,
    required this.moviePoster,
  }) : super(key: key);

  @override
  _TicketDetailScreenState createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  Room? selectedRoom;
  Cinema? selectedCinema;
  List<Food> foodItems = [];
  bool isLoading = true;

  final RoomService _roomService = RoomService();
  final CinemaService _cinemaService = CinemaService();
  final FoodService _foodService = FoodService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Load room data
      selectedRoom =
          await _roomService.getRoomById(widget.ticket.showtime.roomId);

      if (selectedRoom != null) {
        // Load cinema data
        selectedCinema =
            await _cinemaService.getCinemaById(selectedRoom!.cinemaId);

        // Load food data
        final foodStream = _foodService.getAllFoods();
        foodStream.listen((foods) {
          setState(() {
            foodItems = foods;
            isLoading = false;
          });
        }, onError: (error) {
          print('Error loading food data: $error');
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Có lỗi xảy ra khi tải dữ liệu đồ ăn'),
              backgroundColor: Colors.red,
            ),
          );
        });
      }
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Có lỗi xảy ra khi tải dữ liệu'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || selectedRoom == null || selectedCinema == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          /// Hình nền poster
          Positioned.fill(
            child: Image.network(
              widget.moviePoster,
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
                              widget.movieTitle,
                              style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Divider(color: Colors.white24),

                          /// Thông tin suất chiếu
                          _buildInfoRow(
                              Icons.location_on, "Rạp", selectedCinema!.name),
                          _buildInfoRow(
                              Icons.meeting_room, "Phòng", selectedRoom!.name),
                          _buildInfoRow(Icons.schedule, "Suất",
                              widget.ticket.showtime.formattedTime),
                          _buildInfoRow(Icons.calendar_today, "Ngày",
                              widget.ticket.showtime.formattedDate),
                          _buildInfoRow(Icons.event_seat, "Ghế",
                              widget.ticket.selectedSeats.join(", ")),

                          if (widget.ticket.isUsed)
                            _buildInfoRow(
                                Icons.check_circle, "Trạng thái", "Đã sử dụng",
                                textColor: Colors.grey),

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
                              data: widget.ticket.id,
                              version: QrVersions.auto,
                              size: 160,
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.transparent,
                            ),
                          ),

                          SizedBox(height: 12),

                          /// Tổng tiền
                          _buildInfoRow(Icons.attach_money, "Tổng tiền",
                              "${widget.ticket.totalPrice.toStringAsFixed(0)}đ",
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
      {bool isBold = false, Color textColor = Colors.white}) {
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
                color: textColor,
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
    if (widget.ticket.selectedFoods.isEmpty) {
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
        ...widget.ticket.selectedFoods.entries.map((entry) {
          Food? food = foodItems.firstWhere(
            (f) => f.id == entry.key,
            orElse: () => Food(
                id: entry.key,
                name: "Không xác định",
                price: 0,
                image: 'https://via.placeholder.com/150',
                description: 'Không tìm thấy thông tin món ăn'),
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

  Widget _buildTableCell(String content) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(content, style: TextStyle(color: Colors.white)),
      );
}
