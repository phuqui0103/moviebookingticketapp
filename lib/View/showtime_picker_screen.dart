import 'package:flutter/material.dart';
import 'package:movieticketbooking/Components/bottom_nav_bar.dart';
import 'package:movieticketbooking/Components/date_picker.dart';
import 'package:movieticketbooking/Components/time_picker.dart';

class Showtimepickerscreen extends StatefulWidget {
  const Showtimepickerscreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Showtimepickerscreen> createState() => _ShowtimePickerState();
}

class _ShowtimePickerState extends State<Showtimepickerscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff252429),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BottomNavBar()),
                      );
                    },
                    child: Container(
                      height: 50,
                      width: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white24,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 65,
                  ),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 35.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20 * 2,
            ),
            Container(
              height: 120,
              width: MediaQuery.of(context).size.width / 1.1,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    DatePicker(),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Rạp phim gần nhất",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Địa chỉ",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 130,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TimePicker(),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
              child: GestureDetector(
                onTap: () {
                  // Hành động khi nhấn nút Đặt Vé
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('chọn ghế')),
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
          ],
        ),
      ),
    );
  }
}
