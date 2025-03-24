import 'package:flutter/material.dart';
import 'package:movieticketbooking/Model/Province.dart';
import 'package:movieticketbooking/Services/province_service.dart';

class ProvinceListScreen extends StatefulWidget {
  @override
  _ProvinceListScreenState createState() => _ProvinceListScreenState();
}

class _ProvinceListScreenState extends State<ProvinceListScreen> {
  final ProvinceService _provinceService = ProvinceService();
  List<Province> provinces = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  void _loadProvinces() {
    _provinceService.getAllProvinces().listen((provinceList) {
      setState(() {
        provinces = provinceList;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chọn tỉnh",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xff252429),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      backgroundColor: const Color(0xff252429),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provinces.length + 1, // +1 cho "Tất cả tỉnh"
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Tùy chọn "Tất cả tỉnh"
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.orange.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      title: const Text(
                        "Tất cả tỉnh",
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.check_circle,
                        color: Colors.orange,
                        size: 24,
                      ),
                      onTap: () {
                        Navigator.pop(
                            context, null); // Trả về null để hiển thị tất cả
                      },
                    ),
                  );
                }

                // Danh sách tỉnh thành
                final province = provinces[index - 1];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    title: Text(
                      province.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.orange,
                      size: 20,
                    ),
                    onTap: () {
                      Navigator.pop(context, province);
                    },
                  ),
                );
              },
            ),
    );
  }
}
