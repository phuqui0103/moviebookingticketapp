import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class AIService {
  static const String apiKey =
      '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'; // ⚠️ Thay bằng key thật
  static const String apiUrl =
      'https://api.groq.com/openai/v1/chat/completions';

  // Gọi AI để trả lời dựa trên câu hỏi + dữ liệu Firebase
  Future<String> getAnswer(String userMessage) async {
    try {
      // B1: Lấy dữ liệu từ Firestore (collection: faq)
      final faqSnapshot =
          await FirebaseFirestore.instance.collection('faq').get();
      final faqData = {for (var doc in faqSnapshot.docs) doc.id: doc['answer']};

      // B2: Tạo prompt gợi ý cho AI
      final context =
          faqData.entries.map((e) => "- ${e.key}: ${e.value}").join('\n');
      final prompt = '''
Thông tin hệ thống:
$context

Người dùng hỏi: "$userMessage"
Hãy trả lời rõ ràng và dễ hiểu.
''';

      // B3: Gửi request đến Groq API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode({
          "model": "llama3-70b-8192",
          "messages": [
            {"role": "user", "content": prompt}
          ],
          "temperature": 0.7,
        }),
      );

      // B4: Xử lý phản hồi
      if (response.statusCode == 200) {
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        final reply = json['choices'][0]['message']['content'];
        return reply.trim();
      } else {
        print('❌ AI Error: ${response.body}');
        return 'Xin lỗi, tôi không thể trả lời lúc này.';
      }
    } catch (e) {
      print('❌ Exception: $e');
      return 'Đã xảy ra lỗi khi gọi AI.';
    }
  }
}
