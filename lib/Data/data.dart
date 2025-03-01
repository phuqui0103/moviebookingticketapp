import '../Model/Cinema.dart';
import '../Model/Comment.dart';
import '../Model/District.dart';
import '../Model/Movie.dart';
import '../Model/Provice.dart';
import '../Model/Room.dart';
import '../Model/Seat.dart';
import '../Model/Showtime.dart';

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
final List<Province> province = [
  Province(id: "t1", name: "An Giang"),
  Province(id: "t2", name: "Đồng Tháp")
];
final List<District> district = [
  District(id: "h1", name: "Long Xuyên", provinceId: "t1"),
  District(id: "h2", name: "Cao Lãnh", provinceId: "t2")
];
final List<Cinema> cinemas = [
  Cinema(
    id: "cinema_1",
    name: "CGV Nguyễn Trãi",
    districtId: "h1",
    address: "123 Nguyễn Trãi, Quận 1, TP.HCM",
  ),
  Cinema(
    id: "cinema_2",
    name: "Lotte Cinema Nam Sài Gòn",
    districtId: "h2",
    address: "469 Nguyễn Hữu Thọ, Quận 7, TP.HCM",
  ),
];

final List<Room> rooms = [
  Room(id: "room_101", cinemaId: "cinema_1", name: "Phòng 1", seatCount: 100),
  Room(id: "room_201", cinemaId: "cinema_2", name: "Phòng 1", seatCount: 120),
];

final List<Showtime> showtimes = [
  Showtime(
    id: "show_1",
    movieId: "movie_1",
    roomId: "room_101",
    dateTime: DateTime(2025, 3, 2, 11, 0),
    format: "2D",
    availableSeats: 50,
  ),
  Showtime(
    id: "show_2",
    movieId: "movie_2",
    roomId: "room_201",
    dateTime: DateTime(2025, 3, 3, 10, 0),
    format: "2D",
    availableSeats: 75,
  ),
  Showtime(
    id: "show_3",
    movieId: "movie_3",
    roomId: "room_101",
    dateTime: DateTime(2025, 3, 5, 13, 30),
    format: "2D",
    availableSeats: 75,
  ),
];

final List<Seat> seats = [
  Seat(id: "seat_1", roomId: "room_101", type: "Standard", status: "available"),
  Seat(id: "seat_2", roomId: "room_101", type: "VIP", status: "available"),
  Seat(id: "seat_3", roomId: "room_201", type: "Standard", status: "booked"),
];
