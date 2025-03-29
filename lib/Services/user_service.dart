import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:movieticketbooking/Model/User.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  // Constants for SharedPreferences keys
  static const String KEY_SAVED_EMAIL = 'saved_email';
  static const String KEY_SAVED_PASSWORD = 'saved_password';
  static const String KEY_REMEMBER_LOGIN = 'remember_login';

  // Lưu thông tin đăng nhập
  Future<void> saveLoginInfo(
      String email, String password, bool rememberLogin) async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberLogin) {
      await prefs.setString(KEY_SAVED_EMAIL, email);
      await prefs.setString(KEY_SAVED_PASSWORD, password);
    }
    await prefs.setBool(KEY_REMEMBER_LOGIN, rememberLogin);
  }

  // Lấy thông tin đăng nhập đã lưu
  Future<Map<String, dynamic>> getSavedLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final bool rememberLogin = prefs.getBool(KEY_REMEMBER_LOGIN) ?? false;

    if (rememberLogin) {
      return {
        'email': prefs.getString(KEY_SAVED_EMAIL) ?? '',
        'password': prefs.getString(KEY_SAVED_PASSWORD) ?? '',
        'rememberLogin': true,
      };
    }

    return {
      'email': '',
      'password': '',
      'rememberLogin': false,
    };
  }

  // Xóa thông tin đăng nhập đã lưu
  Future<void> clearSavedLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(KEY_SAVED_EMAIL);
    await prefs.remove(KEY_SAVED_PASSWORD);
    await prefs.remove(KEY_REMEMBER_LOGIN);
  }

  // Hàm băm mật khẩu
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  // Kiểm tra mật khẩu hợp lệ
  Map<String, dynamic> isPasswordValid(String password) {
    if (password.length < 8) {
      return {
        'isValid': false,
        'message': 'Mật khẩu phải có ít nhất 8 ký tự',
      };
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return {
        'isValid': false,
        'message': 'Mật khẩu phải chứa ít nhất 1 chữ hoa',
      };
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return {
        'isValid': false,
        'message': 'Mật khẩu phải chứa ít nhất 1 chữ thường',
      };
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return {
        'isValid': false,
        'message': 'Mật khẩu phải chứa ít nhất 1 ký tự đặc biệt',
      };
    }
    return {
      'isValid': true,
      'message': 'Mật khẩu hợp lệ',
    };
  }

  // Đăng ký người dùng mới
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String phoneNumber,
    required String email,
    required String password,
    required DateTime birthDate,
    required String gender,
    required String province,
    required String district,
  }) async {
    try {
      print('Bắt đầu quá trình đăng ký...');

      // Kiểm tra mật khẩu hợp lệ
      final passwordCheck = isPasswordValid(password);
      if (!passwordCheck['isValid']) {
        return {
          'success': false,
          'message': passwordCheck['message'],
        };
      }

      print('Kiểm tra email có tồn tại...');
      // Kiểm tra email đã tồn tại
      if (await isEmailExists(email)) {
        return {
          'success': false,
          'message': 'Email đã được sử dụng',
        };
      }

      print('Kiểm tra số điện thoại có tồn tại...');
      // Kiểm tra số điện thoại đã tồn tại
      if (await isPhoneNumberExists(phoneNumber)) {
        return {
          'success': false,
          'message': 'Số điện thoại đã được sử dụng',
        };
      }

      print('Tạo tài khoản trên Firebase Auth...');
      // Tạo tài khoản Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return {
          'success': false,
          'message': 'Không thể tạo tài khoản',
        };
      }

      print('Gửi email xác thực...');
      // Gửi email xác thực
      await userCredential.user!.sendEmailVerification();

      print('Tạo đối tượng User...');

      // Log các giá trị đầu vào để gỡ lỗi
      print('ID: ${userCredential.user!.uid}');
      print('Họ tên: $fullName');
      print('Số điện thoại: $phoneNumber');
      print('Email: $email');
      print('Ngày sinh: $birthDate');
      print('Giới tính: $gender');
      print('Tỉnh: $province');
      print('Huyện: $district');

      // Tạo user mới với trạng thái Pending
      final user = User(
        id: userCredential.user!.uid,
        fullName: fullName.trim(),
        phoneNumber: phoneNumber.trim(),
        email: email.trim(),
        hashedPassword: _hashPassword(password),
        birthDate: birthDate,
        gender: gender.trim(),
        province: province.trim(),
        district: district.trim(),
        status: 'Pending',
        createdAt: DateTime.now(),
      );

      print('Tạo đối tượng User thành công! Chuyển đổi thành JSON...');
      final userJson = user.toJson();
      print('Chuyển đổi JSON thành công! Lưu vào Firestore...');

      // Lưu user vào Firestore
      await createUser(user);
      print('Lưu vào Firestore thành công!');

      return {
        'success': true,
        'message':
            'Đăng ký thành công. Vui lòng kiểm tra email để xác thực tài khoản.',
        'user': user,
      };
    } catch (e) {
      print('Error during registration: $e');
      return {
        'success': false,
        'message': 'Đã có lỗi xảy ra trong quá trình đăng ký: $e',
      };
    }
  }

  // Xác thực email và cập nhật trạng thái
  Future<Map<String, dynamic>> verifyEmailAndUpdateStatus() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return {
          'success': false,
          'message': 'Không tìm thấy người dùng hiện tại',
        };
      }

      await user.reload();

      if (!user.emailVerified) {
        return {
          'success': false,
          'message': 'Email chưa được xác thực',
        };
      }

      // Cập nhật trạng thái thành Active
      await updateUser(user.uid, {
        'status': 'Active',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'message': 'Xác thực email thành công',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Đã có lỗi xảy ra: $e',
      };
    }
  }

  // Tạo user mới
  Future<void> createUser(User user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());
    } catch (e) {
      print('Error creating user: $e');
      throw e;
    }
  }

  // Lấy thông tin user theo ID
  Future<User?> getUserById(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return User.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      throw e;
    }
  }

  // Lấy thông tin người dùng hiện tại
  Stream<User?> getCurrentUser() {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;

      try {
        DocumentSnapshot doc =
            await _firestore.collection('users').doc(firebaseUser.uid).get();
        if (doc.exists) {
          return User.fromJson(doc.data() as Map<String, dynamic>);
        }
        return null;
      } catch (e) {
        print('Error getting current user: $e');
        return null;
      }
    });
  }

  // Cập nhật thông tin user
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      print('Error updating user: $e');
      throw e;
    }
  }

  // Xóa user
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      print('Error deleting user: $e');
      throw e;
    }
  }

  // Lấy danh sách tất cả users
  Stream<List<User>> getAllUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return User.fromJson(doc.data());
      }).toList();
    });
  }

  // Kiểm tra email đã tồn tại chưa
  Future<bool> isEmailExists(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking email: $e');
      throw e;
    }
  }

  // Kiểm tra số điện thoại đã tồn tại chưa
  Future<bool> isPhoneNumberExists(String phoneNumber) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking phone number: $e');
      throw e;
    }
  }

  // Đăng nhập
  Future<Map<String, dynamic>> login({
    required String emailOrPhone,
    required String password,
  }) async {
    try {
      // Kiểm tra xem đầu vào là email hay số điện thoại
      bool isEmail = emailOrPhone.contains('@');

      // Logic đăng nhập cho người dùng thông thường
      QuerySnapshot userQuery;
      if (isEmail) {
        userQuery = await _firestore
            .collection('users')
            .where('email', isEqualTo: emailOrPhone.toLowerCase())
            .limit(1)
            .get();
      } else {
        userQuery = await _firestore
            .collection('users')
            .where('phoneNumber', isEqualTo: emailOrPhone)
            .limit(1)
            .get();
      }

      if (userQuery.docs.isEmpty) {
        return {
          'success': false,
          'field': 'emailOrPhone',
          'message':
              isEmail ? 'Email không tồn tại' : 'Số điện thoại không tồn tại',
        };
      }

      final userDoc = userQuery.docs.first;
      final userData = userDoc.data() as Map<String, dynamic>;

      if (userData['hashedPassword'] != _hashPassword(password)) {
        return {
          'success': false,
          'field': 'password',
          'message': 'Mật khẩu không đúng',
        };
      }

      if (userData['status'] == 'Blocked') {
        return {
          'success': false,
          'message': 'Tài khoản của bạn đã bị khóa',
        };
      }

      if (userData['status'] == 'Deleted') {
        return {
          'success': false,
          'message': 'Tài khoản của bạn đã bị xóa',
        };
      }

      return {
        'success': true,
        'message': 'Đăng nhập thành công',
      };
    } catch (e) {
      print('Error during login: $e');
      return {
        'success': false,
        'message': 'Đã có lỗi xảy ra trong quá trình đăng nhập',
      };
    }
  }

  // Quên mật khẩu
  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {
        'success': true,
        'message': 'Email đặt lại mật khẩu đã được gửi',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Email không tồn tại hoặc đã có lỗi xảy ra',
      };
    }
  }

  // Cập nhật mật khẩu sau khi reset
  Future<Map<String, dynamic>> updateHashedPasswordAfterReset({
    required String email,
    required String newPassword,
  }) async {
    try {
      final userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        return {
          'success': false,
          'message': 'Không tìm thấy tài khoản',
        };
      }

      final userDoc = userQuery.docs.first;
      await _firestore.collection('users').doc(userDoc.id).update({
        'hashedPassword': _hashPassword(newPassword),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'message': 'Cập nhật mật khẩu thành công',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Đã có lỗi xảy ra khi cập nhật mật khẩu',
      };
    }
  }
}
