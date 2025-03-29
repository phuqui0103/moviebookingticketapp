import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Components/time_picker.dart';
import '../../Components/custom_image_widget.dart';
import '../../Model/Movie.dart';
import '../../Model/Showtime.dart';
import '../../Model/Cinema.dart';
import '../../Model/Genre.dart';
import '../../Services/showtime_service.dart';
import '../../Services/movie_service.dart';
import 'seat_selection_screen.dart';
import 'package:provider/provider.dart';
import '../../Providers/user_provider.dart';
import 'login_screen.dart';
import '../../Model/Room.dart';

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
  Map<String, bool> selectedTimeStates = {};
  Map<String, Room> roomsMap = {};
  final ShowtimeService _showtimeService = ShowtimeService();
  final MovieService _movieService = MovieService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tạo danh sách ngày cho 7 ngày tiếp theo
  List<DateTime> get dateList {
    final now = DateTime.now();
    return List.generate(7, (index) => now.add(Duration(days: index)));
  }

  @override
  void initState() {
    super.initState();
    _fetchShowtimesAndMovies();
  }

  Future<void> _fetchShowtimesAndMovies() async {
    try {
      // Lấy thời gian hiện tại
      final now = DateTime.now();

      // Tạo timestamp cho đầu và cuối ngày
      final startOfDay =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      // Lấy danh sách suất chiếu theo rạp và thời gian
      final showtimesSnapshot = await _firestore
          .collection('showtimes')
          .where('cinemaId', isEqualTo: widget.cinema.id)
          .where('startTime',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('startTime', isLessThan: Timestamp.fromDate(endOfDay))
          .get();

      print(
          'Found ${showtimesSnapshot.docs.length} showtimes for cinema ${widget.cinema.id} on date: $selectedDate');

      // Lấy thông tin phòng trước
      final roomsSnapshot = await _firestore
          .collection('rooms')
          .where('cinemaId', isEqualTo: widget.cinema.id)
          .get();

      roomsMap.clear();
      for (var doc in roomsSnapshot.docs) {
        final data = doc.data();
        roomsMap[doc.id] = Room(
          id: doc.id,
          cinemaId: data['cinemaId'] as String,
          name: data['name'] as String,
          rows: data['rows'] as int,
          cols: data['cols'] as int,
          seatLayout: [],
        );
      }

      // Xử lý dữ liệu suất chiếu
      final showtimes = showtimesSnapshot.docs
          .map((doc) {
            try {
              final data = doc.data();
              final startTime = (data['startTime'] as Timestamp).toDate();
              final bookedSeats = List<String>.from(data['bookedSeats'] ?? []);
              final roomId = data['roomId'] as String;
              final room = roomsMap[roomId];

              if (room == null) {
                print('Room not found for showtime ${doc.id}');
                return null;
              }

              return Showtime(
                id: doc.id,
                movieId: data['movieId'] as String,
                cinemaId: widget.cinema.id,
                roomId: roomId,
                startTime: startTime,
                bookedSeats: bookedSeats,
                totalSeats: room.rows * room.cols,
              );
            } catch (e) {
              print('Error processing showtime document ${doc.id}: $e');
              return null;
            }
          })
          .whereType<Showtime>()
          .toList();

      // **Lọc bỏ suất chiếu đã quá 1 giờ**
      final filteredShowtimes = showtimes.where((showtime) {
        return now.isBefore(showtime.startTime.add(const Duration(hours: 1)));
      }).toList();

      // Lấy thông tin phim cho mỗi suất chiếu
      final movieIds = filteredShowtimes.map((s) => s.movieId).toSet();
      final movies = await Future.wait(
        movieIds.map((id) => _firestore.collection('movies').doc(id).get()),
      );

      final validMovies = movies.where((doc) => doc.exists).map((doc) {
        final data = doc.data()!;
        return Movie(
          id: doc.id,
          title: data['title'] as String,
          description: data['description'] as String,
          duration: data['duration'].toString(),
          imagePath: data['imagePath'] as String,
          trailerUrl: data['trailerUrl'] as String,
          isShowingNow: data['isShowingNow'] as bool,
          cast: List<String>.from(data['cast'] ?? []),
          reviewCount: data['reviewCount'] as int? ?? 0,
          releaseDate: data['releaseDate'] is Timestamp
              ? (data['releaseDate'] as Timestamp).toDate().toString()
              : data['releaseDate'] as String,
          director: data['director'] as String,
          genres: (data['genres'] as List? ?? [])
              .map((genre) => Genre.fromJson(genre))
              .toList(),
        );
      }).toList();

      print('Found ${validMovies.length} valid movies');
      print(
          'Found ${filteredShowtimes.length} valid showtimes (after filtering)');

      setState(() {
        availableShowtimes = filteredShowtimes;
        moviesShowing = validMovies;
      });
    } catch (e) {
      print('Error fetching showtimes and movies: $e');
      setState(() {
        availableShowtimes = [];
        moviesShowing = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Có lỗi xảy ra khi tải dữ liệu'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
      selectedShowtime = null;
      selectedTimeStates.clear();
    });
    _fetchShowtimesAndMovies();
  }

  Widget _buildDatePicker() {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dateList.length,
        itemBuilder: (context, index) {
          final date = dateList[index];
          final isSelected = DateFormat('yyyy-MM-dd').format(date) ==
              DateFormat('yyyy-MM-dd').format(selectedDate);

          return GestureDetector(
            onTap: () => _onDateSelected(date),
            child: Container(
              width: 70,
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange : Colors.black38,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isSelected ? Colors.orangeAccent : Colors.grey,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(date),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    DateFormat('dd').format(date),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    DateFormat('MM').format(date),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff252429),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.only(
                  top: 50.0, left: 20, right: 20, bottom: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Spacer(),
                  Text(
                    widget.cinema.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Date Picker Container
            Container(
              height: 120,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDatePicker(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Movies List
            if (availableShowtimes.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Text(
                  "Không có suất chiếu khả dụng",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              )
            else
              for (var movie in moviesShowing)
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            height: 120,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CustomImageWidget(
                                imagePath: movie.imagePath,
                                width: 80,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: TimePicker(
                              availableShowtimes: availableShowtimes
                                  .where((s) => s.movieId == movie.id)
                                  .toList(),
                              onTimeSelected: (Showtime showtime) {
                                setState(() {
                                  selectedTimeStates.clear();
                                  selectedTimeStates[showtime.id] = true;
                                  selectedShowtime = showtime;
                                });
                              },
                              height: 30,
                              selectedTimeStates: selectedTimeStates,
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
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
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.orange.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        selectedShowtime!.bookedSeats.length <
                                selectedShowtime!.totalSeats
                            ? "Còn ghế"
                            : "Hết ghế",
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
                          final userProvider =
                              Provider.of<UserProvider>(context, listen: false);
                          if (userProvider.currentUser == null) {
                            // Nếu chưa đăng nhập, chuyển đến trang đăng nhập
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          } else {
                            // Nếu đã đăng nhập, chuyển đến trang chọn ghế
                            final selectedMovie = moviesShowing.firstWhere(
                              (movie) => movie.id == selectedShowtime!.movieId,
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SeatSelectionScreen(
                                  showtime: selectedShowtime!,
                                  movieTitle: selectedMovie.title,
                                  moviePoster: selectedMovie.imagePath,
                                ),
                              ),
                            );
                          }
                        }
                      : null,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: selectedShowtime != null
                            ? [Colors.orange, Colors.orange.shade700]
                            : [Colors.grey, Colors.grey.shade700],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: selectedShowtime != null
                          ? [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        "Đặt vé",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
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
