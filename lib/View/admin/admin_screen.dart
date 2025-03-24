import 'package:flutter/material.dart';
import 'package:movieticketbooking/Model/User.dart';

class AdminScreen extends StatefulWidget {
  final User user;

  const AdminScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản trị viên'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Xin chào, ${widget.user.fullName}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildAdminCard(
              'Quản lý phim',
              'Thêm, sửa, xóa thông tin phim',
              Icons.movie,
              () {
                // TODO: Implement movie management
              },
            ),
            const SizedBox(height: 16),
            _buildAdminCard(
              'Quản lý lịch chiếu',
              'Thêm, sửa, xóa lịch chiếu phim',
              Icons.calendar_today,
              () {
                // TODO: Implement schedule management
              },
            ),
            const SizedBox(height: 16),
            _buildAdminCard(
              'Quản lý người dùng',
              'Xem danh sách và quản lý tài khoản người dùng',
              Icons.people,
              () {
                // TODO: Implement user management
              },
            ),
            const SizedBox(height: 16),
            _buildAdminCard(
              'Thống kê doanh thu',
              'Xem báo cáo doanh thu theo thời gian',
              Icons.bar_chart,
              () {
                // TODO: Implement revenue statistics
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.blue,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
