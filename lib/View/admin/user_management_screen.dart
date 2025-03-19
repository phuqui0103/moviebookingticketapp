import 'package:flutter/material.dart';
import '../../Model/User.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<User> users = [];
  List<User> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    users = [
      User(
        id: "1",
        fullName: "Nguyễn Văn A",
        phoneNumber: "0987654321",
        email: "nguyenvana@gmail.com",
        hashedPassword: "123456",
        birthDate: DateTime(2000, 5, 20),
        gender: "Nam",
        province: "Hà Nội",
        district: "Cầu Giấy",
        status: "Active",
        createdAt: DateTime.now(),
      ),
      User(
        id: "2",
        fullName: "Trần Thị B",
        phoneNumber: "0912345678",
        email: "tranthib@gmail.com",
        hashedPassword: "abcdef",
        birthDate: DateTime(1995, 8, 10),
        gender: "Nữ",
        province: "TP HCM",
        district: "Quận 1",
        status: "Blocked",
        createdAt: DateTime.now(),
      ),
    ];

    filteredUsers = List.from(users);
  }

  void _searchUser(String query) {
    setState(() {
      filteredUsers = users
          .where((user) =>
              user.fullName.toLowerCase().contains(query.toLowerCase()) ||
              user.email.toLowerCase().contains(query.toLowerCase()) ||
              user.phoneNumber.contains(query))
          .toList();
    });
  }

  void _deleteUser(String userId) {
    setState(() {
      users.removeWhere((user) => user.id == userId);
      filteredUsers = List.from(users);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Người dùng đã được xóa")),
    );
  }

  void _editUser(User user) {
    TextEditingController nameController =
        TextEditingController(text: user.fullName);
    TextEditingController phoneController =
        TextEditingController(text: user.phoneNumber);
    String status = user.status;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Chỉnh sửa người dùng",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Họ và Tên",
                      labelStyle: TextStyle(color: Colors.orange),
                      filled: true,
                      fillColor: Colors.grey[900],
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Số điện thoại",
                      labelStyle: TextStyle(color: Colors.orange),
                      filled: true,
                      fillColor: Colors.grey[900],
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: status,
                    dropdownColor: Colors.black,
                    items: ["Active", "Blocked"]
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(s,
                                  style: TextStyle(color: Colors.white)),
                            ))
                        .toList(),
                    onChanged: (value) {
                      status = value!;
                    },
                    decoration: InputDecoration(
                      labelText: "Trạng thái",
                      labelStyle: TextStyle(color: Colors.orange),
                      filled: true,
                      fillColor: Colors.grey[900],
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          user.fullName = nameController.text;
                          user.phoneNumber = phoneController.text;
                          user.status = status;
                        });
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.orange, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "Lưu",
                        style: TextStyle(color: Colors.orange, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Tìm kiếm theo tên, email, số điện thoại...",
                hintStyle: const TextStyle(color: Colors.white60),
                prefixIcon: const Icon(Icons.search, color: Colors.orange),
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.orange),
                ),
              ),
              onChanged: _searchUser,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                User user = filteredUsers[index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange, width: 2),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(left: 15),
                    title: Text(user.fullName,
                        style: const TextStyle(color: Colors.white)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.email,
                            style: const TextStyle(color: Colors.white70)),
                        Text(user.phoneNumber,
                            style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => _editUser(user),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteUser(user.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
