import 'package:flutter/material.dart';
import 'package:movieticketbooking/View/user/login_screen.dart';
import 'package:movieticketbooking/Components/loading_animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController otpController = TextEditingController();
  String? gender;
  String? province;
  String? district;
  bool _obscureText = true;
  bool _isAgreed = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _showOtpField = false;
  String? nameError;
  String? phoneError;
  String? emailError;
  String? passwordError;
  String? birthDateError;
  String? confirmPasswordError;
  String? otpError;
  String? _verificationId;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _register(BuildContext context) {
    nameError = null;
    phoneError = null;
    emailError = null;
    passwordError = null;
    birthDateError = null;
    confirmPasswordError = null;
    otpError = null;

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
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError = 'Vui lòng nhập lại mật khẩu';
    }
    if (passwordController.text != confirmPasswordController.text) {
      confirmPasswordError = 'Mật khẩu không khớp';
    }
    if (birthDateController.text.isEmpty) {
      birthDateError = 'Vui lòng chọn ngày sinh';
    }
    if (!_isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng đồng ý với điều khoản và điều kiện'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (nameError != null ||
        phoneError != null ||
        emailError != null ||
        passwordError != null ||
        birthDateError != null ||
        confirmPasswordError != null) {
      setState(() {});
      return;
    }

    // Hiển thị dialog xác nhận gửi email
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xff2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          'Xác nhận email',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chúng tôi sẽ gửi mã xác nhận đến email:',
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 10),
            Text(
              emailController.text,
              style: TextStyle(
                color: Colors.orange,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Bạn có muốn tiếp tục?',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Hủy',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _verifyEmail();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Gửi mã'),
          ),
        ],
      ),
    );
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

  Future<void> _verifyEmail() async {
    setState(() {
      _isLoading = true;
      emailError = null;
    });

    try {
      // Tạo tài khoản với email và mật khẩu
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Gửi email xác thực
      await userCredential.user!.sendEmailVerification();

      setState(() {
        _isLoading = false;
      });

      // Hiển thị dialog nhập mã xác thực
      _showEmailVerificationDialog();
    } catch (e) {
      setState(() {
        emailError = 'Lỗi: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _showEmailVerificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xff2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          'Xác nhận email',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Vui lòng kiểm tra email của bạn và nhấn vào link xác nhận để hoàn tất đăng ký.',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Nếu bạn không nhận được email, vui lòng kiểm tra thư mục spam.',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isLoading = false;
              });
            },
            child: Text(
              'Hủy',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _checkEmailVerification();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Đã xác nhận'),
          ),
        ],
      ),
    );
  }

  Future<void> _checkEmailVerification() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Kiểm tra trạng thái xác thực email
      await _auth.currentUser!.reload();
      if (_auth.currentUser!.emailVerified) {
        // Lưu thông tin người dùng vào Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .set({
          'name': nameController.text,
          'phone': phoneController.text,
          'email': emailController.text,
          'birthDate': birthDateController.text,
          'gender': gender,
          'province': province,
          'district': district,
          'createdAt': FieldValue.serverTimestamp(),
        });

        setState(() {
          _isLoading = false;
        });
        _showSuccessDialog();
      } else {
        setState(() {
          emailError = 'Vui lòng xác nhận email trước khi tiếp tục';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        emailError = 'Lỗi: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xff2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          'Đăng ký thành công',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Tài khoản của bạn đã được tạo thành công!',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text(
              'Đóng',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff252429),
      body: Stack(
        children: [
          // Background gradient with pattern
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff252429),
                  Color(0xff2A2A2A),
                ],
              ),
            ),
            child: CustomPaint(
              painter: PatternPainter(),
            ),
          ),
          // Content
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Logo
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 800),
                    curve: Curves.easeOutBack,
                    builder: (context, double value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange.withOpacity(0.2),
                                Colors.orange.withOpacity(0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.movie_creation_outlined,
                            size: 60,
                            color: Colors.orange,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30),
                  // Animated Title
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 800),
                    curve: Curves.easeOutBack,
                    builder: (context, double value, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: Text(
                            'Đăng Ký',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              shadows: [
                                Shadow(
                                  color: Colors.orange.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 40),
                  // Name input with animation
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 800),
                    curve: Curves.easeOutBack,
                    builder: (context, double value, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: nameController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Họ tên',
                                    hintStyle: TextStyle(color: Colors.white38),
                                    border: InputBorder.none,
                                    icon: Icon(Icons.person_outline,
                                        color: Colors.orange),
                                  ),
                                ),
                                if (nameError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 8.0),
                                    child: Text(nameError!,
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 12)),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  // Phone input with animation
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 800),
                    curve: Curves.easeOutBack,
                    builder: (context, double value, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: phoneController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Số điện thoại',
                                    hintStyle: TextStyle(color: Colors.white38),
                                    border: InputBorder.none,
                                    icon: Icon(Icons.phone_outlined,
                                        color: Colors.orange),
                                    prefixText: '+84 ',
                                    prefixStyle: TextStyle(color: Colors.white),
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                                if (phoneError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 8.0),
                                    child: Text(phoneError!,
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 12)),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  // Email input with animation
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 800),
                    curve: Curves.easeOutBack,
                    builder: (context, double value, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: emailController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    hintStyle: TextStyle(color: Colors.white38),
                                    border: InputBorder.none,
                                    icon: Icon(Icons.email_outlined,
                                        color: Colors.orange),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                if (emailError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 8.0),
                                    child: Text(emailError!,
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 12)),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  // Password input with animation
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 800),
                    curve: Curves.easeOutBack,
                    builder: (context, double value, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: passwordController,
                                  style: TextStyle(color: Colors.white),
                                  obscureText: _obscurePassword,
                                  decoration: InputDecoration(
                                    hintText: 'Mật khẩu',
                                    hintStyle: TextStyle(color: Colors.white38),
                                    border: InputBorder.none,
                                    icon: Icon(Icons.lock_outline,
                                        color: Colors.orange),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: Colors.white38,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                if (passwordError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 8.0),
                                    child: Text(passwordError!,
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 12)),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  // Confirm password input with animation
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 800),
                    curve: Curves.easeOutBack,
                    builder: (context, double value, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: confirmPasswordController,
                                  style: TextStyle(color: Colors.white),
                                  obscureText: _obscureConfirmPassword,
                                  decoration: InputDecoration(
                                    hintText: 'Nhập lại mật khẩu',
                                    hintStyle: TextStyle(color: Colors.white38),
                                    border: InputBorder.none,
                                    icon: Icon(Icons.lock_outline,
                                        color: Colors.orange),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfirmPassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: Colors.white38,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureConfirmPassword =
                                              !_obscureConfirmPassword;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                if (confirmPasswordError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 8.0),
                                    child: Text(confirmPasswordError!,
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 12)),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  // Birth date and gender row with animation
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 800),
                    curve: Curves.easeOutBack,
                    builder: (context, double value, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _selectDate(context),
                                  child: AbsorbPointer(
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.1),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            blurRadius: 10,
                                            offset: Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: TextField(
                                        controller: birthDateController,
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                          hintText: 'Ngày sinh',
                                          hintStyle:
                                              TextStyle(color: Colors.white38),
                                          border: InputBorder.none,
                                          icon: Icon(
                                              Icons.calendar_today_outlined,
                                              color: Colors.orange),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.1),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 10,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    value: gender,
                                    hint: Text('Giới tính',
                                        style:
                                            TextStyle(color: Colors.white38)),
                                    items: <String>['Nam', 'Nữ', 'Khác']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value,
                                            style:
                                                TextStyle(color: Colors.white)),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        gender = newValue;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(Icons.person_outline,
                                          color: Colors.orange),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  // Province and district dropdowns with animation
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 800),
                    curve: Curves.easeOutBack,
                    builder: (context, double value, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: province,
                                  hint: Text('Tỉnh',
                                      style: TextStyle(color: Colors.white38)),
                                  items: <String>['Tỉnh 1', 'Tỉnh 2', 'Tỉnh 3']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          style:
                                              TextStyle(color: Colors.white)),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      province = newValue;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(Icons.location_city_outlined,
                                        color: Colors.orange),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: district,
                                  hint: Text('Quận/Huyện',
                                      style: TextStyle(color: Colors.white38)),
                                  items: <String>['Quận 1', 'Quận 2', 'Quận 3']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          style:
                                              TextStyle(color: Colors.white)),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      district = newValue;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(Icons.location_on_outlined,
                                        color: Colors.orange),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  // Terms checkbox with animation
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 800),
                    curve: Curves.easeOutBack,
                    builder: (context, double value, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: CheckboxListTile(
                            title: Text(
                              'Tôi đồng ý với các điều khoản và điều kiện',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 14),
                            ),
                            value: _isAgreed,
                            onChanged: (bool? value) {
                              setState(() {
                                _isAgreed = value ?? false;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: Colors.orange,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30),
                  // Register button with animation
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 800),
                    curve: Curves.easeOutBack,
                    builder: (context, double value, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () => _register(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 5,
                                shadowColor: Colors.orange.withOpacity(0.5),
                              ),
                              child: Text(
                                'Đăng Ký',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 5,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  // Login suggestion with animation
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 800),
                    curve: Curves.easeOutBack,
                    builder: (context, double value, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Đã có tài khoản? ',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                  );
                                },
                                child: Text(
                                  'Đăng nhập',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.orange.withOpacity(0.3),
                                        blurRadius: 5,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: LoadingAnimation(
                text: 'Đang xử lý...',
                size: 100,
              ),
            ),
        ],
      ),
    );
  }
}

class PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    for (var i = 0; i < size.width; i += 30) {
      for (var j = 0; j < size.height; j += 30) {
        canvas.drawCircle(Offset(i.toDouble(), j.toDouble()), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
