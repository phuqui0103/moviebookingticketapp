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

final List<Movie> movies = [
  Movie(
    id: "movie_1",
    title: "Ròm",
    imagePath: "https://innovavietnam.vn/wp-content/uploads/poster-561x800.jpg",
    trailerUrl:
        "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4",
    duration: "1 giờ 32 phút",
    genres: [
      Genre(id: "1", name: "Tâm lý"),
      Genre(id: "2", name: "Kịch tính"),
    ],
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
        id: "comment_1_1",
        userId: "user123",
        movieId: "movie_1",
        userName: "An Nguyễn",
        content: "Phim quá xuất sắc!",
        rating: 9.0,
      ),
      Comment(
        id: "comment_1_2",
        userId: "user124",
        movieId: "movie_1",
        userName: "Minh Trần",
        content: "Tình tiết hấp dẫn và cảm động.",
        rating: 8.5,
      ),
    ],
  ),
  Movie(
    id: "movie_2",
    title: "Mai",
    imagePath:
        "https://images2.thanhnien.vn/528068263637045248/2024/2/20/special-poster-2-mai-17084211313531000860296.jpg",
    trailerUrl:
        "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
    duration: "1 giờ 45 phút",
    genres: [
      Genre(id: "3", name: "Tình cảm"),
      Genre(id: "4", name: "Lãng mạn"),
    ],
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
        id: "comment_2_1",
        userId: "user125",
        movieId: "movie_2",
        userName: "Linh Lê",
        content: "Phim rất lãng mạn và đáng yêu!",
        rating: 8.0,
      ),
      Comment(
        id: "comment_2_2",
        userId: "user126",
        movieId: "movie_2",
        userName: "Tú Phạm",
        content: "Câu chuyện cảm động, diễn viên diễn tốt.",
        rating: 8.2,
      ),
    ],
  ),
  Movie(
    id: "movie_3",
    title: "Sáng Đèn",
    imagePath:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQp9ythB56pAlsr-yj15gLoWJ1ZcWSWeOJVkSWXNnLmXpP6j7DxFSHDkNvvVmXOJ0re9yQ&usqp=CAU",
    trailerUrl:
        "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4",
    duration: "1 giờ 20 phút",
    genres: [
      Genre(id: "5", name: "Tài liệu"),
      Genre(id: "6", name: "Tiểu sử"),
    ],
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
        id: "comment_3_1",
        userId: "user127",
        movieId: "movie_3",
        userName: "Bảo Anh",
        content: "Phim tài liệu rất chân thực!",
        rating: 7.8,
      ),
    ],
  ),
  Movie(
    id: "movie_4",
    title: "Lật Mặt 4",
    imagePath:
        "https://media-cdn-v2.laodong.vn/Storage/NewsPortal/2022/9/6/1089731/03_TIEU-VY-01.jpg",
    trailerUrl: "https://filesamples.com/samples/video/mp4/sample_640x360.mp4",
    duration: "2 giờ 10 phút",
    genres: [
      Genre(id: "7", name: "Hành động"),
      Genre(id: "8", name: "Hài hước"),
    ],
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
        id: "comment_4_1",
        userId: "user128",
        movieId: "movie_4",
        userName: "Đức Phan",
        content: "Phim hành động quá đã!",
        rating: 8.5,
      ),
      Comment(
        id: "comment_4_2",
        userId: "user129",
        movieId: "movie_4",
        userName: "Hải Nam",
        content: "Tình tiết vui nhộn, giải trí tốt.",
        rating: 8.0,
      ),
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
