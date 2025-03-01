import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Components/bottom_nav_bar.dart';
import '../Components/date_picker.dart';
import '../Components/time_picker.dart';
import '../Data/data.dart';
import '../Model/Movie.dart';
import '../Model/Room.dart';
import '../Model/Showtime.dart';
import '../Model/Cinema.dart';

class ShowtimePickerScreen extends StatefulWidget {
  final Movie movie;

  const ShowtimePickerScreen({Key? key, required this.movie}) : super(key: key);

  @override
  State<ShowtimePickerScreen> createState() => _ShowtimePickerScreenState();
}

class _ShowtimePickerScreenState extends State<ShowtimePickerScreen> {
  DateTime selectedDate = DateTime.now();
  Showtime? selectedShowtime;
  List<Showtime> availableShowtimes = [];
  Cinema? nearestCinema;

  @override
  void initState() {
    super.initState();
    _fetchShowtimesAndNearestCinema();
  }

  void _fetchShowtimesAndNearestCinema() {
    setState(() {
      availableShowtimes = _getFilteredShowtimes(selectedDate);

      if (availableShowtimes.isNotEmpty) {
        String roomId = availableShowtimes.first.roomId;
        Room? room = rooms.firstWhere((r) => r.id == roomId,
            orElse: () => Room(id: "", cinemaId: "", name: "", seatCount: 0));
        nearestCinema = cinemas.firstWhere((c) => c.id == room.cinemaId,
            orElse: () => Cinema(
                id: "", name: "Không tìm thấy", districtId: "", address: ""));
      }
    });
  }

  List<Showtime> _getFilteredShowtimes(DateTime date) {
    return showtimes
        .where((s) =>
            s.movieId == widget.movie.id &&
            s.dateTime.year == date.year &&
            s.dateTime.month == date.month &&
            s.dateTime.day == date.day)
        .toList();
  }

  void _onDateSelected(String formattedDate) {
    setState(() {
      selectedDate = DateFormat('yyyy-MM-dd').parse(formattedDate);
      availableShowtimes = _getFilteredShowtimes(selectedDate);
      selectedShowtime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff252429),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 20, right: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white24, width: 1.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  Text(widget.movie.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold)),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              height: 120,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DatePicker(onDateSelected: _onDateSelected),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (nearestCinema != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_rounded, color: Colors.white),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Rạp phim gần nhất",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text(nearestCinema!.name,
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 15.0)),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.white),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            if (availableShowtimes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TimePicker(
                  availableShowtimes: availableShowtimes,
                  onTimeSelected: (Showtime showtime) {
                    setState(() {
                      selectedShowtime = showtime;
                    });
                  },
                ),
              )
            else
              const Text("Không có suất chiếu khả dụng",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 20),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
              child: GestureDetector(
                onTap: selectedShowtime != null
                    ? () => print("Đặt vé cho suất ${selectedShowtime!.id}")
                    : null,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: selectedShowtime != null
                          ? Colors.orangeAccent
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(30)),
                  child: const Center(
                    child: Text("Đặt Vé",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold)),
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
