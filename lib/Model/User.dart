class User {
  String fullName;
  String phoneNumber;
  String email;
  String password;
  DateTime birthDate;
  String gender;
  String province;
  String district;
  bool agreedToTerms;

  User({
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.birthDate,
    required this.gender,
    required this.province,
    required this.district,
    required this.agreedToTerms,
  });

  // Chuyển đổi User thành Map (dùng khi lưu vào database hoặc API)
  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "phoneNumber": phoneNumber,
      "email": email,
      "password": password, // Cần mã hóa khi lưu thực tế
      "birthDate": birthDate.toIso8601String(),
      "gender": gender,
      "province": province,
      "district": district,
      "agreedToTerms": agreedToTerms,
    };
  }

  // Tạo User từ Map (dùng khi đọc từ database hoặc API)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json["fullName"],
      phoneNumber: json["phoneNumber"],
      email: json["email"],
      password: json["password"], // Cần giải mã nếu mã hóa
      birthDate: DateTime.parse(json["birthDate"]),
      gender: json["gender"],
      province: json["province"],
      district: json["district"],
      agreedToTerms: json["agreedToTerms"],
    );
  }
}
