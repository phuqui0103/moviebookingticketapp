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
import 'seat_selection_screen.dart';

class CinemaBookingScreen extends StatefulWidget {
  final Cinema cinema;

  const CinemaBookingScreen({Key? key, required this.cinema}) : super(key: key);

  @override
  State<CinemaBookingScreen> createState() => _CinemaBookingScreenState();
}

class _CinemaBookingScreenState extends State<CinemaBookingScreen> {
  DateTime selectedDate = DateTime.now();
  Showtime? selectedShowtime;
  List<Showtime> availableShowtimes = [];
  List<Movie> moviesShowing = [];

  @override
  void initState() {
    super.initState();
    _fetchShowtimesAndMovies();
  }

  void _fetchShowtimesAndMovies() {
    setState(() {
      availableShowtimes = _getFilteredShowtimes(selectedDate);
      moviesShowing = availableShowtimes
          .map((showtime) =>
              movies.firstWhere((movie) => movie.id == showtime.movieId))
          .toSet()
          .toList();
    });
  }

  List<Showtime> _getFilteredShowtimes(DateTime date) {
    return showtimes
        .where((s) =>
            rooms.any((room) =>
                room.id == s.roomId && room.cinemaId == widget.cinema.id) &&
            s.startTime.year == date.year &&
            s.startTime.month == date.month &&
            s.startTime.day == date.day)
        .toList();
  }

  void _onDateSelected(String formattedDate) {
    setState(() {
      selectedDate = DateFormat('yyyy-MM-dd').parse(formattedDate);
      _fetchShowtimesAndMovies();
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  Text(widget.cinema.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold)),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
            if (availableShowtimes.isNotEmpty == false)
              Column(children: [
                const SizedBox(
                  height: 120,
                ),
                Text("Không có suất chiếu khả dụng",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ]),
            for (var movie in moviesShowing)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(movie.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            movie.imagePath,
                            height: 100,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TimePicker(
                            availableShowtimes: availableShowtimes
                                .where((s) => s.movieId == movie.id)
                                .toList(),
                            onTimeSelected: (Showtime showtime) {
                              setState(() {
                                selectedShowtime = showtime;
                              });
                            },
                            height: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: selectedShowtime == null
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceBetween,
            children: [
              if (selectedShowtime != null)
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        "${selectedShowtime!.availableSeats} ghế trống",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              if (selectedShowtime != null) const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: selectedShowtime != null
                      ? () {
                          final selectedMovie = moviesShowing.firstWhere(
                            (movie) => movie.id == selectedShowtime!.movieId,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeatSelectionScreen(
                                showtime: selectedShowtime!,
                                movieTitle: selectedMovie.title,
                                moviePoster: selectedMovie
                                    .imagePath, // Truyền movie.title vào
                              ),
                            ),
                          );
                        }
                      : null,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: selectedShowtime != null
                          ? Colors.orangeAccent
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        "Đặt vé",
                        style: const TextStyle(
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
      ),
    );
  }
}
