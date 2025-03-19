import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hồ Sơ"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Avatar
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/icons/user.png"),
              ),
            ),
            SizedBox(height: 20),
            // Thông tin User
            Text("Nguyễn Văn A",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            Text("nguyenvana@gmail.com",
                style: TextStyle(color: Colors.grey, fontSize: 16)),
            SizedBox(height: 30),
            // Các tùy chọn
            buildProfileOption(Icons.edit, "Chỉnh sửa thông tin", () {}),
            buildProfileOption(Icons.lock, "Đổi mật khẩu", () {}),
            buildProfileOption(Icons.logout, "Đăng xuất", () {}),
          ],
        ),
      ),
    );
  }

  Widget buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
        onTap: onTap,
      ),
    );
  }
}
