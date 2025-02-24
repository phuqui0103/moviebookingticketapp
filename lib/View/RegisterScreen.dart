import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  String? gender; // Biến để lưu giới tính
  String? province; // Biến để lưu tỉnh
  String? district; // Biến để lưu quận/huyện
  bool _obscureText = true; // Biến để kiểm soát hiển thị mật khẩu
  bool _isAgreed = false;
  String? nameError; // Biến để lưu thông báo lỗi họ tên
  String? phoneError; // Biến để lưu thông báo lỗi số điện thoại
  String? emailError; // Biến để lưu thông báo lỗi email
  String? passwordError; // Biến để lưu thông báo lỗi mật khẩu
  String? birthDateError; // Biến để lưu thông báo lỗi ngày sinh

  RegisterScreen({super.key});

  void _register(BuildContext context) {
    // Reset thông báo lỗi
    nameError = null;
    phoneError = null;
    emailError = null;
    passwordError = null;
    birthDateError = null;

    // Kiểm tra các trường nhập
    if (nameController.text.isEmpty) {
      nameError = 'Vui lòng nhập họ tên';
    }
    if (phoneController.text.isEmpty ||
        !RegExp(r'^[0-9]{10}$').hasMatch(phoneController.text)) {
      phoneError = 'Vui lòng nhập số điện thoại hợp lệ';
    }
    if (emailController.text.isEmpty ||
        !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
            .hasMatch(emailController.text)) {
      emailError = 'Vui lòng nhập email hợp lệ';
    }
    if (passwordController.text.isEmpty) {
      passwordError = 'Vui lòng nhập mật khẩu';
    }
    if (birthDateController.text.isEmpty) {
      birthDateError = 'Vui lòng chọn ngày sinh';
    }

    // Nếu có lỗi, hiển thị thông báo và dừng hàm
    if (nameError != null ||
        phoneError != null ||
        emailError != null ||
        passwordError != null ||
        birthDateError != null) {
      // Cập nhật giao diện
      (context as Element).markNeedsBuild();
      return;
    }

    // Nếu không có lỗi, thực hiện đăng ký
    Navigator.pushReplacementNamed(context,
        '/home'); // Điều hướng đến trang chính sau khi đăng ký thành công
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      birthDateController.text = "${picked.day}/${picked.month}/${picked.year}";
    }
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
                    'assets/images/login.jpg'), // Đường dẫn đến hình nền
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
                  // Tiêu đề Đăng ký
                  Text(
                    'Đăng Ký',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26, // Kích thước chữ
                      fontWeight: FontWeight.bold, // Đậm
                    ),
                  ),
                  SizedBox(height: 20),
                  // Ô nhập họ tên
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Họ tên',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (nameError != null)
                        Text(nameError!,
                            style: TextStyle(color: Colors.red, fontSize: 12)),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Ô nhập số điện thoại
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          hintText: 'Số điện thoại',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (phoneError != null)
                        Text(phoneError!,
                            style: TextStyle(color: Colors.red, fontSize: 12)),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Ô nhập email
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (emailError != null)
                        Text(emailError!,
                            style: TextStyle(color: Colors.red, fontSize: 12)),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Ô nhập mật khẩu
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: 'Mật khẩu',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              _obscureText =
                                  !_obscureText; // Đảo ngược giá trị của _obscureText
                            },
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (passwordError != null)
                        Text(passwordError!,
                            style: TextStyle(color: Colors.red, fontSize: 12)),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Hàng cho ngày sinh và giới tính
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: birthDateController,
                                  decoration: InputDecoration(
                                    hintText: 'Ngày sinh',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 18),
                                    border: UnderlineInputBorder(),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                ),
                                if (birthDateError != null)
                                  Text(birthDateError!,
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: gender,
                          hint: Text('Giới tính',
                              style: TextStyle(color: Colors.grey)),
                          items: <String>['Nam', 'Nữ', 'Khác']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(color: Colors.grey)),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            gender = newValue;
                          },
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Chọn tỉnh
                  DropdownButtonFormField<String>(
                    value: province,
                    hint: Text('Tỉnh', style: TextStyle(color: Colors.grey)),
                    items: <String>['Tỉnh 1', 'Tỉnh 2', 'Tỉnh 3']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child:
                            Text(value, style: TextStyle(color: Colors.grey)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      province = newValue;
                    },
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Chọn quận/huyện
                  DropdownButtonFormField<String>(
                    value: district,
                    hint: Text('Quận/Huyện',
                        style: TextStyle(color: Colors.grey)),
                    items: <String>['Quận 1', 'Quận 2', 'Quận 3']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child:
                            Text(value, style: TextStyle(color: Colors.grey)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      district = newValue;
                    },
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  CheckboxListTile(
                    title: Text(
                      'Tôi đồng ý với các điều khoản và điều kiện',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    value: _isAgreed,
                    onChanged: (bool? value) {
                      //setState(() {
                      //  _isAgreed =
                      //      value ?? false; // Cập nhật trạng thái checkbox
                      //});
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  SizedBox(height: 20),
                  // Nút đăng ký
                  ElevatedButton(
                    onPressed: () {
                      _register(context); // Gọi hàm đăng ký
                    },
                    child: Text(
                      'Đăng Ký',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 111, 5, 5),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      minimumSize: Size(double.infinity, 0),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Gợi ý đăng nhập
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, '/login'); // Điều hướng đến trang đăng nhập
                    },
                    child: Text(
                      'Đã có tài khoản? Đăng nhập',
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
