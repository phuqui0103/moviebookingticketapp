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

final List<Movie> movies = [
  Movie(
    id: "movie_1",
    title: "Ròm",
    imagePath: "assets/images/movie1.jpg",
    trailerUrl:
        "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4",
    duration: "1 giờ 32 phút",
    genres: ["Tâm lý", "Kịch tính"],
    rating: 8.5,
    isShowingNow: true,
    description:
        "Câu chuyện về một cậu bé bán vé số tìm kiếm hy vọng trong những con hẻm của Sài Gòn.",
    cast: ["Trần Anh Khoa", "Nguyễn Phan Anh Tú", "Cát Phượng"],
    reviewCount: 1200,
    releaseDate: "25/09/2020",
    director: "Trần Thanh Huy",
    comments: [
      Comment(
          userName: "An Nguyễn", content: "Phim quá xuất sắc!", rating: 9.0),
      Comment(
          userName: "Minh Trần",
          content: "Tình tiết hấp dẫn và cảm động.",
          rating: 8.5),
      Comment(
          userName: "Minh Trần",
          content: "Tình tiết hấp dẫn và cảm động.",
          rating: 8.5),
      Comment(
          userName: "Minh Trần",
          content: "Tình tiết hấp dẫn và cảm động.",
          rating: 8.5),
      Comment(
          userName: "Minh Trần",
          content: "Tình tiết hấp dẫn và cảm động.",
          rating: 8.5),
    ],
  ),
  Movie(
    id: "movie_2",
    title: "Mai",
    imagePath: "assets/images/movie2.webp",
    trailerUrl:
        "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
    duration: "1 giờ 45 phút",
    genres: ["Tình cảm", "Lãng mạn"],
    rating: 8.0,
    isShowingNow: true,
    description:
        "Một câu chuyện tình yêu đầy cảm động giữa hai con người xa lạ nhưng định mệnh đưa họ đến với nhau.",
    cast: ["Hoàng Thùy Linh", "Quốc Trường", "Lan Ngọc"],
    reviewCount: 950,
    releaseDate: "14/02/2024",
    director: "Nguyễn Quang Dũng",
    comments: [
      Comment(
          userName: "Linh Lê",
          content: "Phim rất lãng mạn và đáng yêu!",
          rating: 8.0),
      Comment(
          userName: "Tú Phạm",
          content: "Câu chuyện cảm động, diễn viên diễn tốt.",
          rating: 8.2),
    ],
  ),
  Movie(
    id: "movie_3",
    title: "Sáng Đèn",
    imagePath: "assets/images/movie3.webp",
    trailerUrl:
        "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4",
    duration: "1 giờ 20 phút",
    genres: ["Tài liệu", "Tiểu sử"],
    rating: 7.8,
    isShowingNow: false,
    description:
        "Bộ phim tài liệu về hành trình của những nghệ sĩ sân khấu Việt Nam trong thời kỳ đổi mới.",
    cast: ["NSND Hồng Vân", "NSƯT Thành Lộc", "NSƯT Hoài Linh"],
    reviewCount: 750,
    releaseDate: "20/08/2023",
    director: "Phạm Hồng Thắng",
    comments: [
      Comment(
          userName: "Bảo Anh",
          content: "Phim tài liệu rất chân thực!",
          rating: 7.8),
    ],
  ),
  Movie(
    id: "movie_4",
    title: "Lật Mặt 4",
    imagePath: "assets/images/movie3.webp",
    trailerUrl: "https://filesamples.com/samples/video/mp4/sample_640x360.mp4",
    duration: "2 giờ 10 phút",
    genres: ["Hành động", "Hài hước"],
    rating: 8.2,
    isShowingNow: true,
    description:
        "Một bộ phim hành động đầy bất ngờ với những pha rượt đuổi nghẹt thở và tình tiết hài hước đặc trưng.",
    cast: ["Lý Hải", "Hứa Minh Đạt", "Mạc Văn Khoa"],
    reviewCount: 1800,
    releaseDate: "19/04/2019",
    director: "Lý Hải",
    comments: [
      Comment(
          userName: "Đức Phan", content: "Phim hành động quá đã!", rating: 8.5),
      Comment(
          userName: "Hải Nam",
          content: "Tình tiết vui nhộn, giải trí tốt.",
          rating: 8.0),
    ],
  ),
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
      rows: 9,
      cols: 9,
      seatLayout: []),
  Room(
      id: "201",
      cinemaId: "202",
      name: "Phòng 1",
      rows: 9,
      cols: 10,
      seatLayout: []),
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
    id: "show_4",
    movieId: "movie_4",
    cinemaId: "cinema_1",
    roomId: "201",
    startTime: DateTime(2025, 3, 15, 13, 0),
    bookedSeats: ["A1", "A2", "B3"], // Ví dụ ghế đã đặt
  ),
  Showtime(
    id: "show_5",
    movieId: "movie_1",
    cinemaId: "cinema_1",
    roomId: "301",
    startTime: DateTime(2025, 3, 15, 1, 0),
    bookedSeats: ["C5", "C6"],
  ),
  Showtime(
    id: "show_6",
    movieId: "movie_1",
    cinemaId: "cinema_1",
    roomId: "202",
    startTime: DateTime(2025, 3, 15, 16, 0),
    bookedSeats: [],
  ),
  Showtime(
    id: "show_10",
    movieId: "movie_1",
    cinemaId: "cinema_2",
    roomId: "201",
    startTime: DateTime(2025, 3, 15, 19, 0),
    bookedSeats: ["D1", "D2", "D3"],
  ),
  Showtime(
    id: "show_11",
    movieId: "movie_1",
    cinemaId: "cinema_2",
    roomId: "101",
    startTime: DateTime(2025, 3, 15, 11, 0),
    bookedSeats: [],
  ),
  Showtime(
    id: "show_7",
    movieId: "movie_1",
    cinemaId: "cinema_1",
    roomId: "101",
    startTime: DateTime(2025, 3, 15, 15, 0),
    bookedSeats: ["E4", "E5", "F6"],
  ),
  Showtime(
    id: "show_8",
    movieId: "movie_1",
    cinemaId: "cinema_1",
    roomId: "201",
    startTime: DateTime(2025, 3, 15, 14, 0),
    bookedSeats: ["G1", "G2"],
  ),
  Showtime(
    id: "show_9",
    movieId: "movie_1",
    cinemaId: "cinema_2",
    roomId: "101",
    startTime: DateTime(2025, 3, 15, 13, 0),
    bookedSeats: [],
  ),
  Showtime(
    id: "show_2",
    movieId: "movie_2",
    cinemaId: "cinema_1",
    roomId: "201",
    startTime: DateTime(2025, 3, 15, 10, 0),
    bookedSeats: ["H10", "H11"],
  ),
  Showtime(
    id: "show_3",
    movieId: "movie_3",
    cinemaId: "cinema_2",
    roomId: "101",
    startTime: DateTime(2025, 3, 14, 13, 30),
    bookedSeats: [],
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
    id: "1",
    name: "Bắp rang bơ",
    price: 50000,
    image: "assets/images/bapnuoc.png",
    description: "Bắp rang giòn tan, vị bơ thơm ngon",
  ),
  Food(
    id: "2",
    name: "Nước ngọt lớn",
    price: 30000,
    image: "assets/images/bapnuoc.png",
    description: "Nước ngọt mát lạnh, nhiều vị lựa chọn",
  ),
  Food(
    id: "3",
    name: "Combo bắp nước",
    price: 70000,
    image: "assets/images/bapnuoc.png",
    description: "Combo tiết kiệm, bắp rang + nước ngọt",
  ),
];

List<Ticket> myTickets = [
  Ticket(
    id: "1",
    showtime: Showtime(
      id: "show_1",
      movieId: "movie_1",
      cinemaId: "202",
      roomId: "202",
      startTime: DateTime(2025, 3, 20, 18, 30),
      bookedSeats: ["A1", "A2"],
    ),
    selectedSeats: ["A1", "A2"],
    selectedFoods: ["Bắp rang", "Nước ngọt"],
    totalPrice: 180000,
    isUsed: false, // Vé chưa sử dụng
  ),
  Ticket(
    id: "2",
    showtime: Showtime(
      id: "show_2",
      movieId: "movie_2",
      cinemaId: "202",
      roomId: "202",
      startTime: DateTime(2025, 3, 21, 20, 00),
      bookedSeats: ["C5", "C6", "C7"],
    ),
    selectedSeats: ["C5", "C6", "C7"],
    selectedFoods: ["Combo bắp nước"],
    totalPrice: 270000,
    isUsed: true,
  )
];
