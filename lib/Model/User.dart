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
      "birthDate": birthDate.toIso8601String(),
      "gender": gender,
      "province": province,
      "district": district,
      "status": status,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
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
      birthDate: DateTime.parse(json["birthDate"]),
      gender: json["gender"],
      province: json["province"],
      district: json["district"],
      status: json["status"] ?? "Active",
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt:
          json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : null,
    );
  }
}
