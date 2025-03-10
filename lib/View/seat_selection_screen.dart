import 'package:flutter/material.dart';
import '../Model/Showtime.dart';

class SeatSelectionScreen extends StatefulWidget {
  final Showtime showtime;
  final String movieTitle;
  final String moviePoster;

  const SeatSelectionScreen({
    Key? key,
    required this.showtime,
    required this.movieTitle,
    required this.moviePoster,
  }) : super(key: key);

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final int rows = 9;
  final int cols = 9;
  final double vipSeatPrice = 50000;
  final double normalSeatPrice = 45000;

  List<String> selectedSeats = [];
  Set<String> bookedSeats = {'A1', 'B2', 'C3', 'G1'};

  //Logic kiểm tra ghế có liền kề khi chọn hay không
  void toggleSeat(String seatId) {
    setState(() {
      if (selectedSeats.contains(seatId)) {
        selectedSeats.remove(seatId);
      } else {
        if (selectedSeats.isNotEmpty) {
          bool isAdjacent = selectedSeats.any((selectedSeat) {
            return isSeatAdjacent(selectedSeat, seatId);
          });

          if (!isAdjacent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Vui lòng chọn các ghế liền kề nhau!"),
                duration: Duration(seconds: 2),
              ),
            );
            return;
          }
        }
        selectedSeats.add(seatId);
      }
    });
  }

  bool isSeatAdjacent(String seat1, String seat2) {
    int row1 = seat1.codeUnitAt(0) - 65;
    int col1 = int.parse(seat1.substring(1));
    int row2 = seat2.codeUnitAt(0) - 65;
    int col2 = int.parse(seat2.substring(1));

    return (row1 == row2 && (col1 - col2).abs() == 1) ||
        (col1 == col2 && (row1 - row2).abs() == 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Chọn Ghế',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.moviePoster),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.8),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 120),
              _buildScreenIndicator(),
              const SizedBox(height: 30),
              Expanded(
                child: _buildSeatGrid((seatId) {
                  setState(() {
                    if (!bookedSeats.contains(seatId)) {
                      if (selectedSeats.contains(seatId)) {
                        selectedSeats.remove(seatId);
                      } else {
                        selectedSeats.add(seatId);
                      }
                    }
                  });
                }),
              ),
              _buildLegend(), // Chú thích ghế
              SizedBox(
                height: 10,
              ),
              _buildBottomBar()
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeatGrid(Function(String) toggleSeat) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
        childAspectRatio: 1,
      ),
      itemCount: rows * cols,
      itemBuilder: (context, index) {
        int rowNumber = index ~/ cols;
        int colNumber = index % cols + 1;
        String rowLetter = String.fromCharCode(65 + rowNumber);
        String seatId = '$rowLetter$colNumber';

        bool isSelected = selectedSeats.contains(seatId);
        bool isBooked = bookedSeats.contains(seatId);
        bool isVip = rowNumber < rows / 3;
        double price = isVip ? vipSeatPrice : normalSeatPrice;

        Color seatColor = isBooked
            ? Colors.black
            : isSelected
                ? Colors.grey
                : isVip
                    ? const Color.fromARGB(255, 220, 181, 130)
                    : const Color.fromARGB(255, 255, 166, 0);

        return GestureDetector(
          onTap: isBooked ? null : () => toggleSeat(seatId),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: seatColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: Center(
              child: Text(
                seatId,
                style: TextStyle(
                  color: isBooked ? Colors.white54 : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomBar() {
    double totalPrice = selectedSeats.fold(0, (sum, seatId) {
      int rowNumber = seatId.codeUnitAt(0) - 65;
      double price = rowNumber < 6 ? normalSeatPrice : vipSeatPrice;
      return sum + price;
    });

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          // Phần tổng tiền (Chiếm 30%)
          Expanded(
            flex: 3, // Tỷ lệ 3 phần
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total Price",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  "${totalPrice.toStringAsFixed(0)}đ",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Phần nút thanh toán (Chiếm 70%)
          Expanded(
            flex: 7, // Tỷ lệ 7 phần
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, selectedSeats);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding:
                    const EdgeInsets.symmetric(vertical: 15), // Làm nút cao hơn
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Tiếp Theo',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _legendItem(const Color.fromARGB(255, 220, 181, 130), 'Ghế thường'),
          _legendItem(Colors.orange, 'Ghế VIP'),
          _legendItem(Colors.black, 'Ghế đã đặt'),
          _legendItem(Colors.grey, 'Ghế đã chọn'),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5), // Bo tròn góc
            border: Border.all(color: Colors.white, width: 2), // Viền trắng
          ),
        ),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}

Widget _buildScreenIndicator() {
  return Stack(
    children: [
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        height: 40, // Chiều cao của màn hình
        child: CustomPaint(
          painter: _ScreenPainter(),
          child: Center(
            child: Text(
              'MÀN HÌNH',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

class _ScreenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromARGB(58, 212, 206, 191) // Màu của màn hình
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4); // Hiệu ứng bóng nhẹ

    Path path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(
        size.width / 2, size.height * 0.2, size.width, size.height * 0.8);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
