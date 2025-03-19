import 'package:flutter/material.dart';
import 'package:movieticketbooking/Components/bottom_nav_bar.dart';
import 'package:movieticketbooking/Model/District.dart';
import 'package:movieticketbooking/Model/Province.dart';
import 'package:movieticketbooking/Model/User.dart';
import 'package:movieticketbooking/main.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  String? emailError; // Biến để lưu thông báo lỗi email
  String? passwordError; // Biến để lưu thông báo lỗi mật khẩu

  LoginScreen({super.key});

  void _login(BuildContext context) async {
    // Reset thông báo lỗi
    emailError = null;
    passwordError = null;

    // Kiểm tra xem người dùng đã nhập email và mật khẩu chưa
    if (emailController.text.isEmpty) {
      emailError = 'Vui lòng nhập email/số điện thoại';
    } else if (!RegExp(r'^[0-9]{10}$').hasMatch(emailController.text) &&
        !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
            .hasMatch(emailController.text)) {
      emailError = 'Vui lòng nhập thông tin hợp lệ';
    }

    if (passwordController.text.isEmpty) {
      passwordError = 'Vui lòng nhập mật khẩu';
    }

    // Nếu có lỗi, hiển thị thông báo và dừng hàm
    if (emailError != null || passwordError != null) {
      // Cập nhật giao diện
      (context as Element).markNeedsBuild();
      return;
    }

    try {
      // Tạo đối tượng User
      if ((emailController.text == 'email' ||
              emailController.text == '0231231231') &&
          passwordController.text == '123123123') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BottomNavBar()));
      }
      // Điều hướng đến trang chính sau khi đăng nhập thành công
    } catch (e) {
      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng nhập không thành công: ${e.toString()}')),
      );
    }
  }

  // Hàm hiển thị mật khẩu
  void _togglePasswordVisibility() {
    _obscureText = !_obscureText; // Đảo ngược giá trị của _obscureText
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hình nền
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/movie2.webp'), // Đường dẫn đến hình nền
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Mờ nền
          Container(
            color: Colors.black.withOpacity(0.5), // Màu đen với độ mờ
          ),
          // Nội dung
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tiêu đề Đăng nhập
                  Text(
                    'Đăng Nhập',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26, // Kích thước chữ
                      fontWeight: FontWeight.bold, // Đậm
                    ),
                  ),
                  SizedBox(height: 40),
                  // Ô nhập email/số điện thoại
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email/Số điện thoại',
                          hintStyle:
                              TextStyle(color: Colors.grey), // Màu chữ của hint
                          border:
                              UnderlineInputBorder(), // Giữ lại dấu gạch chân
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .white), // Màu gạch chân khi ô nhập được chọn
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .grey), // Màu gạch chân khi ô nhập không được chọn
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (emailError != null) // Hiển thị thông báo lỗi nếu có
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            emailError!,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 25),
                  // Ô nhập mật khẩu
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText:
                              'Mật khẩu', // Sử dụng hintText thay vì labelText
                          hintStyle:
                              TextStyle(color: Colors.grey), // Màu chữ của hint
                          border:
                              UnderlineInputBorder(), // Giữ lại dấu gạch chân
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .white), // Màu gạch chân khi ô nhập được chọn
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .grey), // Màu gạch chân khi ô nhập không được chọn
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons
                                      .visibility_off, // Biểu tượng hiển thị/ẩn mật khẩu
                              color: Colors.grey,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _obscureText,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (passwordError !=
                          null) // Hiển thị thông báo lỗi nếu có
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            passwordError!,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight, // Căn chỉnh sang bên phải
                    child: TextButton(
                      onPressed: () {
                        // Navigator.pushNamed(context, '/register'); // Điều hướng đến trang đăng ký
                      },
                      child: Text(
                        'Quên mật khẩu',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Nút đăng nhập
                  ElevatedButton(
                    onPressed: () {
                      _login(context); // Gọi hàm đăng nhập
                    },
                    child: Text(
                      'Đăng Nhập',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 111, 5, 5), // Đổi màu nền nút
                      padding: EdgeInsets.symmetric(
                          vertical: 15), // Padding chiều dọc
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      minimumSize: Size(double.infinity,
                          0), // Kích thước chiều ngang dài nhất
                    ),
                  ),
                  SizedBox(height: 20),
                  // Gợi ý đăng ký tài khoản
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, '/register'); // Điều hướng đến trang đăng ký
                    },
                    child: Text(
                      'Chưa có tài khoản? Đăng ký',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Side {}
