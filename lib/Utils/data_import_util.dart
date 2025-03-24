import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DataImportUtil {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Phương thức để import tất cả dữ liệu
  static Future<void> importAllData(BuildContext context) async {
    try {
      // Hiển thị dialog loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Đang import dữ liệu..."),
            ],
          ),
        ),
      );

      // Import dữ liệu
      await importGenres();
      await importProvinces();
      await importCinemas();
      await importRooms();
      await importMovies();
      await importShowtimes();

      // Đóng dialog loading
      Navigator.pop(context);

      // Hiển thị thông báo thành công
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Thành công"),
          content: const Text("Đã import dữ liệu thành công!\n\n"
              "Dữ liệu đã được thêm vào:\n"
              "- 20 thể loại phim\n"
              "- 10 tỉnh/thành phố\n"
              "- 12 rạp phim\n"
              "- 8 phòng chiếu\n"
              "- 8 bộ phim\n"
              "- 10 suất chiếu (hôm nay và ngày mai)"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      // Đóng dialog loading nếu có lỗi
      Navigator.pop(context);

      // Hiển thị thông báo lỗi
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Lỗi"),
          content: Text("Lỗi khi import dữ liệu: $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  // Import genres - thể loại phim
  static Future<void> importGenres() async {
    final List<Map<String, dynamic>> genres = [
      {"id": "g001", "name": "Hành động"},
      {"id": "g002", "name": "Khoa học viễn tưởng"},
      {"id": "g003", "name": "Tội phạm"},
      {"id": "g004", "name": "Kịch"},
      {"id": "g005", "name": "Hài kịch đen"},
      {"id": "g006", "name": "Kinh dị"},
      {"id": "g007", "name": "Hoạt hình"},
      {"id": "g008", "name": "Lịch sử"},
      {"id": "g009", "name": "Tiểu sử"},
      {"id": "g010", "name": "Hài hước"},
      {"id": "g011", "name": "Phiêu lưu"},
      {"id": "g012", "name": "Huyền ảo"},
      {"id": "g013", "name": "Lãng mạn"},
      {"id": "g014", "name": "Chiến tranh"},
      {"id": "g015", "name": "Tâm lý"},
      {"id": "g016", "name": "Âm nhạc"},
      {"id": "g017", "name": "Tài liệu"},
      {"id": "g018", "name": "Gia đình"},
      {"id": "g019", "name": "Thần thoại"},
      {"id": "g020", "name": "Giả tưởng"}
    ];

    try {
      print('Bắt đầu import ${genres.length} thể loại phim...');

      for (var genre in genres) {
        await _firestore.collection('genres').doc(genre['id']).set(genre);
      }

      print('Hoàn thành import thể loại phim');
    } catch (e) {
      print('Lỗi khi import thể loại phim: $e');
      throw e;
    }
  }

  // Import provinces
  static Future<void> importProvinces() async {
    final List<Map<String, dynamic>> provinces = [
      {"id": "p001", "name": "Thành phố Hồ Chí Minh"},
      {"id": "p002", "name": "Hà Nội"},
      {"id": "p003", "name": "Đà Nẵng"},
      {"id": "p004", "name": "Cần Thơ"},
      {"id": "p005", "name": "Hải Phòng"},
      {"id": "p006", "name": "Bình Dương"},
      {"id": "p007", "name": "Đồng Nai"},
      {"id": "p008", "name": "Khánh Hòa"},
      {"id": "p009", "name": "Huế"},
      {"id": "p010", "name": "Bà Rịa - Vũng Tàu"}
    ];

    for (var province in provinces) {
      await _firestore
          .collection('provinces')
          .doc(province['id'])
          .set(province);
    }
  }

  // Import cinemas
  static Future<void> importCinemas() async {
    final List<Map<String, dynamic>> cinemas = [
      {
        "id": "c001",
        "name": "CGV Vincom Center Đồng Khởi",
        "provinceId": "p001",
        "address":
            "Tầng 3, TTTM Vincom Center, 72 Lê Thánh Tôn, P. Bến Nghé, Q.1"
      },
      {
        "id": "c002",
        "name": "CGV Aeon Mall Tân Phú",
        "provinceId": "p001",
        "address":
            "Tầng 3, Aeon Mall Tân Phú, 30 Bờ Bao Tân Thắng, P. Sơn Kỳ, Q. Tân Phú"
      },
      {
        "id": "c003",
        "name": "CGV Landmark 81",
        "provinceId": "p001",
        "address":
            "Tầng B1, TTTM Landmark 81, 720A Điện Biên Phủ, P.22, Q. Bình Thạnh"
      },
      {
        "id": "c004",
        "name": "BHD Star Bitexco",
        "provinceId": "p001",
        "address": "Tầng 3 & 4, Bitexco Icon 68, 2 Hải Triều, Bến Nghé, Quận 1"
      },
      {
        "id": "c005",
        "name": "Lotte Cinema Nowzone",
        "provinceId": "p001",
        "address": "Tầng 5, Nowzone Fashion Mall, 235 Nguyễn Văn Cừ, Q.1"
      },
      {
        "id": "c006",
        "name": "CGV Vincom Royal City",
        "provinceId": "p002",
        "address":
            "Tầng B2, TTTM Vincom Royal City, 72A Nguyễn Trãi, Thanh Xuân"
      },
      {
        "id": "c007",
        "name": "BHD Star Phạm Ngọc Thạch",
        "provinceId": "p002",
        "address": "Tầng 8, Vincom Phạm Ngọc Thạch, 2 Phạm Ngọc Thạch, Đống Đa"
      },
      {
        "id": "c008",
        "name": "Lotte Cinema Thăng Long",
        "provinceId": "p002",
        "address": "Tầng 6, Big C Thăng Long, 222 Trần Duy Hưng, Cầu Giấy"
      },
      {
        "id": "c009",
        "name": "CGV Vincom Đà Nẵng",
        "provinceId": "p003",
        "address": "Tầng 4, TTTM Vincom Đà Nẵng, 910A Ngô Quyền, Sơn Trà"
      },
      {
        "id": "c010",
        "name": "Lotte Cinema Đà Nẵng",
        "provinceId": "p003",
        "address": "Tầng 5, Lotte Mart Đà Nẵng, 6 Nại Nam, Hải Châu"
      },
      {
        "id": "c011",
        "name": "CGV Sense City Cần Thơ",
        "provinceId": "p004",
        "address": "Tầng 3, TTTM Sense City, 1 Đại lộ Hòa Bình, Ninh Kiều"
      },
      {
        "id": "c012",
        "name": "Lotte Cinema Cần Thơ",
        "provinceId": "p004",
        "address":
            "Tầng 5, Vincom Plaza Xuân Khánh, 209 đường 30/4, Xuân Khánh, Ninh Kiều"
      }
    ];

    for (var cinema in cinemas) {
      await _firestore.collection('cinemas').doc(cinema['id']).set(cinema);
    }
  }

  // Import rooms
  static Future<void> importRooms() async {
    final List<Map<String, dynamic>> rooms = [
      {
        "id": "r001",
        "cinemaId": "c001",
        "name": "Phòng 1",
        "rows": 8,
        "cols": 12,
        "seatLayout": []
      },
      {
        "id": "r002",
        "cinemaId": "c001",
        "name": "Phòng 2",
        "rows": 10,
        "cols": 14,
        "seatLayout": []
      },
      {
        "id": "r003",
        "cinemaId": "c001",
        "name": "Phòng VIP",
        "rows": 6,
        "cols": 8,
        "seatLayout": []
      },
      {
        "id": "r004",
        "cinemaId": "c002",
        "name": "Phòng 1",
        "rows": 10,
        "cols": 12,
        "seatLayout": []
      },
      {
        "id": "r005",
        "cinemaId": "c002",
        "name": "Phòng 2",
        "rows": 8,
        "cols": 10,
        "seatLayout": []
      },
      {
        "id": "r006",
        "cinemaId": "c003",
        "name": "Phòng 1",
        "rows": 12,
        "cols": 14,
        "seatLayout": []
      },
      {
        "id": "r007",
        "cinemaId": "c003",
        "name": "Phòng IMAX",
        "rows": 14,
        "cols": 16,
        "seatLayout": []
      },
      {
        "id": "r008",
        "cinemaId": "c004",
        "name": "Phòng 1",
        "rows": 9,
        "cols": 12,
        "seatLayout": []
      }
    ];

    for (var room in rooms) {
      await _firestore.collection('rooms').doc(room['id']).set(room);
    }
  }

  // Import movies
  static Future<void> importMovies() async {
    final List<Map<String, dynamic>> movies = [
      {
        "id": "movie1",
        "title": "Avengers: Endgame",
        "imagePath":
            "https://image.tmdb.org/t/p/w500/or06FN3Dka5tukK1e9sl16pB3iy.jpg",
        "trailerUrl": "https://www.youtube.com/watch?v=TcMBFSGVi1c",
        "duration": "181 phút",
        "genres": [
          {"id": "g001", "name": "Hành động"},
          {"id": "g002", "name": "Khoa học viễn tưởng"}
        ],
        "rating": 8.4,
        "isShowingNow": true,
        "description":
            "Sau sự kiện tàn khốc của Avengers: Infinity War, vũ trụ đang bị hủy hoại. Với sự giúp đỡ của các đồng minh còn lại, các Avengers tập hợp một lần nữa để đảo ngược hành động của Thanos và khôi phục sự cân bằng cho vũ trụ.",
        "cast": [
          "Robert Downey Jr.",
          "Chris Evans",
          "Mark Ruffalo",
          "Chris Hemsworth",
          "Scarlett Johansson"
        ],
        "reviewCount": 1200,
        "releaseDate": "26/04/2019",
        "director": "Anthony Russo, Joe Russo",
        "comments": []
      },
      {
        "id": "movie2",
        "title": "Joker",
        "imagePath":
            "https://image.tmdb.org/t/p/w500/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg",
        "trailerUrl": "https://www.youtube.com/watch?v=zAGVQLHvwOY",
        "duration": "122 phút",
        "genres": [
          {"id": "g003", "name": "Tội phạm"},
          {"id": "g004", "name": "Kịch"}
        ],
        "rating": 8.5,
        "isShowingNow": true,
        "description":
            "Một diễn viên hài thất bại bị xã hội cô lập và bỏ rơi, dẫn đến một cuộc hành trình từ từ vào thế giới điên rồ và tội phạm.",
        "cast": ["Joaquin Phoenix", "Robert De Niro", "Zazie Beetz"],
        "reviewCount": 980,
        "releaseDate": "04/10/2019",
        "director": "Todd Phillips",
        "comments": []
      },
      {
        "id": "movie3",
        "title": "Parasite",
        "imagePath":
            "https://image.tmdb.org/t/p/w500/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg",
        "trailerUrl": "https://www.youtube.com/watch?v=5xH0HfJHsaY",
        "duration": "132 phút",
        "genres": [
          {"id": "g005", "name": "Hài kịch đen"},
          {"id": "g006", "name": "Kinh dị"}
        ],
        "rating": 8.6,
        "isShowingNow": true,
        "description":
            "Câu chuyện về một gia đình nghèo khó lần lượt thâm nhập vào một gia đình giàu có, tạo ra một chuỗi sự kiện không thể quay đầu.",
        "cast": [
          "Song Kang-ho",
          "Lee Sun-kyun",
          "Cho Yeo-jeong",
          "Choi Woo-shik"
        ],
        "reviewCount": 850,
        "releaseDate": "07/06/2019",
        "director": "Bong Joon-ho",
        "comments": []
      },
      {
        "id": "movie4",
        "title": "Spider-Man: Across the Spider-Verse",
        "imagePath":
            "https://image.tmdb.org/t/p/w500/8Vt6mWEReuy4Of61Lnj5Xj704m8.jpg",
        "trailerUrl": "https://www.youtube.com/watch?v=shW9i6k8cB0",
        "duration": "140 phút",
        "genres": [
          {"id": "g001", "name": "Hành động"},
          {"id": "g002", "name": "Khoa học viễn tưởng"},
          {"id": "g007", "name": "Hoạt hình"}
        ],
        "rating": 8.7,
        "isShowingNow": true,
        "description":
            "Sau khi tái hợp với Gwen Stacy, Spider-Man thân thiện với khu phố từ Brooklyn bị ném qua đa vũ trụ, nơi anh gặp một nhóm những Người Nhện có nhiệm vụ bảo vệ chính sự tồn tại của nó.",
        "cast": [
          "Shameik Moore",
          "Hailee Steinfeld",
          "Jake Johnson",
          "Oscar Isaac"
        ],
        "reviewCount": 920,
        "releaseDate": "02/06/2023",
        "director": "Joaquim Dos Santos, Kemp Powers, Justin K. Thompson",
        "comments": []
      },
      {
        "id": "movie5",
        "title": "Oppenheimer",
        "imagePath":
            "https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg",
        "trailerUrl": "https://www.youtube.com/watch?v=uYPbbksJxIg",
        "duration": "180 phút",
        "genres": [
          {"id": "g004", "name": "Kịch"},
          {"id": "g008", "name": "Lịch sử"},
          {"id": "g009", "name": "Tiểu sử"}
        ],
        "rating": 8.2,
        "isShowingNow": true,
        "description":
            "Câu chuyện về nhà vật lý học J. Robert Oppenheimer và vai trò của ông trong việc phát triển bom nguyên tử trong Dự án Manhattan trong Thế chiến thứ hai.",
        "cast": [
          "Cillian Murphy",
          "Emily Blunt",
          "Matt Damon",
          "Robert Downey Jr."
        ],
        "reviewCount": 1050,
        "releaseDate": "21/07/2023",
        "director": "Christopher Nolan",
        "comments": []
      },
      {
        "id": "movie6",
        "title": "Barbie",
        "imagePath":
            "https://image.tmdb.org/t/p/w500/iuFNMS8U5cb6xfzi8Qzn29mTByD.jpg",
        "trailerUrl": "https://www.youtube.com/watch?v=8zIf0XvoL9Y",
        "duration": "114 phút",
        "genres": [
          {"id": "g010", "name": "Hài hước"},
          {"id": "g011", "name": "Phiêu lưu"},
          {"id": "g012", "name": "Huyền ảo"}
        ],
        "rating": 7.3,
        "isShowingNow": true,
        "description":
            "Barbie và Ken đang có thời gian tuyệt vời ở thế giới Barbie Land đầy màu sắc và hoàn hảo. Tuy nhiên, họ sớm khám phá ra thực tế khi bước vào thế giới thực.",
        "cast": [
          "Margot Robbie",
          "Ryan Gosling",
          "America Ferrera",
          "Kate McKinnon"
        ],
        "reviewCount": 880,
        "releaseDate": "21/07/2023",
        "director": "Greta Gerwig",
        "comments": []
      },
      {
        "id": "movie7",
        "title": "Poor Things",
        "imagePath":
            "https://image.tmdb.org/t/p/w500/kCGlIMHnOm8JPXq3rXM6c5wMxcT.jpg",
        "trailerUrl": "https://www.youtube.com/watch?v=RlbR5N6veqw",
        "duration": "142 phút",
        "genres": [
          {"id": "g004", "name": "Kịch"},
          {"id": "g013", "name": "Lãng mạn"},
          {"id": "g002", "name": "Khoa học viễn tưởng"}
        ],
        "rating": 8.0,
        "isShowingNow": true,
        "description":
            "Bella Baxter được hồi sinh bởi thiên tài khoa học điên rồ Dr. Godwin Baxter. Khao khát trải nghiệm thế giới bên ngoài, Bella trốn thoát với một luật sư quyến rũ và bắt đầu cuộc hành trình phiêu lưu khắp các lục địa.",
        "cast": ["Emma Stone", "Mark Ruffalo", "Willem Dafoe", "Ramy Youssef"],
        "reviewCount": 650,
        "releaseDate": "08/12/2023",
        "director": "Yorgos Lanthimos",
        "comments": []
      },
      {
        "id": "movie8",
        "title": "Dune: Part Two",
        "imagePath":
            "https://image.tmdb.org/t/p/w500/vZJ3NOIFRAMpbdolGAUtn8h1gRA.jpg",
        "trailerUrl": "https://www.youtube.com/watch?v=hMO9-d4q12M",
        "duration": "166 phút",
        "genres": [
          {"id": "g002", "name": "Khoa học viễn tưởng"},
          {"id": "g011", "name": "Phiêu lưu"},
          {"id": "g004", "name": "Kịch"}
        ],
        "rating": 8.5,
        "isShowingNow": true,
        "description":
            "Paul Atreides đoàn kết với Chani và người Fremen để tìm kiếm con đường trả thù những kẻ đã hủy hoại gia đình mình. Đối mặt với sự lựa chọn giữa tình yêu và số phận của vũ trụ, anh phải ngăn chặn một tương lai khủng khiếp.",
        "cast": [
          "Timothée Chalamet",
          "Zendaya",
          "Rebecca Ferguson",
          "Javier Bardem"
        ],
        "reviewCount": 780,
        "releaseDate": "01/03/2024",
        "director": "Denis Villeneuve",
        "comments": []
      }
    ];

    for (var movie in movies) {
      await _firestore.collection('movies').doc(movie['id']).set(movie);
    }
  }

  // Import showtimes
  static Future<void> importShowtimes() async {
    try {
      // Xoá tất cả suất chiếu hiện có để tránh xung đột
      final QuerySnapshot existingShowtimes =
          await _firestore.collection('showtimes').get();
      for (final doc in existingShowtimes.docs) {
        await _firestore.collection('showtimes').doc(doc.id).delete();
      }

      // Lấy thời gian hiện tại làm ngày cho các suất chiếu
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      // Kiểm tra rooms và cinemas tồn tại chưa
      final roomsSnapshot = await _firestore.collection('rooms').get();
      print('Số lượng phòng trong database: ${roomsSnapshot.docs.length}');

      final cinemasSnapshot = await _firestore.collection('cinemas').get();
      print('Số lượng rạp trong database: ${cinemasSnapshot.docs.length}');

      // Đảm bảo sử dụng đúng mối quan hệ phòng-rạp
      final List<Map<String, dynamic>> showtimes = [
        {
          "id": "showtime1",
          "movieId": "movie1",
          "cinemaId": "c001",
          "roomId": "r001",
          "startTime": Timestamp.fromDate(
              today.add(const Duration(hours: 10, minutes: 30))),
          "bookedSeats": []
        },
        {
          "id": "showtime2",
          "movieId": "movie2",
          "cinemaId": "c001",
          "roomId": "r001",
          "startTime": Timestamp.fromDate(
              today.add(const Duration(hours: 14, minutes: 0))),
          "bookedSeats": []
        },
        {
          "id": "showtime3",
          "movieId": "movie3",
          "cinemaId": "c001",
          "roomId": "r002",
          "startTime": Timestamp.fromDate(
              today.add(const Duration(hours: 16, minutes: 20))),
          "bookedSeats": []
        },
        {
          "id": "showtime4",
          "movieId": "movie4",
          "cinemaId": "c001",
          "roomId": "r003",
          "startTime": Timestamp.fromDate(
              today.add(const Duration(hours: 18, minutes: 15))),
          "bookedSeats": []
        },
        {
          "id": "showtime5",
          "movieId": "movie5",
          "cinemaId": "c002",
          "roomId": "r004",
          "startTime": Timestamp.fromDate(
              today.add(const Duration(hours: 19, minutes: 30))),
          "bookedSeats": []
        },
        {
          "id": "showtime6",
          "movieId": "movie6",
          "cinemaId": "c002",
          "roomId": "r005",
          "startTime": Timestamp.fromDate(
              today.add(const Duration(hours: 21, minutes: 0))),
          "bookedSeats": []
        },
        {
          "id": "showtime7",
          "movieId": "movie7",
          "cinemaId": "c003",
          "roomId": "r006",
          "startTime": Timestamp.fromDate(
              today.add(const Duration(hours: 15, minutes: 10))),
          "bookedSeats": []
        },
        {
          "id": "showtime8",
          "movieId": "movie8",
          "cinemaId": "c003",
          "roomId": "r007",
          "startTime": Timestamp.fromDate(
              today.add(const Duration(hours: 17, minutes: 40))),
          "bookedSeats": []
        },
        // Suất chiếu cho ngày mai
        {
          "id": "showtime9",
          "movieId": "movie1",
          "cinemaId": "c001",
          "roomId": "r001",
          "startTime": Timestamp.fromDate(
              tomorrow.add(const Duration(hours: 10, minutes: 30))),
          "bookedSeats": []
        },
        {
          "id": "showtime10",
          "movieId": "movie2",
          "cinemaId": "c001",
          "roomId": "r002",
          "startTime": Timestamp.fromDate(
              tomorrow.add(const Duration(hours: 14, minutes: 0))),
          "bookedSeats": []
        }
      ];

      print('Bắt đầu import ${showtimes.length} suất chiếu...');

      // Import từng suất chiếu với khối try/catch riêng
      for (var showtime in showtimes) {
        try {
          print(
              'Importing showtime: Movie ${showtime["movieId"]}, Cinema ${showtime["cinemaId"]}, Room ${showtime["roomId"]}');
          await _firestore
              .collection('showtimes')
              .doc(showtime['id'])
              .set(showtime);
        } catch (e) {
          print('Lỗi khi import suất chiếu ${showtime["id"]}: $e');
        }
      }

      print('Hoàn thành import suất chiếu');
    } catch (e) {
      print('Lỗi tổng thể khi import suất chiếu: $e');
    }
  }
}
