import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  final Function(String) onDateSelected;

  const DatePicker({Key? key, required this.onDateSelected}) : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  int selectedIndex = 0;
  final List<DateTime> days =
      List.generate(7, (index) => DateTime.now().add(Duration(days: index)));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
            widget.onDateSelected(DateFormat('yyyy-MM-dd').format(days[index]));
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                color: selectedIndex == index
                    ? Colors.orangeAccent
                    : Colors.white10,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(10),
              color:
                  selectedIndex == index ? Colors.black54 : Colors.transparent,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('EEE').format(days[index]).toUpperCase(),
                  style: TextStyle(
                    color: selectedIndex == index
                        ? Colors.orangeAccent
                        : Colors.white54,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  DateFormat('d').format(days[index]),
                  style: TextStyle(
                    color: selectedIndex == index
                        ? Colors.orangeAccent
                        : Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
