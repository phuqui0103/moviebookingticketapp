import 'District.dart';
import 'Provice.dart';

class User {
  String name; // Họ tên
  String phone; // Số điện thoại
  String email; // Email
  String password; // Mật khẩu
  String birthDate; // Ngày sinh
  String gender; // Giới tính
  Province province; // Tỉnh
  District district; // Huyện

  User({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.birthDate,
    required this.gender,
    required this.province,
    required this.district,
  });

  // Phương thức chuyển đổi từ Map sang User
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      password: map['password'],
      birthDate: map['birthDate'],
      gender: map['gender'],
      province: Province.fromMap(map['province']),
      district: District.fromMap(map['district']),
    );
  }

  // Phương thức chuyển đổi từ User sang Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'birthDate': birthDate,
      'gender': gender,
      'province': province.toMap(),
      'district': district.toMap(),
    };
  }
}
