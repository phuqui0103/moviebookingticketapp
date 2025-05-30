import 'package:flutter/material.dart';
import 'package:movieticketbooking/Model/Food.dart';
import '../../Components/bottom_nav_bar.dart';
import '../../Model/Movie.dart';
import '../../Model/Ticket.dart';
import '../../Data/data.dart';
import 'ticket_detail_screen.dart'; // Chứa danh sách phim & phòng chiếu

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
      backgroundColor: const Color(0xff252429),
      appBar: AppBar(
        title: Text(
          "Vé của tôi",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: const Color(0xff252429),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BottomNavBar()),
            );
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.orange,
          indicatorWeight: 3,
          labelColor: Colors.orange,
          unselectedLabelColor: Colors.white70,
          tabs: [
            _buildTab("Chưa sử dụng", 0),
            _buildTab("Đã sử dụng", 1),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff252429),
              Color(0xff2A2A2A),
            ],
          ),
        ),
        child: filteredTickets.isEmpty
            ? _buildEmptyState()
            : _buildTicketList(filteredTickets),
      ),
    );
  }

  /// Tạo TabBarItem
  Tab _buildTab(String title, int index) {
    return Tab(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Hiển thị danh sách vé
  Widget _buildTicketList(List<Ticket> tickets) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: tickets.length,
      itemBuilder: (context, index) => _buildTicketItem(tickets[index]),
    );
  }

  /// Widget hiển thị 1 vé
  Widget _buildTicketItem(Ticket ticket) {
    // Lấy tên phim và poster
    Movie? movie = movies.firstWhere(
      (movie) => movie.id == ticket.showtime.movieId,
      orElse: () => Movie(
        id: "",
        title: "Không xác định",
        imagePath: "",
        trailerUrl: '',
        genres: [],
        duration: '',
        rating: 0,
        isShowingNow: false,
        description: '',
        reviewCount: 0,
        cast: [],
        releaseDate: '',
        director: '',
        comments: [],
      ),
    );

    return GestureDetector(
      onTap: () {
        // Khi nhấn vào vé, điều hướng đến màn hình chi tiết vé
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketDetailScreen(
              movieTitle: movie.title ?? "",
              moviePoster: movie.imagePath ?? "",
              showtime: ticket.showtime,
              selectedSeats: ticket.selectedSeats,
              totalPrice: ticket.totalPrice,
              selectedFoods: ticket.selectedFoods,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                movie.imagePath ?? "",
                width: 90,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title ?? "",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.schedule,
                    "${ticket.showtime.formattedDate} - ${ticket.showtime.formattedTime}",
                  ),
                  SizedBox(height: 4),
                  _buildInfoRow(
                    Icons.event_seat,
                    "Ghế: ${ticket.selectedSeats.join(", ")}",
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${ticket.totalPrice.toStringAsFixed(0)}đ",
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white54,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget dòng thông tin (icon + nội dung)
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Hiển thị khi không có vé nào
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.confirmation_number_outlined,
            color: Colors.orange.withOpacity(0.5),
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            "Không có vé nào!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            selectedTab == 0
                ? "Bạn chưa mua vé nào"
                : "Bạn chưa sử dụng vé nào",
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
