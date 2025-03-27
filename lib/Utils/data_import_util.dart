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
              Text("Đang import dữ liệu..."),
            ],
          ),
        ),
      );

      // Import dữ liệu
      // await importGenres();
      // await importProvinces();
      // await importCinemas();
      // await importRooms();
      // await importMovies();
      // await importShowtimes();
      // await importComments();
      await importDistricts();

      // Đóng dialog loading
      Navigator.pop(context);

      // Hiển thị thông báo thành công
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Thành công"),
          content: const Text("Đã import dữ liệu thành công!\n\n"
              "Dữ liệu đã được thêm vào:\n"
              "- 10 tỉnh/thành phố\n"
              "- 50 quận/huyện"),
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
}
