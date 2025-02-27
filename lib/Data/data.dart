import '../Model/Movie.dart';

final List<Movie> movies = [
  Movie(
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
