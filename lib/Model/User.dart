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
    return {
      "id": id,
      "fullName": fullName,
      "phoneNumber": phoneNumber,
      "email": email,
      "hashedPassword": hashedPassword, // Mật khẩu phải mã hóa trước khi lưu
      "birthDate": Timestamp.fromDate(birthDate),
      "gender": gender,
      "province": province,
      "district": district,
      "status": status,
      "createdAt": Timestamp.fromDate(createdAt),
      "updatedAt": updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  // Tạo User từ JSON (dùng khi lấy dữ liệu từ database hoặc API)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      fullName: json["fullName"],
      phoneNumber: json["phoneNumber"],
      email: json["email"],
      hashedPassword: json["hashedPassword"],
      birthDate: _convertToDateTime(json["birthDate"]),
      gender: json["gender"],
      province: json["province"],
      district: json["district"],
      status: json["status"] ?? "Active",
      createdAt: _convertToDateTime(json["createdAt"]),
      updatedAt: json["updatedAt"] != null
          ? _convertToDateTime(json["updatedAt"])
          : null,
    );
  }

  // Helper để chuyển đổi các giá trị thời gian từ Firestore
  static DateTime _convertToDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is DateTime) {
      return value;
    } else if (value is String) {
      return DateTime.parse(value);
    }
    throw Exception('Kiểu dữ liệu không được hỗ trợ: ${value.runtimeType}');
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
