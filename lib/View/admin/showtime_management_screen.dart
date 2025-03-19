import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Model/Movie.dart';
import '../../Model/Showtime.dart';
import '../../Model/Cinema.dart';
import '../../Model/Room.dart';
import '../../Data/data.dart';

class ShowtimeManagementScreen extends StatefulWidget {
  const ShowtimeManagementScreen({Key? key}) : super(key: key);

  @override
  _ShowtimeManagementScreenState createState() =>
      _ShowtimeManagementScreenState();
}

class _ShowtimeManagementScreenState extends State<ShowtimeManagementScreen> {
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String? selectedProvinceId;
  String? selectedCinemaId;
  String? selectedMovieId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff252429),
      body: Column(
        children: [
          _buildProvinceSelector(),
          if (selectedProvinceId != null) _buildCinemaSelector(),
          _buildMovieSelector(),
          _buildDateSelector(),
          Expanded(
            child: _buildShowtimesList(),
          ),
        ],
      ),
      floatingActionButton: selectedCinemaId != null
          ? FloatingActionButton(
              onPressed: () => _showAddShowtimeDialog(),
              backgroundColor: Colors.orange,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      style: const TextStyle(color: Colors.white),
      onChanged: (value) => setState(() => searchQuery = value),
      decoration: const InputDecoration(
        hintText: "Tìm kiếm suất chiếu...",
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
        suffixIcon: Icon(Icons.search, color: Colors.white),
      ),
    );
  }

  Widget _buildProvinceSelector() {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: DropdownButtonFormField<String>(
        value: selectedProvinceId,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black12,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.orange.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.orange.withOpacity(0.3)),
          ),
        ),
        dropdownColor: const Color(0xff252429),
        style: const TextStyle(color: Colors.white),
        hint: const Text('Chọn tỉnh/thành phố',
            style: TextStyle(color: Colors.white70)),
        items: provinces.map((province) {
          return DropdownMenuItem<String>(
            value: province.id,
            child: Text(province.name),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedProvinceId = newValue;
            selectedCinemaId = null;
            selectedMovieId = null;
          });
        },
      ),
    );
  }

  Widget _buildCinemaSelector() {
    // Lọc rạp theo tỉnh đã chọn
    final provinceCinemas = cinemas
        .where((cinema) => cinema.provinceId == selectedProvinceId)
        .toList();

    return Container(
      padding: const EdgeInsets.only(right: 15, left: 15, top: 10, bottom: 10),
      child: DropdownButtonFormField<String>(
        value: selectedCinemaId,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black12,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.orange.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.orange.withOpacity(0.3)),
          ),
        ),
        dropdownColor: const Color(0xff252429),
        style: const TextStyle(color: Colors.white),
        hint: const Text('Chọn rạp chiếu',
            style: TextStyle(color: Colors.white70)),
        items: provinceCinemas.map((Cinema cinema) {
          return DropdownMenuItem<String>(
            value: cinema.id,
            child: Text(cinema.name),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedCinemaId = newValue;
          });
        },
      ),
    );
  }

  Widget _buildMovieSelector() {
    return Container(
      padding: const EdgeInsets.only(right: 15, left: 15),
      child: DropdownButtonFormField<String>(
        value: selectedMovieId,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black12,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.orange.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.orange.withOpacity(0.3)),
          ),
        ),
        dropdownColor: const Color(0xff252429),
        style: const TextStyle(color: Colors.white),
        hint: const Text('Chọn phim', style: TextStyle(color: Colors.white70)),
        items: [
          DropdownMenuItem<String>(
            value: null,
            child: Text('Tất cả phim', style: TextStyle(color: Colors.white70)),
          ),
          ...movies.where((movie) => movie.isShowingNow).map((Movie movie) {
            return DropdownMenuItem<String>(
              value: movie.id,
              child: Text(movie.title),
            );
          }).toList(),
        ],
        onChanged: (String? newValue) {
          setState(() {
            selectedMovieId = newValue;
          });
        },
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.only(right: 15, left: 15, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.orange),
            onPressed: () {
              setState(() {
                selectedDate = selectedDate.subtract(const Duration(days: 1));
              });
            },
          ),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Text(
                DateFormat('dd/MM/yyyy').format(selectedDate),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.orange),
            onPressed: () {
              setState(() {
                selectedDate = selectedDate.add(const Duration(days: 1));
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShowtimesList() {
    if (selectedCinemaId == null) {
      return const Center(
        child: Text(
          "Vui lòng chọn rạp để xem danh sách suất chiếu!",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    List<Showtime> filteredShowtimes = showtimes.where((showtime) {
      bool matchesDate = showtime.startTime.year == selectedDate.year &&
          showtime.startTime.month == selectedDate.month &&
          showtime.startTime.day == selectedDate.day;

      bool matchesCinema = showtime.cinemaId == selectedCinemaId;

      bool matchesMovie =
          selectedMovieId == null || showtime.movieId == selectedMovieId;

      return matchesDate && matchesCinema && matchesMovie;
    }).toList();

    filteredShowtimes.sort((a, b) => a.startTime.compareTo(b.startTime));

    return filteredShowtimes.isEmpty
        ? const Center(
            child: Text(
              "Không có suất chiếu nào!",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          )
        : ListView.builder(
            itemCount: filteredShowtimes.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              return _buildShowtimeCard(filteredShowtimes[index]);
            },
          );
  }

  Widget _buildShowtimeCard(Showtime showtime) {
    Movie movie = movies.firstWhere((m) => m.id == showtime.movieId);
    Room room = rooms.firstWhere((r) => r.id == showtime.roomId);
    Cinema cinema = cinemas.firstWhere((c) => c.id == showtime.cinemaId);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          // Cột thông tin bên trái
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên phim
                  Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Thời gian và địa điểm
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          color: Colors.orange, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        showtime.formattedTime,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.location_on,
                          color: Colors.orange, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          cinema.name,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Thông tin phòng và ghế
                  Row(
                    children: [
                      const Icon(Icons.event_seat,
                          color: Colors.orange, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        "${room.name} (${showtime.availableSeats} ghế trống)",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Cột các nút hành động bên phải
          Container(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange, size: 20),
                  onPressed: () => _showEditShowtimeDialog(showtime),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(height: 12),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () => _deleteShowtime(showtime),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.orange,
              onPrimary: Colors.white,
              surface: Color(0xff252429),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _showAddShowtimeDialog() {
    final _movieController = TextEditingController();
    final _timeController = TextEditingController();
    final _roomController = TextEditingController();
    Movie? selectedMovie;
    Room? selectedRoom;
    DateTime? selectedTime;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff252429),
        title: const Text(
          "Thêm Suất Chiếu",
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Chọn phim
              DropdownButtonFormField<Movie>(
                decoration: InputDecoration(
                  labelText: "Chọn Phim",
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.orange.withOpacity(0.3)),
                  ),
                ),
                dropdownColor: const Color(0xff252429),
                style: const TextStyle(color: Colors.white),
                items: movies
                    .where((movie) => movie.isShowingNow)
                    .map((Movie movie) {
                  return DropdownMenuItem<Movie>(
                    value: movie,
                    child: Text(movie.title),
                  );
                }).toList(),
                onChanged: (Movie? value) {
                  selectedMovie = value;
                },
              ),
              const SizedBox(height: 16),

              // Chọn phòng
              if (selectedCinemaId != null)
                DropdownButtonFormField<Room>(
                  decoration: InputDecoration(
                    labelText: "Chọn Phòng",
                    labelStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.orange.withOpacity(0.3)),
                    ),
                  ),
                  dropdownColor: const Color(0xff252429),
                  style: const TextStyle(color: Colors.white),
                  items: rooms
                      .where((room) => room.cinemaId == selectedCinemaId)
                      .map((Room room) {
                    return DropdownMenuItem<Room>(
                      value: room,
                      child: Text(room.name),
                    );
                  }).toList(),
                  onChanged: (Room? value) {
                    selectedRoom = value;
                  },
                ),
              const SizedBox(height: 16),

              // Chọn giờ
              TextFormField(
                controller: _timeController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Chọn Giờ Chiếu",
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.orange.withOpacity(0.3)),
                  ),
                  suffixIcon:
                      const Icon(Icons.access_time, color: Colors.orange),
                ),
                readOnly: true,
                onTap: () async {
                  final TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: Colors.orange,
                            onPrimary: Colors.white,
                            surface: Color(0xff252429),
                            onSurface: Colors.white,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (time != null) {
                    selectedTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      time.hour,
                      time.minute,
                    );
                    _timeController.text =
                        DateFormat('HH:mm').format(selectedTime!);
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy", style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              if (selectedMovie == null ||
                  selectedRoom == null ||
                  selectedTime == null ||
                  selectedCinemaId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vui lòng điền đầy đủ thông tin!'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final newShowtime = Showtime(
                id: 'st_${DateTime.now().millisecondsSinceEpoch}',
                movieId: selectedMovie!.id,
                cinemaId: selectedCinemaId!,
                roomId: selectedRoom!.id,
                startTime: selectedTime!,
                bookedSeats: [],
              );

              setState(() {
                showtimes.add(newShowtime);
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Thêm suất chiếu thành công!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text("Thêm", style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _showEditShowtimeDialog(Showtime showtime) {
    final Movie movie = movies.firstWhere((m) => m.id == showtime.movieId);
    final Room room = rooms.firstWhere((r) => r.id == showtime.roomId);
    final _timeController = TextEditingController(
      text: DateFormat('HH:mm').format(showtime.startTime),
    );
    DateTime? selectedTime = showtime.startTime;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff252429),
        title: const Text(
          "Chỉnh Sửa Suất Chiếu",
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Hiển thị thông tin phim (không cho phép thay đổi)
              ListTile(
                title: const Text(
                  "Phim",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                subtitle: Text(
                  movie.title,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),

              // Hiển thị thông tin phòng (không cho phép thay đổi)
              ListTile(
                title: const Text(
                  "Phòng",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                subtitle: Text(
                  room.name,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),

              // Chọn giờ mới
              TextFormField(
                controller: _timeController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Giờ Chiếu",
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.orange.withOpacity(0.3)),
                  ),
                  suffixIcon:
                      const Icon(Icons.access_time, color: Colors.orange),
                ),
                readOnly: true,
                onTap: () async {
                  final TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(showtime.startTime),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: Colors.orange,
                            onPrimary: Colors.white,
                            surface: Color(0xff252429),
                            onSurface: Colors.white,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (time != null) {
                    selectedTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      time.hour,
                      time.minute,
                    );
                    _timeController.text =
                        DateFormat('HH:mm').format(selectedTime!);
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy", style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              if (selectedTime == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vui lòng chọn giờ chiếu!'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final updatedShowtime = Showtime(
                id: showtime.id,
                movieId: showtime.movieId,
                cinemaId: showtime.cinemaId,
                roomId: showtime.roomId,
                startTime: selectedTime!,
                bookedSeats: showtime.bookedSeats,
              );

              setState(() {
                final index = showtimes.indexWhere((s) => s.id == showtime.id);
                if (index != -1) {
                  showtimes[index] = updatedShowtime;
                }
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cập nhật suất chiếu thành công!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text("Lưu", style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _deleteShowtime(Showtime showtime) {
    final Movie movie = movies.firstWhere((m) => m.id == showtime.movieId);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff252429),
        title: const Text(
          "Xóa Suất Chiếu",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "Bạn có chắc muốn xóa suất chiếu phim ${movie.title}?",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy", style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                showtimes.removeWhere((s) => s.id == showtime.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã xóa suất chiếu!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text("Xóa", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      selectedMovieId = null;
    });
  }
}
