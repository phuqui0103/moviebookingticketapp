import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'movie_service.dart';
import 'ai_service.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final MovieService _movieService = MovieService();
  final AIService _aiService = AIService();

  // Danh sách các từ khóa và câu trả lời tự động
  final Map<String, String> _autoResponses = {
    'giá vé':
        'Giá vé phim từ 50.000đ - 150.000đ tùy theo suất chiếu và loại ghế:\n\n' +
            '• Ghế thường: 50.000đ - 80.000đ\n' +
            '• Ghế VIP: 100.000đ - 120.000đ\n' +
            '• Ghế đôi: 150.000đ\n\n' +
            'Bạn có thể xem chi tiết giá vé khi chọn suất chiếu.',
    'giờ chiếu':
        'Các suất chiếu thường từ 10:00 - 22:00. Vui lòng kiểm tra lịch chiếu cụ thể cho từng phim.',
    'đặt vé': 'Để đặt vé online, bạn cần thực hiện các bước sau:\n\n' +
        '1. Chọn phim và suất chiếu phù hợp\n' +
        '2. Chọn ghế theo sơ đồ rạp\n' +
        '3. Xác nhận thông tin cá nhân\n' +
        '4. Chọn phương thức thanh toán\n' +
        '5. Nhận mã vé qua email\n\n' +
        'Lưu ý: Vui lòng đến rạp trước 15 phút để đổi vé.',
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
    'phim':
        'Bạn muốn xem thông tin về phim nào? Tôi có thể giúp bạn tìm hiểu về:\n\n' +
            '• Phim đang chiếu\n' +
            '• Thông tin chi tiết phim\n' +
            '• Lịch chiếu\n' +
            '• Giá vé',
    'vé': 'Bạn cần hỗ trợ gì về vé?\n\n' +
        '• Đặt vé\n' +
        '• Hủy vé\n' +
        '• Xem vé đã đặt\n' +
        '• Giá vé',
    'lịch': 'Bạn muốn xem lịch chiếu của phim nào? Tôi có thể giúp bạn:\n\n' +
        '• Xem lịch chiếu theo ngày\n' +
        '• Xem lịch chiếu theo phim\n' +
        '• Xem lịch chiếu theo rạp',
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
  Future<void> sendMessage(String content) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final sessionId = '${user.uid}_${DateTime.now().millisecondsSinceEpoch}';

      // Lưu tin nhắn của người dùng
      await _firestore.collection('messages').add({
        'userId': user.uid,
        'userName': user.displayName ?? 'Người dùng',
        'content': content,
        'timestamp': FieldValue.serverTimestamp(),
        'sessionId': sessionId,
      });

      // Gọi AI để lấy phản hồi
      final response = await _aiService.getAnswer(content);

      // Lưu phản hồi của bot
      await _firestore.collection('messages').add({
        'userId': 'bot',
        'userName': 'Trợ lý ảo',
        'content': response,
        'timestamp': FieldValue.serverTimestamp(),
        'sessionId': sessionId,
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Future<void> clearMessages() async {
    try {
      final batch = _firestore.batch();
      final messages = await _firestore.collection('messages').get();

      for (var doc in messages.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      print('All messages cleared successfully'); // Debug log
    } catch (e) {
      print('Error clearing messages: $e');
    }
  }

  // Lấy stream tin nhắn
  Stream<QuerySnapshot> getMessages() {
    print('Getting messages from Firestore...'); // Debug log
    return _firestore
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      print('Received ${snapshot.docs.length} messages'); // Debug log
      for (var doc in snapshot.docs) {
        print('Message: ${doc.data()}'); // Debug log
      }
      return snapshot;
    });
  }
}
