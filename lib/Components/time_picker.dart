import 'package:flutter/material.dart';
import '../Model/Showtime.dart';

class TimePicker extends StatefulWidget {
  final List<Showtime> availableShowtimes; // Danh sách suất chiếu
  final Function(Showtime) onTimeSelected; // Callback khi chọn suất chiếu

  const TimePicker({
    Key? key,
    required this.availableShowtimes,
    required this.onTimeSelected,
  }) : super(key: key);

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  Showtime? selectedShowtime;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: widget.availableShowtimes.length,
        physics: const BouncingScrollPhysics(),
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
        "${showtime.dateTime.hour.toString().padLeft(2, '0')}:${showtime.dateTime.minute.toString().padLeft(2, '0')}";

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.orangeAccent : Colors.white10,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(10),
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
