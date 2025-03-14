import 'package:flutter/material.dart';
import '../Components/bottom_nav_bar.dart';
import '../Model/Movie.dart';
import '../Model/Ticket.dart';
import '../Data/data.dart'; // Chứa danh sách phim & phòng chiếu

class MyTicketListScreen extends StatefulWidget {
  final List<Ticket> myTickets;

  const MyTicketListScreen({Key? key, required this.myTickets})
      : super(key: key);

  @override
  _MyTicketListScreenState createState() => _MyTicketListScreenState();
}

class _MyTicketListScreenState extends State<MyTicketListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedTab = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Ticket> filteredTickets = widget.myTickets
        .where((ticket) => ticket.isUsed == (selectedTab == 1))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Vé của tôi", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BottomNavBar())); // Quay lại màn hình trước
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.orange,
          tabs: [
            _buildTab("Chưa sử dụng", 0),
            _buildTab("Đã sử dụng", 1),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: filteredTickets.isEmpty
          ? _buildEmptyState()
          : _buildTicketList(filteredTickets),
    );
  }

  /// Tạo TabBarItem
  Tab _buildTab(String title, int index) {
    return Tab(
      child: Text(
        title,
        style: TextStyle(
          color: selectedTab == index ? Colors.orange : Colors.white70,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Hiển thị danh sách vé
  Widget _buildTicketList(List<Ticket> tickets) {
    return ListView.builder(
      itemCount: tickets.length,
      itemBuilder: (context, index) => _buildTicketItem(tickets[index]),
    );
  }

  /// Widget hiển thị 1 vé
  Widget _buildTicketItem(Ticket ticket) {
    // Lấy tên phim và poster
    Movie? movie =
        movies.firstWhere((movie) => movie.id == ticket.showtime.movieId);
    String movieTitle = movie.title ?? "";

// Lấy poster phim
    String moviePoster = movie.imagePath ?? "";

    return GestureDetector(
      onTap: () {
        // Chuyển đến màn hình chi tiết vé (chưa triển khai)
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            /// Ảnh phim
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                moviePoster,
                width: 80,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            /// Thông tin vé
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movieTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),

                  /// Suất chiếu
                  _buildInfoRow(Icons.schedule,
                      "Suất: ${ticket.showtime.formattedDate} - ${ticket.showtime.formattedTime}"),

                  /// Ghế ngồi
                  _buildInfoRow(Icons.event_seat,
                      "Ghế: ${ticket.selectedSeats.join(", ")}"),

                  const SizedBox(height: 6),
                  Text(
                    "${ticket.totalPrice.toStringAsFixed(0)}đ",
                    style: const TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: Colors.white54, size: 18),
          ],
        ),
      ),
    );
  }

  /// Widget dòng thông tin (icon + nội dung)
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white54, size: 16),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Hiển thị khi không có vé nào
  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        "Không có vé nào!",
        style: TextStyle(color: Colors.white70, fontSize: 16),
      ),
    );
  }
}
