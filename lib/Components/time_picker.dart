import 'package:flutter/material.dart';

class TimePicker extends StatefulWidget {
  const TimePicker({Key? key}) : super(key: key);

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  int selectedIndex = 0;
  final List<String> _time = [
    "11:00",
    "12:30",
    "14:30",
    "16:00",
    "17:30",
    "19:00",
    "20:30",
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350, // Tăng chiều cao để phù hợp với lưới
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Số cột trong lưới
          childAspectRatio: 2, // Tỷ lệ chiều rộng và chiều cao của mỗi ô
          crossAxisSpacing: 10, // Khoảng cách giữa các cột
          mainAxisSpacing: 10, // Khoảng cách giữa các hàng
        ),
        itemCount: _time.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
          child: _buildTimePicker(index),
        ),
      ),
    );
  }

  Widget _buildTimePicker(int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: selectedIndex == index ? Colors.orangeAccent : Colors.white10,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(10),
        color: selectedIndex == index ? Colors.black54 : Colors.transparent,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _time[index],
            style: TextStyle(
              color:
                  selectedIndex == index ? Colors.orangeAccent : Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
