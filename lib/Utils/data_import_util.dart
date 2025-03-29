import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DataImportUtil {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Import comments
  static Future<void> importComments() async {
    final List<Map<String, dynamic>> comments = [
      {
        "id": "comment1",
        "movieId": "movie1",
        "userId": "user1",
        "userName": "Nguyễn Văn A",
        "content": "Phim rất hay, hiệu ứng đẹp, diễn xuất tốt. Đáng xem!",
        "rating": 9.0,
        "timestamp":
            Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 2)))
      },
      {
        "id": "comment2",
        "movieId": "movie1",
        "userId": "user2",
        "userName": "Trần Thị B",
        "content":
            "Kết thúc rất ấn tượng, xứng đáng là phần cuối của series Avengers.",
        "rating": 9.5,
        "timestamp":
            Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1)))
      },
      {
        "id": "comment3",
        "movieId": "movie2",
        "userId": "user3",
        "userName": "Lê Văn C",
        "content":
            "Joaquin Phoenix diễn xuất xuất sắc, xứng đáng với giải Oscar.",
        "rating": 9.0,
        "timestamp":
            Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 3)))
      },
      {
        "id": "comment4",
        "movieId": "movie3",
        "userId": "user4",
        "userName": "Phạm Thị D",
        "content": "Phim có nhiều tầng ý nghĩa sâu sắc, đáng để xem nhiều lần.",
        "rating": 9.2,
        "timestamp":
            Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 4)))
      },
      {
        "id": "comment5",
        "movieId": "movie4",
        "userId": "user5",
        "userName": "Hoàng Văn E",
        "content":
            "Hoạt hình đẹp, cốt truyện hấp dẫn, xứng đáng là phần tiếp theo của Spider-Verse.",
        "rating": 9.3,
        "timestamp":
            Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 5)))
      },
      {
        "id": "comment6",
        "movieId": "movie5",
        "userId": "user6",
        "userName": "Mai Thị F",
        "content":
            "Christopher Nolan lại một lần nữa chứng tỏ tài năng đạo diễn xuất sắc.",
        "rating": 8.8,
        "timestamp":
            Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 6)))
      },
      {
        "id": "comment7",
        "movieId": "movie6",
        "userId": "user7",
        "userName": "Đỗ Văn G",
        "content":
            "Phim vui nhộn, phù hợp với mọi lứa tuổi. Margot Robbie rất phù hợp với vai Barbie.",
        "rating": 8.5,
        "timestamp":
            Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 7)))
      },
      {
        "id": "comment8",
        "movieId": "movie7",
        "userId": "user8",
        "userName": "Vũ Thị H",
        "content":
            "Emma Stone diễn xuất tuyệt vời, cốt truyện độc đáo và sáng tạo.",
        "rating": 8.7,
        "timestamp":
            Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 8)))
      },
      {
        "id": "comment9",
        "movieId": "movie8",
        "userId": "user9",
        "userName": "Lý Văn I",
        "content":
            "Phần 2 không làm thất vọng người hâm mộ, hiệu ứng và diễn xuất đều xuất sắc.",
        "rating": 9.1,
        "timestamp":
            Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 9)))
      }
    ];

    try {
      print('Bắt đầu import ${comments.length} bình luận...');

      for (var comment in comments) {
        await _firestore.collection('comments').doc(comment['id']).set(comment);
      }

      print('Hoàn thành import bình luận');
    } catch (e) {
      print('Lỗi khi import bình luận: $e');
      throw e;
    }
  }

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
              Text("Đang import dữ liệu phim..."),
            ],
          ),
        ),
      );

      // Import dữ liệu phim
      await importMovies();

      // Đóng dialog loading
      Navigator.pop(context);

      // Hiển thị thông báo thành công
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Thành công"),
          content: const Text("Đã import dữ liệu phim thành công!\n\n"
              "Dữ liệu đã được thêm vào:\n"
              "- 6 phim đang chiếu\n"
              "- 3 phim sắp chiếu"),
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
          content: Text("Lỗi khi import dữ liệu phim: $e"),
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

  // Import districts
  static Future<void> importDistricts() async {
    final List<Map<String, dynamic>> districts = [
      // Hồ Chí Minh
      {"id": "d001", "name": "Quận 1", "provinceId": "p001"},
      {"id": "d002", "name": "Quận 3", "provinceId": "p001"},
      {"id": "d003", "name": "Quận 4", "provinceId": "p001"},
      {"id": "d004", "name": "Quận 5", "provinceId": "p001"},
      {"id": "d005", "name": "Quận 10", "provinceId": "p001"},
      {"id": "d006", "name": "Quận Bình Thạnh", "provinceId": "p001"},
      {"id": "d007", "name": "Quận Gò Vấp", "provinceId": "p001"},
      {"id": "d008", "name": "Quận Phú Nhuận", "provinceId": "p001"},
      {"id": "d009", "name": "Quận Tân Bình", "provinceId": "p001"},
      {"id": "d010", "name": "Quận Tân Phú", "provinceId": "p001"},

      // Hà Nội
      {"id": "d011", "name": "Quận Ba Đình", "provinceId": "p002"},
      {"id": "d012", "name": "Quận Cầu Giấy", "provinceId": "p002"},
      {"id": "d013", "name": "Quận Đống Đa", "provinceId": "p002"},
      {"id": "d014", "name": "Quận Hai Bà Trưng", "provinceId": "p002"},
      {"id": "d015", "name": "Quận Hoàn Kiếm", "provinceId": "p002"},
      {"id": "d016", "name": "Quận Long Biên", "provinceId": "p002"},
      {"id": "d017", "name": "Quận Thanh Xuân", "provinceId": "p002"},
      {"id": "d018", "name": "Quận Từ Liêm", "provinceId": "p002"},
      {"id": "d019", "name": "Quận Tây Hồ", "provinceId": "p002"},
      {"id": "d020", "name": "Quận Nam Từ Liêm", "provinceId": "p002"},

      // Đà Nẵng
      {"id": "d021", "name": "Quận Hải Châu", "provinceId": "p003"},
      {"id": "d022", "name": "Quận Thanh Khê", "provinceId": "p003"},
      {"id": "d023", "name": "Quận Sơn Trà", "provinceId": "p003"},
      {"id": "d024", "name": "Quận Ngũ Hành Sơn", "provinceId": "p003"},
      {"id": "d025", "name": "Quận Liên Chiểu", "provinceId": "p003"},
      {"id": "d026", "name": "Quận Cẩm Lệ", "provinceId": "p003"},
      {"id": "d027", "name": "Huyện Hòa Vang", "provinceId": "p003"},
      {"id": "d028", "name": "Huyện Hoàng Sa", "provinceId": "p003"},

      // Cần Thơ
      {"id": "d029", "name": "Quận Ninh Kiều", "provinceId": "p004"},
      {"id": "d030", "name": "Quận Bình Thuỷ", "provinceId": "p004"},
      {"id": "d031", "name": "Quận Cái Răng", "provinceId": "p004"},
      {"id": "d032", "name": "Quận Ô Môn", "provinceId": "p004"},
      {"id": "d033", "name": "Quận Thốt Nốt", "provinceId": "p004"},
      {"id": "d034", "name": "Huyện Vĩnh Thạnh", "provinceId": "p004"},
      {"id": "d035", "name": "Huyện Cờ Đỏ", "provinceId": "p004"},
      {"id": "d036", "name": "Huyện Phong Điền", "provinceId": "p004"},
      {"id": "d037", "name": "Huyện Thới Lai", "provinceId": "p004"},

      // Hải Phòng
      {"id": "d038", "name": "Quận Hồng Bàng", "provinceId": "p005"},
      {"id": "d039", "name": "Quận Ngô Quyền", "provinceId": "p005"},
      {"id": "d040", "name": "Quận Lê Chân", "provinceId": "p005"},
      {"id": "d041", "name": "Quận Hải An", "provinceId": "p005"},
      {"id": "d042", "name": "Quận Kiến An", "provinceId": "p005"},
      {"id": "d043", "name": "Quận Đồ Sơn", "provinceId": "p005"},
      {"id": "d044", "name": "Quận Dương Kinh", "provinceId": "p005"},
      {"id": "d045", "name": "Huyện Thuỷ Nguyên", "provinceId": "p005"},
      {"id": "d046", "name": "Huyện An Dương", "provinceId": "p005"},
      {"id": "d047", "name": "Huyện An Lão", "provinceId": "p005"},

      // Bình Dương
      {"id": "d048", "name": "Thành phố Thủ Dầu Một", "provinceId": "p006"},
      {"id": "d049", "name": "Thành phố Dĩ An", "provinceId": "p006"},
      {"id": "d050", "name": "Thành phố Thuận An", "provinceId": "p006"},
      {"id": "d051", "name": "Thành phố Bến Cát", "provinceId": "p006"},
      {"id": "d052", "name": "Thành phố Tân Uyên", "provinceId": "p006"},
      {"id": "d053", "name": "Huyện Bắc Tân Uyên", "provinceId": "p006"},
      {"id": "d054", "name": "Huyện Bàu Bàng", "provinceId": "p006"},
      {"id": "d055", "name": "Huyện Phú Giáo", "provinceId": "p006"},
      {"id": "d056", "name": "Huyện Dầu Tiếng", "provinceId": "p006"},
      {"id": "d057", "name": "Huyện Bàu Bàng", "provinceId": "p006"},

      // Đồng Nai
      {"id": "d058", "name": "Thành phố Biên Hòa", "provinceId": "p007"},
      {"id": "d059", "name": "Thành phố Long Khánh", "provinceId": "p007"},
      {"id": "d060", "name": "Huyện Tân Phú", "provinceId": "p007"},
      {"id": "d061", "name": "Huyện Vĩnh Cửu", "provinceId": "p007"},
      {"id": "d062", "name": "Huyện Định Quán", "provinceId": "p007"},
      {"id": "d063", "name": "Huyện Trảng Bom", "provinceId": "p007"},
      {"id": "d064", "name": "Huyện Thống Nhất", "provinceId": "p007"},
      {"id": "d065", "name": "Huyện Cẩm Mỹ", "provinceId": "p007"},
      {"id": "d066", "name": "Huyện Long Thành", "provinceId": "p007"},
      {"id": "d067", "name": "Huyện Xuân Lộc", "provinceId": "p007"},

      // Khánh Hòa
      {"id": "d068", "name": "Thành phố Nha Trang", "provinceId": "p008"},
      {"id": "d069", "name": "Thành phố Cam Ranh", "provinceId": "p008"},
      {"id": "d070", "name": "Huyện Cam Lâm", "provinceId": "p008"},
      {"id": "d071", "name": "Huyện Vạn Ninh", "provinceId": "p008"},
      {"id": "d072", "name": "Huyện Ninh Hòa", "provinceId": "p008"},
      {"id": "d073", "name": "Huyện Khánh Vĩnh", "provinceId": "p008"},
      {"id": "d074", "name": "Huyện Diên Khánh", "provinceId": "p008"},
      {"id": "d075", "name": "Huyện Khánh Sơn", "provinceId": "p008"},
      {"id": "d076", "name": "Thị xã Ninh Hòa", "provinceId": "p008"},
      {"id": "d077", "name": "Huyện Trường Sa", "provinceId": "p008"},

      // Huế
      {"id": "d078", "name": "Thành phố Huế", "provinceId": "p009"},
      {"id": "d079", "name": "Huyện Phong Điền", "provinceId": "p009"},
      {"id": "d080", "name": "Huyện Quảng Điền", "provinceId": "p009"},
      {"id": "d081", "name": "Huyện Phú Vang", "provinceId": "p009"},
      {"id": "d082", "name": "Huyện Hương Thủy", "provinceId": "p009"},
      {"id": "d083", "name": "Huyện Phú Lộc", "provinceId": "p009"},
      {"id": "d084", "name": "Huyện Nam Đông", "provinceId": "p009"},
      {"id": "d085", "name": "Huyện A Lưới", "provinceId": "p009"},

      // Bà Rịa - Vũng Tàu
      {"id": "d086", "name": "Thành phố Vũng Tàu", "provinceId": "p010"},
      {"id": "d087", "name": "Thành phố Bà Rịa", "provinceId": "p010"},
      {"id": "d088", "name": "Huyện Châu Đức", "provinceId": "p010"},
      {"id": "d089", "name": "Huyện Xuyên Mộc", "provinceId": "p010"},
      {"id": "d090", "name": "Huyện Long Điền", "provinceId": "p010"},
      {"id": "d091", "name": "Huyện Đất Đỏ", "provinceId": "p010"},
      {"id": "d092", "name": "Huyện Tân Thành", "provinceId": "p010"},
      {"id": "d093", "name": "Huyện Côn Đảo", "provinceId": "p010"}
    ];

    try {
      print('Bắt đầu import ${districts.length} quận/huyện...');

      for (var district in districts) {
        await _firestore
            .collection('districts')
            .doc(district['id'])
            .set(district);
      }

      print('Hoàn thành import quận/huyện');
    } catch (e) {
      print('Lỗi khi import quận/huyện: $e');
      throw e;
    }
  }

  // Các phương thức import khác đã được comment out
  /*
  static Future<void> importGenres() async { ... }
  static Future<void> importProvinces() async { ... }
  static Future<void> importCinemas() async { ... }
  static Future<void> importRooms() async { ... }
  static Future<void> importMovies() async { ... }
  static Future<void> importShowtimes() async { ... }
  static Future<void> importComments() async { ... }
  */

  // Sample food data
  static final List<Map<String, dynamic>> foodItems = [
    {
      "id": "food_1",
      "name": "Bắp rang bơ",
      "price": 45000,
      "image": "assets/images/bapnuoc.png",
      "description": "Bắp rang giòn tan, vị bơ thơm ngon",
    },
    {
      "id": "food_2",
      "name": "Nước ngọt lớn",
      "price": 35000,
      "image": "assets/images/bapnuoc.png",
      "description": "Nước ngọt mát lạnh, nhiều vị lựa chọn",
    },
    {
      "id": "food_3",
      "name": "Combo bắp nước",
      "price": 75000,
      "image": "assets/images/bapnuoc.png",
      "description": "Combo tiết kiệm: 1 bắp lớn + 1 nước lớn",
    },
    {
      "id": "food_4",
      "name": "Bắp rang phô mai",
      "price": 55000,
      "image": "assets/images/bapnuoc.png",
      "description": "Bắp rang phô mai thơm ngon, béo ngậy",
    },
    {
      "id": "food_5",
      "name": "Bắp rang caramel",
      "price": 50000,
      "image": "assets/images/bapnuoc.png",
      "description": "Bắp rang vị caramel ngọt ngào",
    },
    {
      "id": "food_6",
      "name": "Nước ngọt nhỏ",
      "price": 25000,
      "image": "assets/images/bapnuoc.png",
      "description": "Nước ngọt mát lạnh, nhiều vị lựa chọn",
    },
    {
      "id": "food_7",
      "name": "Combo gia đình",
      "price": 150000,
      "image": "assets/images/bapnuoc.png",
      "description": "Combo gia đình: 2 bắp lớn + 2 nước lớn",
    },
    {
      "id": "food_8",
      "name": "Bắp rang mix",
      "price": 65000,
      "image": "assets/images/bapnuoc.png",
      "description": "Bắp rang mix 3 vị: bơ, phô mai, caramel",
    },
    {
      "id": "food_9",
      "name": "Combo đôi",
      "price": 95000,
      "image": "assets/images/bapnuoc.png",
      "description": "Combo đôi: 1 bắp lớn + 2 nước lớn",
    },
    {
      "id": "food_10",
      "name": "Bắp rang hải sản",
      "price": 60000,
      "image": "assets/images/bapnuoc.png",
      "description": "Bắp rang vị hải sản độc đáo",
    },
  ];

  // Import food data
  static Future<void> importFoodData() async {
    try {
      print('Bắt đầu import ${foodItems.length} món đồ ăn...');

      for (var food in foodItems) {
        await _firestore.collection('foods').doc(food['id']).set({
          ...food,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      print('Hoàn thành import đồ ăn');
    } catch (e) {
      print('Lỗi khi import đồ ăn: $e');
      throw e;
    }
  }

  // Delete all food data
  static Future<void> deleteAllFoodData() async {
    try {
      CollectionReference foodCollection = _firestore.collection('foods');
      QuerySnapshot querySnapshot = await foodCollection.get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      print('Đã xóa tất cả dữ liệu đồ ăn');
    } catch (e) {
      print('Lỗi khi xóa dữ liệu đồ ăn: $e');
      throw e;
    }
  }

  // Import movies
  static Future<void> importMovies() async {
    final List<Map<String, dynamic>> movies = [
      // Phim đang chiếu
      {
        "id": "movie1",
        "title": "Mai",
        "imagePath":
            "https://image.tmdb.org/t/p/w500/1Kv9H9KOO3Dl1LSmWXo3gyl5dUV.jpg",
        "trailerUrl": "https://www.youtube.com/watch?v=8qZqXqXqXqX",
        "duration": "130 phút",
        "genres": [
          {"id": "g001", "name": "Tình cảm"},
          {"id": "g002", "name": "Chính kịch"}
        ],
        "rating": 8.5,
        "isShowingNow": true,
        "description":
            "Mai là một cô gái trẻ đẹp, thông minh nhưng phải đối mặt với nhiều khó khăn trong cuộc sống. Khi gặp Dũng, một chàng trai tốt bụng, Mai dần tìm thấy hạnh phúc và sức mạnh để vượt qua những thử thách.",
        "cast": [
          "Phương Anh Đào",
          "Tuấn Trần",
          "Minh Thư",
          "Hồng Ánh",
          "NSND Trần Nhượng"
        ],
        "reviewCount": 850,
        "releaseDate": "10/02/2024",
        "director": "Trần Thanh Huy",
        "comments": []
      },
      {
        "id": "movie2",
        "title": "Gặp Lại Chị Ba",
        "imagePath":
            "https://image.tmdb.org/t/p/w500/2Kv9H9KOO3Dl1LSmWXo3gyl5dUV.jpg",
        "trailerUrl": "https://www.youtube.com/watch?v=9qZqXqXqXqX",
        "duration": "120 phút",
        "genres": [
          {"id": "g003", "name": "Hài"},
          {"id": "g004", "name": "Gia đình"}
        ],
        "rating": 8.2,
        "isShowingNow": true,
        "description":
            "Sau 20 năm xa cách, chị Ba trở về quê hương với nhiều thay đổi. Bộ phim kể về hành trình hài hước và cảm động của chị Ba khi cố gắng hòa nhập với cuộc sống mới.",
        "cast": [
          "NSND Hồng Vân",
          "Minh Thư",
          "Hoài Linh",
          "Việt Hương",
          "NSND Trần Nhượng"
        ],
        "reviewCount": 720,
        "releaseDate": "15/02/2024",
        "director": "NSND Trần Bảo Huy",
        "comments": []
      },
      {
        "id": "movie3",
        "title": "Đất Rừng Phương Nam",
        "imagePath":
            "https://image.tmdb.org/t/p/w500/3Kv9H9KOO3Dl1LSmWXo3gyl5dUV.jpg",
        "trailerUrl": "https://www.youtube.com/watch?v=8rZqXqXqXqX",
        "duration": "135 phút",
        "genres": [
          {"id": "g005", "name": "Phiêu lưu"},
          {"id": "g006", "name": "Lịch sử"}
        ],
        "rating": 8.7,
        "isShowingNow": true,
        "description":
            "Bộ phim kể về hành trình của một cậu bé miền Bắc vào Nam tìm cha trong thời kỳ kháng chiến. Trên đường đi, cậu gặp nhiều người tốt và trải qua những cuộc phiêu lưu thú vị.",
        "cast": [
          "Hoàng Yến",
          "NSND Trần Nhượng",
          "NSND Hồng Vân",
          "Minh Thư",
          "NSND Trần Bảo Huy"
        ],
        "reviewCount": 950,
        "releaseDate": "20/02/2024",
        "director": "NSND Trần Bảo Huy",
        "comments": []
      },
      {
        "id": "movie4",
        "title": "Chuyện Kể Về Mẹ",
        "imagePath":
            "https://image.tmdb.org/t/p/w500/4Kv9H9KOO3Dl1LSmWXo3gyl5dUV.jpg",
        "trailerUrl": "https://www.youtube.com/watch?v=7qZqXqXqXqX",
        "duration": "125 phút",
        "genres": [
          {"id": "g007", "name": "Tâm lý"},
          {"id": "g008", "name": "Gia đình"}
        ],
        "rating": 8.6,
        "isShowingNow": true,
        "description":
            "Bộ phim kể về tình mẫu tử thiêng liêng và sự hy sinh thầm lặng của người mẹ. Thông qua những câu chuyện đời thường, phim khắc họa chân thực và xúc động về tình yêu thương vô bờ bến của mẹ.",
        "cast": [
          "NSND Hồng Vân",
          "Minh Thư",
          "NSND Trần Nhượng",
          "Hoàng Yến",
          "NSND Trần Bảo Huy"
        ],
        "reviewCount": 880,
        "releaseDate": "25/02/2024",
        "director": "NSND Trần Bảo Huy",
        "comments": []
      },
      {
        "id": "movie5",
        "title": "Đường Đua Số 1",
        "imagePath":
            "https://image.tmdb.org/t/p/w500/5Kv9H9KOO3Dl1LSmWXo3gyl5dUV.jpg",
        "trailerUrl": "https://www.youtube.com/watch?v=6qZqXqXqXqX",
        "duration": "140 phút",
        "genres": [
          {"id": "g009", "name": "Thể thao"},
          {"id": "g010", "name": "Động lực"}
        ],
        "rating": 8.3,
        "isShowingNow": true,
        "description":
            "Bộ phim kể về hành trình vươn lên của một vận động viên đua xe đạp trẻ. Với niềm đam mê và quyết tâm, anh đã vượt qua mọi khó khăn để trở thành nhà vô địch quốc gia.",
        "cast": [
          "Tuấn Trần",
          "Minh Thư",
          "NSND Trần Nhượng",
          "Hoàng Yến",
          "NSND Trần Bảo Huy"
        ],
        "reviewCount": 650,
        "releaseDate": "01/03/2024",
        "director": "NSND Trần Bảo Huy",
        "comments": []
      },
      {
        "id": "movie6",
        "title": "Người Đàn Bà Thứ Hai",
        "imagePath":
            "https://image.tmdb.org/t/p/w500/6Kv9H9KOO3Dl1LSmWXo3gyl5dUV.jpg",
        "trailerUrl": "https://www.youtube.com/watch?v=5qZqXqXqXqX",
        "duration": "130 phút",
        "genres": [
          {"id": "g011", "name": "Tâm lý"},
          {"id": "g012", "name": "Tình cảm"}
        ],
        "rating": 8.4,
        "isShowingNow": true,
        "description":
            "Bộ phim kể về cuộc đời của một người phụ nữ phải đối mặt với những khó khăn trong tình yêu và hôn nhân. Thông qua những trải nghiệm đau thương, cô dần tìm thấy sức mạnh để đứng lên và sống cho chính mình.",
        "cast": [
          "NSND Hồng Vân",
          "Minh Thư",
          "NSND Trần Nhượng",
          "Hoàng Yến",
          "NSND Trần Bảo Huy"
        ],
        "reviewCount": 780,
        "releaseDate": "05/03/2024",
        "director": "NSND Trần Bảo Huy",
        "comments": []
      },
      // Phim sắp chiếu
      {
        "id": "movie7",
        "title": "Đất Phương Nam 2",
        "imagePath":
            "https://image.tmdb.org/t/p/w500/7Kv9H9KOO3Dl1LSmWXo3gyl5dUV.jpg",
        "trailerUrl": "https://www.youtube.com/watch?v=4qZqXqXqXqX",
        "duration": "145 phút",
        "genres": [
          {"id": "g013", "name": "Phiêu lưu"},
          {"id": "g014", "name": "Lịch sử"}
        ],
        "rating": 0,
        "isShowingNow": false,
        "description":
            "Tiếp nối câu chuyện của phần 1, Đất Phương Nam 2 kể về những cuộc phiêu lưu mới của nhân vật chính khi anh trưởng thành và phải đối mặt với những thử thách lớn hơn trong cuộc sống.",
        "cast": [
          "Hoàng Yến",
          "NSND Trần Nhượng",
          "NSND Hồng Vân",
          "Minh Thư",
          "NSND Trần Bảo Huy"
        ],
        "reviewCount": 0,
        "releaseDate": "15/03/2024",
        "director": "NSND Trần Bảo Huy",
        "comments": []
      },
      {
        "id": "movie8",
        "title": "Mùa Hè Của Mẹ",
        "imagePath":
            "https://image.tmdb.org/t/p/w500/8Kv9H9KOO3Dl1LSmWXo3gyl5dUV.jpg",
        "trailerUrl": "https://www.youtube.com/watch?v=3qZqXqXqXqX",
        "duration": "120 phút",
        "genres": [
          {"id": "g015", "name": "Tình cảm"},
          {"id": "g016", "name": "Gia đình"}
        ],
        "rating": 0,
        "isShowingNow": false,
        "description":
            "Bộ phim kể về một mùa hè đặc biệt khi người mẹ trở về quê hương sau nhiều năm xa cách. Thông qua những khoảnh khắc ấm áp bên gia đình, phim khắc họa tình yêu thương và sự gắn kết giữa các thế hệ.",
        "cast": [
          "NSND Hồng Vân",
          "Minh Thư",
          "NSND Trần Nhượng",
          "Hoàng Yến",
          "NSND Trần Bảo Huy"
        ],
        "reviewCount": 0,
        "releaseDate": "20/03/2024",
        "director": "NSND Trần Bảo Huy",
        "comments": []
      },
      {
        "id": "movie9",
        "title": "Đường Đua Số 2",
        "imagePath":
            "https://image.tmdb.org/t/p/w500/9Kv9H9KOO3Dl1LSmWXo3gyl5dUV.jpg",
        "trailerUrl": "https://www.youtube.com/watch?v=2qZqXqXqXqX",
        "duration": "135 phút",
        "genres": [
          {"id": "g017", "name": "Thể thao"},
          {"id": "g018", "name": "Động lực"}
        ],
        "rating": 0,
        "isShowingNow": false,
        "description":
            "Tiếp nối thành công của phần 1, Đường Đua Số 2 kể về hành trình mới của vận động viên đua xe đạp khi anh phải đối mặt với những thử thách lớn hơn trên đường đua quốc tế.",
        "cast": [
          "Tuấn Trần",
          "Minh Thư",
          "NSND Trần Nhượng",
          "Hoàng Yến",
          "NSND Trần Bảo Huy"
        ],
        "reviewCount": 0,
        "releaseDate": "25/03/2024",
        "director": "NSND Trần Bảo Huy",
        "comments": []
      }
    ];

    try {
      print('Bắt đầu import ${movies.length} phim...');

      for (var movie in movies) {
        await _firestore.collection('movies').doc(movie['id']).set(movie);
      }

      print('Hoàn thành import phim');
    } catch (e) {
      print('Lỗi khi import phim: $e');
      throw e;
    }
  }
}
