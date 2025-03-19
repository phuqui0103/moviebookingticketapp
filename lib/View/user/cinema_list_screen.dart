import 'package:flutter/material.dart';
import 'package:movieticketbooking/Components/bottom_nav_bar.dart';
import 'package:movieticketbooking/Model/Cinema.dart';
import 'package:movieticketbooking/Model/Province.dart';
import 'package:movieticketbooking/Data/data.dart';
import 'cinema_booking_screen.dart';

class CinemaListScreen extends StatefulWidget {
  @override
  _CinemaListScreenState createState() => _CinemaListScreenState();
}

class _CinemaListScreenState extends State<CinemaListScreen> {
  String? selectedProvinceId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chọn rạp",
            style: TextStyle(
                color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BottomNavBar()));
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: provinces.length,
        itemBuilder: (context, index) {
          final province = provinces[index];
          final isExpanded = selectedProvinceId == province.id;
          final provinceCinemas = cinemas
              .where((cinema) => cinema.provinceId == province.id)
              .toList();

          return Card(
            color: Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.orangeAccent, width: 1),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(province.name,
                      style: TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  trailing: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.orangeAccent,
                  ),
                  onTap: () {
                    setState(() {
                      selectedProvinceId = isExpanded ? null : province.id;
                    });
                  },
                ),
                if (isExpanded)
                  Column(
                    children: provinceCinemas.map((cinema) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 4.0),
                        child: Card(
                          color: Colors.black54,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                                color: Colors.orangeAccent, width: 1),
                          ),
                          child: ListTile(
                            title: Text(cinema.name,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                            subtitle: Text(cinema.address,
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 14)),
                            leading: Icon(Icons.local_movies,
                                color: Colors.orangeAccent),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CinemaBookingScreen(cinema: cinema),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
