import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'movie_service.dart';
import '../Model/Movie.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final MovieService _movieService = MovieService();

  // Danh sách các từ khóa và câu trả lời tự động
  final Map<String, String> _autoResponses = {
    'giá vé':
        'Giá vé phim từ 50.000đ - 100.000đ tùy theo suất chiếu và loại ghế.',
    'giờ chiếu':
        'Các suất chiếu thường từ 10:00 - 22:00. Vui lòng kiểm tra lịch chiếu cụ thể cho từng phim.',
    'đặt vé':
        'Bạn có thể đặt vé trực tiếp tại rạp hoặc đặt online qua ứng dụng.',
    'hủy vé':
        'Vé có thể được hủy trước 24h so với thời gian chiếu. Vui lòng liên hệ hotline để được hỗ trợ.',
    'thanh toán':
        'Chúng tôi chấp nhận thanh toán bằng tiền mặt, thẻ tín dụng, và các ví điện tử phổ biến.',
    'xem phim':
        'Bạn có thể xem danh sách phim đang chiếu tại trang chủ của ứng dụng.',
    'rạp':
        'Chúng tôi có nhiều rạp chiếu phim tại các địa điểm khác nhau. Vui lòng chọn rạp gần nhất với bạn.',
    'khuyến mãi':
        'Thường xuyên có các chương trình khuyến mãi và ưu đãi đặc biệt. Vui lòng theo dõi thông báo.',
    'thành viên':
        'Đăng ký thành viên để nhận nhiều ưu đãi đặc biệt và tích điểm khi mua vé.',
    'hotline': 'Hotline hỗ trợ: 1900xxxx. Thời gian làm việc: 8:00 - 22:00.',
  };

  // Tìm câu trả lời tự động dựa trên nội dung tin nhắn
  String? _findAutoResponse(String message) {
    message = message.toLowerCase();
    for (var keyword in _autoResponses.keys) {
      if (message.contains(keyword)) {
        return _autoResponses[keyword];
      }
    }
    return null;
  }

  // Lấy danh sách phim đang chiếu
  Future<String> _getNowShowingMovies() async {
    try {
      final movies = await _movieService.getNowShowingMovies().first;
      if (movies.isEmpty) {
        return 'Hiện tại không có phim nào đang chiếu. Vui lòng quay lại sau.';
      }

      String response = 'Hôm nay có các phim sau đang chiếu:\n\n';
      for (var movie in movies) {
        response += '• ${movie.title}\n';
        response += '  Thời lượng: ${movie.duration}\n';
        response += '  Đạo diễn: ${movie.director}\n';
        response +=
            '  Thể loại: ${movie.genres.map((g) => g.name).join(", ")}\n\n';
      }
      response +=
          'Bạn có thể xem chi tiết và đặt vé cho bất kỳ phim nào trong danh sách trên.';
      return response;
    } catch (e) {
      print('Error getting movies: $e');
      return 'Xin lỗi, tôi không thể lấy thông tin phim lúc này. Vui lòng thử lại sau.';
    }
  }

  // Gửi tin nhắn và xử lý trả lời tự động
  Future<String> sendMessage(String content) async {
    try {
      final user = auth.FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      // Gửi tin nhắn của người dùng
      await _firestore.collection('messages').add({
        'content': content,
        'userId': user.uid,
        'userName': user.displayName ?? 'Người dùng',
        'timestamp': FieldValue.serverTimestamp(),
        'sessionId':
            user.uid + DateTime.now().millisecondsSinceEpoch.toString(),
      });

      // Xử lý câu trả lời dựa trên nội dung tin nhắn
      String response = '';
      if (content.toLowerCase().contains('phim')) {
        response = await _getNowShowingMovies();
      } else if (content.toLowerCase().contains('vé')) {
        response = 'Xem vé đã đặt ở đâu?';
      } else if (content.toLowerCase().contains('giá')) {
        response =
            'Giá vé phim từ 50.000đ - 150.000đ tùy theo suất chiếu và loại ghế:\n\n' +
                '• Ghế thường: 50.000đ - 80.000đ\n' +
                '• Ghế VIP: 100.000đ - 120.000đ\n' +
                '• Ghế đôi: 150.000đ\n\n' +
                'Bạn có thể xem chi tiết giá vé khi chọn suất chiếu.';
      } else if (content.toLowerCase().contains('cách đặt')) {
        response = 'Để đặt vé online, bạn cần thực hiện các bước sau:\n\n' +
            '1. Chọn phim và suất chiếu phù hợp\n' +
            '2. Chọn ghế theo sơ đồ rạp\n' +
            '3. Xác nhận thông tin cá nhân\n' +
            '4. Chọn phương thức thanh toán\n' +
            '5. Nhận mã vé qua email\n\n' +
            'Lưu ý: Vui lòng đến rạp trước 15 phút để đổi vé.';
      } else {
        response =
            'Xin lỗi, tôi không hiểu câu hỏi của bạn. Bạn có thể hỏi về:\n\n' +
                '• Phim đang chiếu\n' +
                '• Vé đã đặt\n' +
                '• Giá vé\n' +
                '• Cách đặt vé online';
      }

      // Gửi câu trả lời của hệ thống
      await _firestore.collection('messages').add({
        'content': response,
        'userId': 'system',
        'userName': 'Hệ thống',
        'timestamp': FieldValue.serverTimestamp(),
        'sessionId':
            user.uid + DateTime.now().millisecondsSinceEpoch.toString(),
      });

      return response;
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }

  Future<void> clearMessages() async {
    try {
      final user = auth.FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final batch = _firestore.batch();
      final messages = await _firestore
          .collection('messages')
          .where('userId', isEqualTo: user.uid)
          .get();

      for (var doc in messages.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      print('Error clearing messages: $e');
      rethrow;
    }
  }

  // Lấy stream tin nhắn
  Stream<QuerySnapshot> getMessages() {
    final user = auth.FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.empty();
    }

    return _firestore
        .collection('messages')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots();
  }
}
