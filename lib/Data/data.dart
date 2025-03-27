import '../Model/Cinema.dart';
import '../Model/Comment.dart';
import '../Model/District.dart';
import '../Model/Food.dart';
import '../Model/Movie.dart';
import '../Model/Province.dart';
import '../Model/Room.dart';
import '../Model/Seat.dart';
import '../Model/Showtime.dart';
import '../Model/Ticket.dart';
import '../Model/Genre.dart';
import '../Model/User.dart';

final sampleUser = User(
  id: "user123",
  fullName: "Nguyễn Văn A",
  phoneNumber: "0123456789",
  email: "nguyenvana@gmail.com",
  hashedPassword:
      "hashedPassword123", // In real app, this should be properly hashed
  birthDate: DateTime(1995, 5, 15),
  gender: "Nam",
  province: "Hồ Chí Minh",
  district: "Quận 1",
  status: "Active",
  createdAt: DateTime(2024, 1, 1),
  updatedAt: DateTime(2024, 3, 15),
);

final List<Genre> genres = [
  Genre(id: "0", name: "Tất cả"),
  Genre(id: "1", name: "Tâm lý"),
  Genre(id: "2", name: "Kịch tính"),
  Genre(id: "3", name: "Tình cảm"),
  Genre(id: "4", name: "Lãng mạn"),
  Genre(id: "5", name: "Tài liệu"),
  Genre(id: "6", name: "Tiểu sử"),
  Genre(id: "7", name: "Hành động"),
  Genre(id: "8", name: "Hài hước"),
];

List<Province> provinces = [
  Province(id: "1", name: "Hà Nội"),
  Province(id: "2", name: "Hồ Chí Minh"),
  Province(id: "3", name: "Đà Nẵng"),
  Province(id: "4", name: "Cần Thơ"),
  Province(id: "5", name: "Hải Phòng"),
];

final List<District> district = [
  District(id: "h1", name: "Long Xuyên", provinceId: "t1"),
  District(id: "h2", name: "Cao Lãnh", provinceId: "t2")
];
List<Cinema> cinemas = [
  // Rạp ở Hà Nội
  Cinema(
      id: "101",
      name: "CGV Vincom Bà Triệu",
      provinceId: "1",
      address: "Vincom Center, 191 Bà Triệu, Hà Nội"),
  Cinema(
      id: "102",
      name: "Lotte Cinema Tây Sơn",
      provinceId: "1",
      address: "229 Tây Sơn, Đống Đa, Hà Nội"),
  Cinema(
      id: "103",
      name: "BHD Star Phạm Ngọc Thạch",
      provinceId: "1",
      address: "Vincom, 2 Phạm Ngọc Thạch, Hà Nội"),

  // Rạp ở Hồ Chí Minh
  Cinema(
      id: "201",
      name: "CGV VivoCity",
      provinceId: "2",
      address: "SC VivoCity, Quận 7, TP. Hồ Chí Minh"),
  Cinema(
      id: "202",
      name: "BHD Star 3/2",
      provinceId: "2",
      address: "Lầu 5, Siêu thị Maximark, 3/2, Quận 10"),
  Cinema(
      id: "203",
      name: "Lotte Cinema Nam Sài Gòn",
      provinceId: "2",
      address: "Quận 7, TP. Hồ Chí Minh"),

  // Rạp ở Đà Nẵng
  Cinema(
      id: "301",
      name: "CGV Vĩnh Trung Plaza",
      provinceId: "3",
      address: "Vĩnh Trung Plaza, Thanh Khê, Đà Nẵng"),
  Cinema(
      id: "302",
      name: "Lotte Cinema Đà Nẵng",
      provinceId: "3",
      address: "6 Nại Nam, Hải Châu, Đà Nẵng"),

  // Rạp ở Cần Thơ
  Cinema(
      id: "401",
      name: "CGV Sense City Cần Thơ",
      provinceId: "4",
      address: "Sense City, Ninh Kiều, Cần Thơ"),

  // Rạp ở Hải Phòng
  Cinema(
      id: "501",
      name: "Lotte Cinema Hải Phòng",
      provinceId: "5",
      address: "Vincom Imperia, Hải Phòng"),
];

final List<Room> rooms = [
  Room(
    id: "101",
    cinemaId: "101",
    name: "Phòng 1",
    rows: 8,
    cols: 8,
    seatLayout: [],
  ),
  Room(
    id: "201",
    cinemaId: "202",
    name: "Phòng 1",
    rows: 8,
    cols: 10,
    seatLayout: [],
  ),
  Room(
      id: "301",
      cinemaId: "301",
      name: "Phòng 1",
      rows: 9,
      cols: 11,
      seatLayout: []),
  Room(
      id: "302",
      cinemaId: "201",
      name: "Phòng 1",
      rows: 9,
      cols: 12,
      seatLayout: []),
  Room(
      id: "202",
      cinemaId: "202",
      name: "Phòng 2",
      rows: 9,
      cols: 13,
      seatLayout: []),
];

