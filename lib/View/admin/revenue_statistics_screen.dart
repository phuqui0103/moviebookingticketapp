import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RevenueStatisticsScreen extends StatefulWidget {
  const RevenueStatisticsScreen({Key? key}) : super(key: key);

  @override
  _RevenueStatisticsScreenState createState() =>
      _RevenueStatisticsScreenState();
}

class _RevenueStatisticsScreenState extends State<RevenueStatisticsScreen> {
  String selectedFilter = "Tháng"; // Mặc định lọc theo tháng
  double totalRevenue = 15000000; // Giả lập doanh thu
  int totalTickets = 230; // Giả lập số vé bán ra

  // Dữ liệu giả lập cho biểu đồ cột
  List<BarChartGroupData> revenueData = List.generate(
    7,
    (index) => BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          toY: (index + 1) * 2.5, // Doanh thu giả lập
          color: Colors.orange,
          width: 16,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Bộ lọc
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: selectedFilter,
                  dropdownColor: Colors.black,
                  style: const TextStyle(color: Colors.orange),
                  items: ["Ngày", "Tuần", "Tháng"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFilter = value!;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {},
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text("Xuất Excel"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Thống kê tổng quan
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Tổng Doanh Thu",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      Text("$totalRevenue VNĐ",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text("Số Vé Đã Bán",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      Text("$totalTickets vé",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Biểu đồ doanh thu (Bar Chart)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: BarChart(
                  BarChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: true)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              "Ngày ${value.toInt()}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            );
                          },
                          reservedSize: 22,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: revenueData,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
