import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String fullName;
  String phoneNumber;
  String email;
  String hashedPassword; // Mật khẩu đã mã hóa
  DateTime birthDate;
  String gender;
  String province;
  String district;
  String status; // "Active", "Blocked", "Deleted"
  DateTime createdAt; // Thời gian tạo tài khoản
  DateTime? updatedAt; // Thời gian cập nhật gần nhất

  User({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.hashedPassword,
    required this.birthDate,
    required this.gender,
    required this.province,
    required this.district,
    this.status = "Active",
    required this.createdAt,
    this.updatedAt,
  });

  // Chuyển đổi User thành JSON (lưu database hoặc gửi API)
  Map<String, dynamic> toJson() {
    try {
      print('Chuyển đổi User thành JSON');
      final json = {
        "id": id.toString(),
        "fullName": fullName.toString(),
        "phoneNumber": phoneNumber.toString(),
        "email": email.toString(),
        "hashedPassword": hashedPassword.toString(),
        "birthDate": Timestamp.fromDate(birthDate),
        "gender": gender.toString(),
        "province": province.toString(),
        "district": district.toString(),
        "status": status.toString(),
        "createdAt": Timestamp.fromDate(createdAt),
        "updatedAt": updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      };
      print('Chuyển đổi User thành JSON thành công');
      return json;
    } catch (e, stackTrace) {
      print('Lỗi khi chuyển đổi User thành JSON: $e');
      print('Stack trace: $stackTrace');
      // Trả về một JSON an toàn
      return {
        "id": id.toString(),
        "fullName": fullName.toString(),
        "phoneNumber": phoneNumber.toString(),
        "email": email.toString(),
        "hashedPassword": hashedPassword.toString(),
        "birthDate": Timestamp.fromDate(DateTime.now()),
        "gender": gender.toString(),
        "province": province.toString(),
        "district": district.toString(),
        "status": status.toString(),
        "createdAt": Timestamp.fromDate(DateTime.now()),
        "updatedAt": null,
      };
    }
  }

  // Tạo User từ JSON (dùng khi lấy dữ liệu từ database hoặc API)
  factory User.fromJson(Map<String, dynamic> json) {
    try {
      print('Chuyển đổi từ JSON sang User: ${json.keys.toList()}');

      // Xử lý dữ liệu thời gian
      DateTime birthDate;
      DateTime createdAt;
      DateTime? updatedAt;

      try {
        birthDate = (json["birthDate"] as Timestamp).toDate();
      } catch (e) {
        print('Lỗi khi chuyển đổi birthDate: $e');
        birthDate = DateTime.now();
      }

      try {
        createdAt = (json["createdAt"] as Timestamp).toDate();
      } catch (e) {
        print('Lỗi khi chuyển đổi createdAt: $e');
        createdAt = DateTime.now();
      }

      try {
        updatedAt = json["updatedAt"] != null
            ? (json["updatedAt"] as Timestamp).toDate()
            : null;
      } catch (e) {
        print('Lỗi khi chuyển đổi updatedAt: $e');
        updatedAt = null;
      }

      return User(
        id: json["id"]?.toString() ?? '',
        fullName: json["fullName"]?.toString() ?? '',
        phoneNumber: json["phoneNumber"]?.toString() ?? '',
        email: json["email"]?.toString() ?? '',
        hashedPassword: json["hashedPassword"]?.toString() ?? '',
        birthDate: birthDate,
        gender: json["gender"]?.toString() ?? 'Khác',
        province: json["province"]?.toString() ?? 'Chưa chọn',
        district: json["district"]?.toString() ?? 'Chưa chọn',
        status: json["status"]?.toString() ?? "Active",
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    } catch (e, stackTrace) {
      print('Lỗi khi chuyển đổi từ JSON sang User: $e');
      print('Stack trace: $stackTrace');
      // Tạo một user mặc định trong trường hợp có lỗi
      return User(
        id: json["id"]?.toString() ?? 'unknown',
        fullName: json["fullName"]?.toString() ?? 'Unknown User',
        phoneNumber: json["phoneNumber"]?.toString() ?? '',
        email: json["email"]?.toString() ?? '',
        hashedPassword: json["hashedPassword"]?.toString() ?? '',
        birthDate: DateTime.now(),
        gender: 'Khác',
        province: 'Chưa chọn',
        district: 'Chưa chọn',
        status: "Active",
        createdAt: DateTime.now(),
      );
    }
  }

  // Helper để chuyển đổi các giá trị thời gian từ Firestore
  static DateTime _convertToDateTime(dynamic value) {
    print(
        'Đang chuyển đổi giá trị thời gian: $value (kiểu: ${value.runtimeType})');

    if (value == null) {
      print('Giá trị null, sử dụng thời gian hiện tại');
      return DateTime.now();
    } else if (value is Timestamp) {
      print('Giá trị kiểu Timestamp');
      return value.toDate();
    } else if (value is DateTime) {
      print('Giá trị kiểu DateTime');
      return value;
    } else if (value is String) {
      print('Giá trị kiểu String');
      try {
        return DateTime.parse(value);
      } catch (e) {
        print('Lỗi phân tích chuỗi thành DateTime: $e');
        return DateTime.now();
      }
    } else if (value is int) {
      print('Giá trị kiểu int (milliseconds)');
      return DateTime.fromMillisecondsSinceEpoch(value);
    } else if (value is Map) {
      print('Giá trị kiểu Map, kiểm tra trường seconds và nanoseconds');
      if (value.containsKey('seconds') && value.containsKey('nanoseconds')) {
        try {
          int seconds = value['seconds'];
          int nanoseconds = value['nanoseconds'];
          return DateTime.fromMillisecondsSinceEpoch(
              seconds * 1000 + (nanoseconds / 1000000).round());
        } catch (e) {
          print('Lỗi khi chuyển đổi từ Map: $e');
          return DateTime.now();
        }
      }
    }

    print('Kiểu dữ liệu không được hỗ trợ: ${value.runtimeType}');
    print('Sử dụng thời gian hiện tại thay thế');
    return DateTime.now(); // Fallback an toàn thay vì throw exception
  }

  // Phương thức tiện ích để cập nhật dữ liệu trong Firestore
  static Map<String, dynamic> updateData({
    String? fullName,
    String? phoneNumber,
    String? email,
    String? hashedPassword,
    DateTime? birthDate,
    String? gender,
    String? province,
    String? district,
    String? status,
  }) {
    final Map<String, dynamic> data = {};

    if (fullName != null) data['fullName'] = fullName;
    if (phoneNumber != null) data['phoneNumber'] = phoneNumber;
    if (email != null) data['email'] = email;
    if (hashedPassword != null) data['hashedPassword'] = hashedPassword;
    if (birthDate != null) data['birthDate'] = Timestamp.fromDate(birthDate);
    if (gender != null) data['gender'] = gender;
    if (province != null) data['province'] = province;
    if (district != null) data['district'] = district;
    if (status != null) data['status'] = status;

    // Tự động thêm thời gian cập nhật
    data['updatedAt'] = Timestamp.fromDate(DateTime.now());

    return data;
  }
}