final List<Showtime> showtimes = [
  Showtime(
    id: "show_1",
    movieId: "movie_1",
    cinemaId: "202",
    roomId: "201",
    startTime: DateTime.now().add(Duration(days: 1, hours: 2)),
    bookedSeats: ["A1", "A2", "B5", "B6"],
  ),
  Showtime(
    id: "show_2",
    movieId: "movie_2",
    cinemaId: "202",
    roomId: "201",
    startTime: DateTime.now().add(Duration(days: 1, hours: 5)),
    bookedSeats: ["C5", "C6", "C7"],
  ),
  Showtime(
    id: "show_3",
    movieId: "movie_4",
    cinemaId: "201",
    roomId: "302",
    startTime: DateTime.now().add(Duration(days: 2)),
    bookedSeats: ["E4", "E5", "F1", "F2"],
  ),
];

// Danh sách ghế
final List<Seat> seats = [
  Seat(id: "1", row: "A", column: 1, isVip: false, isBooked: true),
  Seat(id: "2", row: "A", column: 2, isVip: false, isBooked: false),
  Seat(id: "3", row: "B", column: 1, isVip: true, isBooked: false),
  Seat(id: "4", row: "B", column: 2, isVip: true, isBooked: true),
  Seat(id: "5", row: "C", column: 3, isVip: false, isBooked: true),
  Seat(id: "6", row: "D", column: 4, isVip: false, isBooked: true),
  Seat(id: "7", row: "E", column: 5, isVip: true, isBooked: true),
];

final List<Food> foodItems = [
  Food(
    id: "food_1",
    name: "Bắp rang bơ",
    price: 45000,
    image: "assets/images/bapnuoc.png",
    description: "Bắp rang giòn tan, vị bơ thơm ngon",
  ),
  Food(
    id: "food_2",
    name: "Nước ngọt lớn",
    price: 35000,
    image: "assets/images/bapnuoc.png",
    description: "Nước ngọt mát lạnh, nhiều vị lựa chọn",
  ),
  Food(
    id: "food_3",
    name: "Combo bắp nước",
    price: 75000,
    image: "assets/images/bapnuoc.png",
    description: "Combo tiết kiệm: 1 bắp lớn + 1 nước lớn",
  ),
  Food(
    id: "food_4",
    name: "Bắp rang phô mai",
    price: 55000,
    image: "assets/images/bapnuoc.png",
    description: "Bắp rang phô mai thơm ngon, béo ngậy",
  ),
  Food(
    id: "food_5",
    name: "Bắp rang caramel",
    price: 50000,
    image: "assets/images/bapnuoc.png",
    description: "Bắp rang vị caramel ngọt ngào",
  ),
  Food(
    id: "food_6",
    name: "Nước ngọt nhỏ",
    price: 25000,
    image: "assets/images/bapnuoc.png",
    description: "Nước ngọt mát lạnh, nhiều vị lựa chọn",
  ),
  Food(
    id: "food_7",
    name: "Combo gia đình",
    price: 150000,
    image: "assets/images/bapnuoc.png",
    description: "Combo gia đình: 2 bắp lớn + 2 nước lớn",
  ),
  Food(
    id: "food_8",
    name: "Bắp rang mix",
    price: 65000,
    image: "assets/images/bapnuoc.png",
    description: "Bắp rang mix 3 vị: bơ, phô mai, caramel",
  ),
  Food(
    id: "food_9",
    name: "Combo đôi",
    price: 95000,
    image: "assets/images/bapnuoc.png",
    description: "Combo đôi: 1 bắp lớn + 2 nước lớn",
  ),
  Food(
    id: "food_10",
    name: "Bắp rang hải sản",
    price: 60000,
    image: "assets/images/bapnuoc.png",
    description: "Bắp rang vị hải sản độc đáo",
  ),
];

List<Ticket> myTickets = [
  Ticket(
    id: "ticket_1",
    showtime: showtimes[0],
    selectedSeats: ["A1", "A2"],
    selectedFoods: {
      "Bắp rang bơ": 1,
      "Nước ngọt lớn": 2,
    },
    totalPrice: 215000,
    isUsed: false,
  ),
  Ticket(
    id: "ticket_2",
    showtime: showtimes[1],
    selectedSeats: ["C5", "C6", "C7"],
    selectedFoods: {
      "Combo bắp nước": 2,
    },
    totalPrice: 300000,
    isUsed: true,
  ),
  Ticket(
    id: "ticket_3",
    showtime: showtimes[2],
    selectedSeats: ["E4", "E5"],
    selectedFoods: {
      "Bắp rang bơ": 1,
      "Nước ngọt lớn": 1,
    },
    totalPrice: 180000,
    isUsed: false,
  ),
];
