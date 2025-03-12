import 'package:flutter/material.dart';
import '../Model/Showtime.dart';

class TimePicker extends StatefulWidget {
  final List<Showtime> availableShowtimes;
  final Function(Showtime) onTimeSelected;
  final double height;
  const TimePicker(
      {Key? key,
      required this.availableShowtimes,
      required this.onTimeSelected,
      required this.height})
      : super(key: key);

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  Showtime? selectedShowtime;

  @override
  Widget build(BuildContext context) {
    double buttonHeight = widget.height; // Chiều cao mỗi nút
    double spacing = 10; // Khoảng cách giữa các nút
    double maxHeight =
        (buttonHeight * 2) + spacing * 3; // Giới hạn tối đa 2 hàng

    return SizedBox(
      height: maxHeight, // Giới hạn chiều cao GridView
      child: GridView.builder(
        shrinkWrap: true,
        physics: widget.availableShowtimes.length > 6
            ? const BouncingScrollPhysics()
            : const NeverScrollableScrollPhysics(), // Chỉ cuộn nếu > 6 suất
        padding: EdgeInsets.zero, // Bỏ padding mặc định
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 cột
          childAspectRatio: 2.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: widget.availableShowtimes.length,
        itemBuilder: (context, index) {
          final showtime = widget.availableShowtimes[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedShowtime = showtime;
              });
              widget.onTimeSelected(showtime);
            },
            child: _buildTimeButton(showtime),
          );
        },
      ),
    );
  }

  Widget _buildTimeButton(Showtime showtime) {
    bool isSelected = selectedShowtime == showtime;
    String formattedTime =
        "${showtime.startTime.hour.toString().padLeft(2, '0')}:${showtime.startTime.minute.toString().padLeft(2, '0')}";

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.orangeAccent : Colors.white,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
        color: isSelected ? Colors.black54 : Colors.transparent,
      ),
      child: Center(
        child: Text(
          formattedTime,
          style: TextStyle(
            color: isSelected ? Colors.orangeAccent : Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
