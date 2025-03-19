import 'package:flutter/material.dart';

class SidebarMenu extends StatefulWidget {
  final Function(int) onMenuSelected;
  final int selectedIndex;

  const SidebarMenu({
    Key? key,
    required this.onMenuSelected,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  _SidebarMenuState createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const Divider(color: Colors.white24, thickness: 1),
            _buildMenuItem(Icons.movie_creation_rounded, "Quản lý phim", 0),
            _buildMenuItem(Icons.schedule_rounded, "Quản lý suất chiếu", 1),
            _buildMenuItem(
                Icons.confirmation_number_rounded, "Quản lý đặt vé", 2),
            _buildMenuItem(Icons.bar_chart_rounded, "Thống kê doanh thu", 3),
            _buildMenuItem(Icons.people_alt_rounded, "Quản lý người dùng", 4),
            const Spacer(),
            const Divider(color: Colors.white24, thickness: 1),
            _buildLogoutButton(),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  /// Header với Avatar + Thông tin Admin
  Widget _buildHeader() {
    return Container(
      height: 120,
      decoration: const BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(30)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildAvatar(),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Admin Panel",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "admin@cinema.com",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Avatar với hiệu ứng đổ bóng
  Widget _buildAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black45.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: const CircleAvatar(
        radius: 35,
        backgroundColor: Colors.white,
        child: Icon(Icons.person, color: Colors.orangeAccent, size: 40),
      ),
    );
  }

  /// Mục menu có hiệu ứng hover + animation
  Widget _buildMenuItem(IconData icon, String title, int index) {
    bool isSelected = widget.selectedIndex == index;

    return InkWell(
      onTap: () => widget.onMenuSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.orangeAccent.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.orangeAccent : Colors.transparent,
            width: isSelected ? 1.5 : 0,
          ),
        ),
        child: ListTile(
          leading: Icon(icon,
              color: isSelected ? Colors.orangeAccent : Colors.white70,
              size: 26),
          title: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.orangeAccent : Colors.white70,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
          trailing: isSelected
              ? const Icon(Icons.chevron_right, color: Colors.orangeAccent)
              : null,
        ),
      ),
    );
  }

  /// Nút đăng xuất đẹp hơn + Hiệu ứng hover
  Widget _buildLogoutButton() {
    return InkWell(
      onTap: () {
        // Xử lý đăng xuất
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.redAccent, width: 1),
        ),
        child: Row(
          children: const [
            Icon(Icons.exit_to_app_rounded, color: Colors.redAccent, size: 26),
            SizedBox(width: 10),
            Text(
              "Đăng xuất",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
