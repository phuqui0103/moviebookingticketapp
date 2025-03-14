import 'package:flutter/material.dart';
import '../Data/data.dart';
import '../Model/Food.dart';
import '../Model/Showtime.dart';
import '../Model/Room.dart';
import '../Model/Cinema.dart';
import 'payment_success_screen.dart';
import 'ticket_detail_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String movieTitle;
  final String moviePoster;
  final Showtime showtime;
  final List<String> selectedSeats;
  final double totalPrice;
  final Map<String, int> selectedFoods;

  const PaymentScreen({
    Key? key,
    required this.movieTitle,
    required this.moviePoster,
    required this.showtime,
    required this.selectedSeats,
    required this.totalPrice,
    required this.selectedFoods,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPaymentMethod = "MoMo";
  bool isAgreed = false;
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  String? cardNumberError;
  String? expiryError;
  String? cvvError;

  void confirmPayment() {
    if (!isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Bạn cần đồng ý với điều khoản trước khi thanh toán!")),
      );
      return;
    }
    _showBankPaymentDialog();
  }

  void _showBankPaymentDialog() {
    Room? selectedRoom = rooms.firstWhere(
      (room) => room.id == widget.showtime.roomId,
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
    setState(() {
      cardNumberError = null;
      expiryError = null;
      cvvError = null;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Nhập thông tin thẻ ngân hàng",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (context, setDialogState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Số thẻ
                    TextFormField(
                      controller: cardNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Số thẻ",
                        prefixIcon: Icon(Icons.credit_card),
                        border: OutlineInputBorder(),
                        errorText: cardNumberError,
                      ),
                      onChanged: (value) {
                        setDialogState(() {
                          cardNumberError =
                              value.isEmpty ? "Vui lòng nhập số thẻ" : null;
                        });
                      },
                    ),
                    SizedBox(height: 10),

                    // Ngày hết hạn
                    TextFormField(
                      controller: expiryController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: "Ngày hết hạn (MM/YY)",
                        prefixIcon: Icon(Icons.date_range),
                        border: OutlineInputBorder(),
                        errorText: expiryError,
                      ),
                      onChanged: (value) {
                        setDialogState(() {
                          expiryError = value.isEmpty
                              ? "Vui lòng nhập ngày hết hạn"
                              : null;
                        });
                      },
                    ),
                    SizedBox(height: 10),

                    // CVV
                    TextFormField(
                      controller: cvvController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "CVV",
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                        errorText: cvvError,
                      ),
                      onChanged: (value) {
                        setDialogState(() {
                          cvvError = value.isEmpty ? "Vui lòng nhập CVV" : null;
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () {
                //setState(() {
                //  cardNumberError = cardNumberController.text.isEmpty
                //      ? "Vui lòng nhập số thẻ"
                //      : null;
                //  expiryError = expiryController.text.isEmpty
                //      ? "Vui lòng nhập ngày hết hạn"
                //      : null;
                //  cvvError =
                //      cvvController.text.isEmpty ? "Vui lòng nhập CVV" : null;
                //});
//
                //if (cardNumberError == null &&
                //    expiryError == null &&
                //    cvvError == null) {
                //  Navigator.push(
                //    context,
                //    MaterialPageRoute(
                //      builder: (context) => TicketScreen(
                //        movieTitle: widget.movieTitle,
                //        moviePoster: widget.moviePoster,
                //        showtime: widget.showtime,
                //        selectedSeats: widget.selectedSeats,
                //        totalPrice: widget.totalPrice,
                //        selectedFoods: widget.selectedFoods,
                //      ),
                //    ),
                //  );
                //}
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentSuccessScreen(
                      movieTitle: widget.movieTitle,
                      moviePoster: widget.moviePoster,
                      showtime: widget.showtime,
                      roomName: selectedRoom.name,
                      cinemaName: selectedCinema.name,
                      selectedSeats: widget.selectedSeats,
                      totalPrice: widget.totalPrice,
                    ),
                  ),
                );
              },
              child: Text("Thanh Toán"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lấy phòng chiếu từ roomId trong showtime
    Room? selectedRoom = rooms.firstWhere(
      (room) => room.id == widget.showtime.roomId,
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

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Thanh Toán', style: TextStyle(color: Colors.white)),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            /// 1. Thông tin đặt vé trong khung viền cam
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.orangeAccent, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                /// Ảnh phim bên phải
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      widget.moviePoster,
                      width: 140, // Kích thước ảnh nhỏ gọn
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 20),

                  /// Phần thông tin bên trái
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Tiêu đề phim
                        Text(
                          widget.movieTitle,
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 10),

                        /// Thông tin chi tiết
                        _buildInfoRow(
                            Icons.location_on, "Rạp", selectedCinema.name),
                        _buildInfoRow(
                            Icons.meeting_room, "Phòng", selectedRoom.name),
                        _buildInfoRow(Icons.schedule, "Thời gian",
                            widget.showtime.formattedTime),
                        _buildInfoRow(Icons.calendar_month, "Ngày",
                            widget.showtime.formattedDate),
                        _buildInfoRow(Icons.event_seat, "Ghế",
                            widget.selectedSeats.join(", ")),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (widget.selectedFoods.isNotEmpty)
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Tiêu đề
                    //Text(
                    //  "Bắp nước đã chọn",
                    //  style: TextStyle(
                    //    color: Colors.orange,
                    //    fontSize: 22,
                    //    fontWeight: FontWeight.bold,
                    //  ),
                    //),
                    //SizedBox(height: 10),

                    /// Danh sách món ăn

                    Text(
                      "Bắp nước đã chọn",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Column(
                      children: widget.selectedFoods.entries.map((entry) {
                        Food food = foodItems
                            .firstWhere((item) => item.id == entry.key);
                        int quantity = entry.value;
                        double totalFoodPrice = quantity * food.price;

                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              /// Hình ảnh món ăn
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  food.image,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 12),

                              /// Thông tin món ăn
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      food.name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "$quantity x ${food.price.toStringAsFixed(0)}đ",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// Tổng tiền từng món
                              Text(
                                "${totalFoodPrice.toStringAsFixed(0)}đ",
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 10),

                    /// Tổng tiền bắp nước
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border:
                            Border.all(color: Colors.orangeAccent, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Tổng tiền bắp nước",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${widget.selectedFoods.entries.fold(0, (sum, entry) {
                              Food food = foodItems
                                  .firstWhere((item) => item.id == entry.key);
                              return sum + (entry.value * food.price).toInt();
                            }).toStringAsFixed(0)}đ",
                            style: const TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 20),

            /// 2. Chọn phương thức thanh toán
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Tiêu đề
                  Text(
                    "Chọn phương thức thanh toán",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),

                  /// Phương thức thanh toán MoMo
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPaymentMethod = "MoMo";
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: selectedPaymentMethod == "MoMo"
                            ? Colors.orangeAccent.withOpacity(0.2)
                            : Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedPaymentMethod == "MoMo"
                              ? Colors.orangeAccent
                              : Colors.white30,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.account_balance_wallet,
                              color: Colors.orangeAccent),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text("MoMo",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ),
                          Radio(
                            value: "MoMo",
                            groupValue: selectedPaymentMethod,
                            onChanged: (value) {
                              setState(() {
                                selectedPaymentMethod = value.toString();
                              });
                            },
                            activeColor: Colors.orangeAccent,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),

                  /// Phương thức thanh toán Thẻ ngân hàng
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPaymentMethod = "Thẻ ngân hàng";
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: selectedPaymentMethod == "Thẻ ngân hàng"
                            ? Colors.orangeAccent.withOpacity(0.2)
                            : Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedPaymentMethod == "Thẻ ngân hàng"
                              ? Colors.orangeAccent
                              : Colors.white30,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.credit_card, color: Colors.orangeAccent),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text("Thẻ ngân hàng",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ),
                          Radio(
                            value: "Thẻ ngân hàng",
                            groupValue: selectedPaymentMethod,
                            onChanged: (value) {
                              setState(() {
                                selectedPaymentMethod = value.toString();
                              });
                            },
                            activeColor: Colors.orangeAccent,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            /// 3. Checkbox đồng ý điều khoản
            Row(
              children: [
                Checkbox(
                  value: isAgreed,
                  onChanged: (value) {
                    setState(() {
                      isAgreed = value!;
                    });
                  },
                  activeColor: Colors.orangeAccent,
                ),
                Expanded(
                  child: Text(
                    "Tôi đồng ý với điều khoản và điều kiện của dịch vụ",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
            Spacer(),

            /// 4. Tổng tiền + Nút thanh toán
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Tổng tiền
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tổng tiền",
                          style:
                              TextStyle(color: Colors.white70, fontSize: 16)),
                      Text("${widget.totalPrice.toStringAsFixed(0)}đ",
                          style: TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),

                  /// Nút thanh toán
                  ElevatedButton(
                    onPressed: confirmPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isAgreed ? Colors.orangeAccent : Colors.grey,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Thanh Toán",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ],
              ),
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
              value,
              style: TextStyle(color: Colors.white70, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
