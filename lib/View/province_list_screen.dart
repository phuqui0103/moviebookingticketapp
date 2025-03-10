import 'package:flutter/material.dart';
import 'package:movieticketbooking/Model/Province.dart';
import 'package:movieticketbooking/Data/data.dart';

class ProvinceListScreen extends StatefulWidget {
  @override
  _ProvinceListScreenState createState() => _ProvinceListScreenState();
}

class _ProvinceListScreenState extends State<ProvinceListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chọn tỉnh",
            style: TextStyle(
                color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: provinces.length,
        itemBuilder: (context, index) {
          final province = provinces[index];
          return Card(
            color: Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.orangeAccent, width: 1),
            ),
            child: ListTile(
              title: Text(province.name,
                  style: TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              trailing:
                  Icon(Icons.arrow_forward_ios, color: Colors.orangeAccent),
              onTap: () {
                Navigator.pop(context, province.id);
              },
            ),
          );
        },
      ),
    );
  }
}
