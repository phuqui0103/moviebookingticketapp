import 'package:flutter/material.dart';
import 'package:movieticketbooking/Data/data.dart';
import 'package:movieticketbooking/Model/Showtime.dart';
import 'package:movieticketbooking/View/user/showtime_picker_screen.dart';
import '../../Model/Movie.dart';
import 'trailer_screen.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({
    required this.movie,
    Key? key,
  }) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Làm trong suốt AppBar
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          /// Hình nền bị mờ
          Positioned.fill(
            child: Opacity(
              opacity: 0.2, // Điều chỉnh độ mờ tại đây
              child: Image.network(
                widget.movie.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// Nội dung phía trên
          Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(widget.movie.imagePath,
                          width: 200, height: 280, fit: BoxFit.cover),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.movie.title,
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26)),
                          const SizedBox(
                            height: 10,
                          ),
                          buildInfoBox("⏳ ${widget.movie.duration}"),
                          buildInfoBox("📅 ${widget.movie.releaseDate}"),
                          buildInfoBox("⭐ ${widget.movie.rating}/10"),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrailerScreen(
                                      trailerUrl: widget.movie.trailerUrl),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange),
                            child: Text("▶ Xem Trailer",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TabBar(
                controller: _tabController,
                labelColor: Colors.orangeAccent, // Màu chữ khi được chọn
                unselectedLabelColor: Colors.white70, // Màu chữ khi chưa chọn
                indicatorColor: Colors.transparent, // Ẩn gạch chân
                labelStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold), // Làm nổi bật chữ
                unselectedLabelStyle: TextStyle(fontSize: 16),
                tabs: [
                  Tab(text: "Giới thiệu"),
                  Tab(text: "Đánh giá"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    buildIntroductionTab(),
                    buildReviewsTab(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ShowtimePickerScreen(movie: widget.movie),
                ),
              );
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Text(
                  "Đặt Vé",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoBox(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orangeAccent, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: Colors.orangeAccent,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildIntroductionTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildDetailRow("Thể loại:",
              widget.movie.genres.map((genre) => genre.name).join(" , ")),
          buildDetailRow("Đạo diễn:", widget.movie.director),
          buildDetailRow("Diễn viên:", widget.movie.cast.join(", ")),
          SizedBox(height: 10),
          Text("Tóm tắt",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent)),
          SizedBox(height: 5),
          Text(widget.movie.description,
              style: TextStyle(fontSize: 14, color: Colors.white70),
              textAlign: TextAlign.justify),
        ],
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: label + " ",
                style: TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            TextSpan(
                text: value,
                style: TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget buildReviewsTab() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hiển thị rating tổng quát
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: Colors.orangeAccent, size: 28),
                  SizedBox(width: 5),
                  Text(
                    "${widget.movie.rating}/10",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
              Text(
                "${widget.movie.reviewCount} đánh giá",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          SizedBox(height: 10),

          // Danh sách bình luận
          Expanded(
            child: widget.movie.comments.isEmpty
                ? Center(
                    child: Text(
                      "Chưa có đánh giá nào",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: widget.movie.comments.length,
                    itemBuilder: (context, index) {
                      final comment = widget.movie.comments[index];
                      return Card(
                        color: Colors.black54,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: Colors.orangeAccent, width: 0.5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    comment.userName,
                                    style: TextStyle(
                                        color: Colors.orangeAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    "⭐ ${comment.rating}/10",
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 14),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                comment.content,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Ô nhập đánh giá
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.orangeAccent, width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: "Viết đánh giá...",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.orangeAccent),
                  onPressed: () {
                    // Xử lý gửi đánh giá
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
