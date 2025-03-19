import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Components/bottom_nav_bar.dart';
import '../../Components/date_picker.dart';
import '../../Components/time_picker.dart';
import '../../Data/data.dart';
import '../../Model/Movie.dart';
import '../../Model/Province.dart';
import '../../Model/Room.dart';
import '../../Model/Showtime.dart';
import '../../Model/Cinema.dart';
import 'seat_selection_screen.dart';
import 'province_list_screen.dart';

class ShowtimePickerScreen extends StatefulWidget {
  final Movie movie;

  const ShowtimePickerScreen({Key? key, required this.movie}) : super(key: key);

  @override
  State<ShowtimePickerScreen> createState() => _ShowtimePickerScreenState();
}

class _ShowtimePickerScreenState extends State<ShowtimePickerScreen> {
  DateTime selectedDate = DateTime.now();
  Showtime? selectedShowtime;
  Cinema? selectedCinema;
  List<Cinema> availableCinemas = [];
  Map<String, List<Showtime>> cinemaShowtimes = {};
  String selectedProvince = "Tất cả tỉnh";

  @override
  void initState() {
    super.initState();
    _fetchCinemasAndShowtimes();
  }

  void _fetchCinemasAndShowtimes() {
    setState(() {
      cinemaShowtimes.clear();
      availableCinemas.clear();
      List<Showtime> filteredShowtimes = _getFilteredShowtimes(selectedDate);

      for (var showtime in filteredShowtimes) {
        Room? room = rooms.firstWhere((r) => r.id == showtime.roomId,
            orElse: () => Room(
                id: "",
                cinemaId: "",
                name: "",
                rows: 0,
                cols: 0,
                seatLayout: []));
        Cinema? cinema = cinemas.firstWhere((c) => c.id == room.cinemaId,
            orElse: () => Cinema(
                id: "", name: "Không tìm thấy", provinceId: "", address: ""));

        if (cinema.id.isNotEmpty) {
          if (!cinemaShowtimes.containsKey(cinema.id)) {
            cinemaShowtimes[cinema.id] = [];
            availableCinemas.add(cinema);
          }
          cinemaShowtimes[cinema.id]!.add(showtime);
        }
      }

      // Nếu đã chọn tỉnh, chỉ hiển thị rạp thuộc tỉnh đó
      if (selectedProvince != "Tất cả tỉnh") {
        availableCinemas = availableCinemas
            .where((c) =>
                c.provinceId ==
                provinces
                    .firstWhere(
                      (p) => p.name == selectedProvince,
                      orElse: () => Province(id: "", name: ""),
                    )
                    .id)
            .toList();
      }

      if (availableCinemas.isNotEmpty) {
        selectedCinema = availableCinemas.first;
      }
    });
  }

  List<Showtime> _getFilteredShowtimes(DateTime date) {
    return showtimes
        .where((s) =>
            s.movieId == widget.movie.id &&
            s.startTime.year == date.year &&
            s.startTime.month == date.month &&
            s.startTime.day == date.day)
        .toList();
  }

  void _onDateSelected(String formattedDate) {
    setState(() {
      selectedDate = DateFormat('yyyy-MM-dd').parse(formattedDate);
      _fetchCinemasAndShowtimes();
      selectedShowtime = null;
    });
  }

  void _onCinemaSelected(Cinema cinema) {
    setState(() {
      selectedCinema = cinema;
      selectedShowtime = null;
    });
  }

  void _fetchCinemasByProvince(String provinceId) {
    setState(() {
      selectedProvince = provinces
          .firstWhere(
            (p) => p.id == provinceId,
            orElse: () => Province(id: "", name: "Tất cả tỉnh"),
          )
          .name;

      availableCinemas =
          cinemas.where((c) => c.provinceId == provinceId).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff252429),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Làm trong suốt AppBar
        elevation: 0,
        centerTitle: true, // Căn giữa tiêu đề
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.movie.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.movie.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 90.0, left: 20, right: 20),
                ),
                const SizedBox(height: 10),
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
                GestureDetector(
                  onTap: () async {
                    final selectedProvinceId = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProvinceListScreen()),
                    );

                    if (selectedProvinceId is String) {
                      _fetchCinemasByProvince(selectedProvinceId);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Chọn rạp - ${selectedProvince}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold)),
                        const Icon(Icons.arrow_forward_ios,
                            color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
                // Danh sách các rạp có suất chiếu
                if (availableCinemas.isNotEmpty)
                  Column(
                    children: availableCinemas.map((cinema) {
                      bool isSelected = cinema == selectedCinema;
                      return GestureDetector(
                        onTap: () => _onCinemaSelected(cinema),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.orangeAccent
                                : Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on_rounded,
                                  color: Colors.white),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(cinema.name,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Icon(
                                  isSelected
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  color: Colors.white),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 20),

                // Hiển thị các suất chiếu theo rạp đã chọn
                if (selectedCinema != null &&
                    cinemaShowtimes[selectedCinema!.id] != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TimePicker(
                      availableShowtimes: cinemaShowtimes[selectedCinema!.id]!,
                      onTimeSelected: (Showtime showtime) {
                        setState(() {
                          selectedShowtime = showtime;
                        });
                      },
                      height: 30,
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: const Text("Không có suất chiếu khả dụng",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.black, // Thêm màu đen cho background
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          "${selectedShowtime!.availableSeats} ghế trống",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                if (selectedShowtime != null) const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: selectedShowtime != null
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SeatSelectionScreen(
                                  showtime: selectedShowtime!,
                                  movieTitle: widget.movie.title,
                                  moviePoster: widget.movie.imagePath,
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
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Text("Đặt vé",
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
        ),
      ),
    );
  }
}
