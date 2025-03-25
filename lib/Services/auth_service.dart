import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'dart:convert';
import '../Model/User.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

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

  // Kiểm tra số điện thoại đã tồn tại
  Future<bool> isPhoneNumberExists(String phoneNumber) async {
    final snapshot = await _firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  // Kiểm tra email đã tồn tại
  Future<bool> isEmailExists(String email) async {
    final snapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return snapshot.docs.isNotEmpty;
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
      // Kiểm tra mật khẩu hợp lệ
      final passwordCheck = isPasswordValid(password);
      if (!passwordCheck['isValid']) {
        return {
          'success': false,
          'message': passwordCheck['message'],
        };
      }

      // Kiểm tra email đã tồn tại
      final emailSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (emailSnapshot.docs.isNotEmpty) {
        return {
          'success': false,
          'message': 'Email đã được sử dụng',
        };
      }

      // Kiểm tra số điện thoại đã tồn tại
      final phoneSnapshot = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();
      if (phoneSnapshot.docs.isNotEmpty) {
        return {
          'success': false,
          'message': 'Số điện thoại đã được sử dụng',
        };
      }

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

      // Gửi email xác thực
      await userCredential.user!.sendEmailVerification();

      // Tạo user mới với trạng thái Pending
      final user = User(
        id: userCredential.user!.uid,
        fullName: fullName,
        phoneNumber: phoneNumber,
        email: email,
        hashedPassword: _hashPassword(password),
        birthDate: birthDate,
        gender: gender,
        province: province,
        district: district,
        status: 'Pending',
        createdAt: DateTime.now(),
      );

      // Chuyển đổi user thành JSON và đảm bảo các trường có kiểu dữ liệu đúng
      final userData = {
        'id': user.id,
        'fullName': user.fullName,
        'phoneNumber': user.phoneNumber,
        'email': user.email,
        'hashedPassword': user.hashedPassword,
        'birthDate': Timestamp.fromDate(user.birthDate),
        'gender': user.gender,
        'province': user.province,
        'district': user.district,
        'status': user.status,
        'createdAt': Timestamp.fromDate(user.createdAt),
      };

      // Lưu user vào Firestore
      await _firestore.collection('users').doc(user.id).set(userData);

      return {
        'success': true,
        'message':
            'Đăng ký thành công. Vui lòng kiểm tra email để xác thực tài khoản.',
        'user': user,
      };
    } catch (e) {
      print('Registration error: $e');

      // Xử lý các lỗi cụ thể
      if (e is firebase_auth.FirebaseAuthException) {
        switch (e.code) {
          case 'too-many-requests':
            return {
              'success': false,
              'message':
                  'Quá nhiều lần thử đăng ký. Vui lòng thử lại sau ít phút.',
            };
          case 'email-already-in-use':
            return {
              'success': false,
              'message': 'Email đã được sử dụng.',
            };
          case 'invalid-email':
            return {
              'success': false,
              'message': 'Email không hợp lệ.',
            };
          case 'weak-password':
            return {
              'success': false,
              'message': 'Mật khẩu quá yếu.',
            };
          default:
            return {
              'success': false,
              'message': 'Lỗi đăng ký: ${e.message}',
            };
        }
      } else if (e is TypeError) {
        return {
          'success': false,
          'message': 'Lỗi chuyển đổi kiểu dữ liệu. Vui lòng thử lại.',
        };
      } else if (e.toString().contains('PigeonUserDetails')) {
        return {
          'success': false,
          'message': 'Lỗi xử lý thông tin người dùng. Vui lòng thử lại.',
        };
      }

      return {
        'success': false,
        'message': 'Đã có lỗi xảy ra: $e',
      };
    }
  }

  // Đăng nhập
  Future<Map<String, dynamic>> login({
    required String emailOrPhone,
    required String password,
  }) async {
    try {
      // Kiểm tra xem input là email hay số điện thoại
      bool isEmail = emailOrPhone.contains('@');
      String email;

      if (!isEmail) {
        // Nếu là số điện thoại, tìm email tương ứng trong Firestore
        final userDoc = await _firestore
            .collection('users')
            .where('phoneNumber', isEqualTo: emailOrPhone)
            .limit(1)
            .get();

        if (userDoc.docs.isEmpty) {
          return {
            'success': false,
            'message': 'Không tìm thấy tài khoản với số điện thoại này',
          };
        }

        email = userDoc.docs.first.data()['email'];
      } else {
        email = emailOrPhone;
      }

      // Đăng nhập với Firebase Auth
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Kiểm tra xác thực email
      if (!userCredential.user!.emailVerified) {
        return {
          'success': false,
          'message': 'Vui lòng xác thực email trước khi đăng nhập',
        };
      }

      // Lấy thông tin user từ Firestore
      final snapshot = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!snapshot.exists) {
        return {
          'success': false,
          'message': 'Không tìm thấy thông tin người dùng',
        };
      }

      final user = User.fromJson(snapshot.data()!);

      // Kiểm tra trạng thái tài khoản
      if (user.status != 'Active') {
        return {
          'success': false,
          'message': 'Tài khoản đã bị khóa hoặc chưa được xác thực',
        };
      }

      return {
        'success': true,
        'message': 'Đăng nhập thành công',
        'user': user,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Thông tin đăng nhập không đúng',
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
      await _firestore.collection('users').doc(user.uid).update({
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

  // Quên mật khẩu
  Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    try {
      // Kiểm tra email có tồn tại trong Firestore không
      final userDoc = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userDoc.docs.isEmpty) {
        return {
          'success': false,
          'message': 'Email không tồn tại trong hệ thống',
        };
      }

      // Gửi email reset password
      await _auth.sendPasswordResetEmail(email: email);

      return {
        'success': true,
        'message': 'Đã gửi email hướng dẫn đặt lại mật khẩu',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Đã có lỗi xảy ra khi gửi email',
      };
    }
  }

  // Cập nhật hashedPassword trong Firestore sau khi reset password
  Future<Map<String, dynamic>> updateHashedPasswordAfterReset({
    required String email,
    required String newPassword,
  }) async {
    try {
      // Tìm user trong Firestore bằng email
      final userDoc = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userDoc.docs.isEmpty) {
        return {
          'success': false,
          'message': 'Không tìm thấy tài khoản',
        };
      }

      // Cập nhật hashedPassword mới
      final String hashedPassword = _hashPassword(newPassword);
      await _firestore.collection('users').doc(userDoc.docs.first.id).update({
        'hashedPassword': hashedPassword,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'message': 'Cập nhật mật khẩu thành công',
      };
    } catch (e) {
      print('Error updating hashed password: $e');
      return {
        'success': false,
        'message': 'Đã có lỗi xảy ra khi cập nhật mật khẩu',
      };
    }
  }

  // Đổi mật khẩu
  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('Error: No current user found');
        return {
          'success': false,
          'message': 'Không tìm thấy người dùng hiện tại',
        };
      }

      print('Current user email: ${user.email}');

      // Kiểm tra mật khẩu mới hợp lệ
      final passwordCheck = isPasswordValid(newPassword);
      if (!passwordCheck['isValid']) {
        print('Error: Invalid new password - ${passwordCheck['message']}');
        return {
          'success': false,
          'message': passwordCheck['message'],
        };
      }

      try {
        // Xác thực lại với mật khẩu cũ
        final credential = firebase_auth.EmailAuthProvider.credential(
          email: user.email!,
          password: oldPassword,
        );
        await user.reauthenticateWithCredential(credential);
        print('Re-authentication successful');

        // Cập nhật mật khẩu mới
        await user.updatePassword(newPassword);
        print('Firebase Auth password updated');

        // Cập nhật mật khẩu đã hash trong Firestore
        final hashedPassword = _hashPassword(newPassword);
        print('New password hashed. Updating Firestore...');

        await _firestore.collection('users').doc(user.uid).update({
          'hashedPassword': hashedPassword,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        print('Firestore password updated');

        return {
          'success': true,
          'message': 'Đổi mật khẩu thành công',
        };
      } catch (authError) {
        print('Authentication error: $authError');
        if (authError is firebase_auth.FirebaseAuthException) {
          switch (authError.code) {
            case 'wrong-password':
              return {
                'success': false,
                'message': 'Mật khẩu cũ không đúng',
              };
            case 'requires-recent-login':
              return {
                'success': false,
                'message': 'Vui lòng đăng nhập lại để thực hiện thao tác này',
              };
            default:
              return {
                'success': false,
                'message': 'Lỗi xác thực: ${authError.message}',
              };
          }
        }
        rethrow;
      }
    } catch (e) {
      print('General error: $e');
      return {
        'success': false,
        'message': 'Đã có lỗi xảy ra: $e',
      };
    }
  }
}
