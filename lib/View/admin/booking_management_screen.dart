import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movieticketbooking/Model/Room.dart';
import '../../Model/Ticket.dart';
import '../../Model/Movie.dart';
import '../../Model/Cinema.dart';
import '../../Data/data.dart';

class BookingManagementScreen extends StatefulWidget {
  const BookingManagementScreen({Key? key}) : super(key: key);

  @override
  _BookingManagementScreenState createState() =>
      _BookingManagementScreenState();
}

class _BookingManagementScreenState extends State<BookingManagementScreen> {
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  String? selectedProvinceId;
  String? selectedCinemaId;
  DateTime selectedDate = DateTime.now();
  String? selectedShowtimeId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff252429),
      body: Column(
        children: [
          _buildProvinceSelector(),
          if (selectedProvinceId != null) _buildCinemaSelector(),
          if (selectedCinemaId != null) _buildShowtimeSelector(),
          _buildDateSelector(),
          Expanded(
            child: _buildTicketsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      style: const TextStyle(color: Colors.white),
      onChanged: (value) => setState(() => searchQuery = value),
      decoration: const InputDecoration(
        hintText: "Tìm kiếm vé...",
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
        suffixIcon: Icon(Icons.search, color: Colors.white),
      ),
    );
  }

  Widget _buildProvinceSelector() {
    return Container(
      padding: const EdgeInsets.only(right: 15, left: 15, top: 10, bottom: 10),
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
        hint: const Text('Chọn Tỉnh/Thành phố',
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
          });
        },
      ),
    );
  }

  Widget _buildCinemaSelector() {
    final filteredCinemas = cinemas
        .where((cinema) => cinema.provinceId == selectedProvinceId)
        .toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
        hint: const Text('Chọn Rạp', style: TextStyle(color: Colors.white70)),
        items: filteredCinemas.map((cinema) {
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

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
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

  Widget _buildShowtimeSelector() {
    if (selectedCinemaId == null) return const SizedBox.shrink();

    final filteredShowtimes = showtimes.where((showtime) {
      return showtime.cinemaId == selectedCinemaId &&
          showtime.startTime.year == selectedDate.year &&
          showtime.startTime.month == selectedDate.month &&
          showtime.startTime.day == selectedDate.day;
    }).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<String>(
        value: selectedShowtimeId,
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
        hint: const Text('Chọn Suất chiếu',
            style: TextStyle(color: Colors.white70)),
        items: filteredShowtimes.map((showtime) {
          Movie movie = movies.firstWhere((m) => m.id == showtime.movieId);
          return DropdownMenuItem<String>(
            value: showtime.id,
            child: Text('${movie.title} - ${showtime.formattedTime}'),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedShowtimeId = newValue;
          });
        },
      ),
    );
  }

  Widget _buildTicketsList() {
    if (selectedProvinceId == null) {
      return const Center(
        child: Text(
          "Vui lòng chọn Tỉnh/Thành phố",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    if (selectedCinemaId == null) {
      return const Center(
        child: Text(
          "Vui lòng chọn Rạp",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    List<Ticket> filteredTickets = myTickets.where((ticket) {
      bool matchesDate = ticket.showtime.startTime.year == selectedDate.year &&
          ticket.showtime.startTime.month == selectedDate.month &&
          ticket.showtime.startTime.day == selectedDate.day;

      bool matchesCinema = ticket.showtime.cinemaId == selectedCinemaId;

      bool matchesShowtime = selectedShowtimeId == null ||
          ticket.showtime.id == selectedShowtimeId;

      Movie movie = movies.firstWhere((m) => m.id == ticket.showtime.movieId);
      bool matchesSearch = searchQuery.isEmpty ||
          movie.title.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesDate && matchesCinema && matchesShowtime && matchesSearch;
    }).toList();

    return filteredTickets.isEmpty
        ? const Center(
            child: Text(
              "Không có vé nào!",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          )
        : ListView.builder(
            itemCount: filteredTickets.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              return _buildTicketCard(filteredTickets[index]);
            },
          );
  }

  Widget _buildTicketCard(Ticket ticket) {
    Movie movie = movies.firstWhere((m) => m.id == ticket.showtime.movieId);
    Cinema cinema = cinemas.firstWhere((c) => c.id == ticket.showtime.cinemaId);
    Room room = rooms.firstWhere((r) => r.id == ticket.showtime.roomId);

    return GestureDetector(
      onTap: () => _showTicketDetails(ticket),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            // Poster phim
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.network(
                movie.imagePath,
                width: 100,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100,
                  height: 150,
                  color: Colors.black26,
                  child:
                      const Icon(Icons.movie, color: Colors.orange, size: 40),
                ),
              ),
            ),
            // Thông tin vé
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            color: Colors.orange, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          ticket.showtime.formattedTime,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.event_seat,
                            color: Colors.orange, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Ghế: ${ticket.selectedSeats.join(", ")} (${ticket.showtime.bookedSeats.length}/${room.rows * room.cols})",
                            style: const TextStyle(color: Colors.white70),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.attach_money,
                            color: Colors.orange, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          "${NumberFormat("#,###").format(ticket.totalPrice)}đ",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Trạng thái vé
            Container(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    ticket.isUsed ? Icons.check_circle : Icons.pending,
                    color: ticket.isUsed ? Colors.green : Colors.orange,
                    size: 28,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ticket.isUsed ? "Đã sử dụng" : "Chưa sử dụng",
                    style: TextStyle(
                      color: ticket.isUsed ? Colors.green : Colors.orange,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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

  void _showTicketDetails(Ticket ticket) {
    Movie movie = movies.firstWhere((m) => m.id == ticket.showtime.movieId);
    Cinema cinema = cinemas.firstWhere((c) => c.id == ticket.showtime.cinemaId);
    Room room = rooms.firstWhere((r) => r.id == ticket.showtime.roomId);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xff252429),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  const Icon(Icons.confirmation_number, color: Colors.orange),
                  const SizedBox(width: 8),
                  const Text(
                    "Chi tiết vé",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(color: Colors.orange),

              // Thông tin phim
              ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    movie.imagePath,
                    width: 60,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  movie.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  movie.duration,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 16),

              // Thông tin suất chiếu
              _buildDetailRow(Icons.access_time, "Thời gian",
                  "${DateFormat('dd/MM/yyyy').format(ticket.showtime.startTime)} - ${ticket.showtime.formattedTime}"),
              _buildDetailRow(Icons.location_on, "Rạp", cinema.name),
              _buildDetailRow(Icons.meeting_room, "Phòng", room.name),
              _buildDetailRow(
                  Icons.event_seat, "Ghế", ticket.selectedSeats.join(", ")),

              // Thông tin đồ ăn nếu có
              if (ticket.selectedFoods.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text(
                  "Đồ ăn & Thức uống",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ...ticket.selectedFoods.entries.map((food) => _buildDetailRow(
                    Icons.fastfood, food.key, "x${food.value}")),
              ],

              const Divider(color: Colors.orange),

              // Tổng tiền và trạng thái
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tổng tiền: ${NumberFormat("#,###").format(ticket.totalPrice)}đ",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: ticket.isUsed ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      ticket.isUsed ? "Đã sử dụng" : "Chưa sử dụng",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 20),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
