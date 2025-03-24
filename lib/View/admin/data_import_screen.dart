import 'package:flutter/material.dart';
import '../../Utils/data_import_util.dart';

class DataImportScreen extends StatelessWidget {
  const DataImportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Dữ Liệu'),
        backgroundColor: const Color(0xff252429),
      ),
      backgroundColor: const Color(0xff252429),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Import dữ liệu mẫu vào Firebase',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => DataImportUtil.importAllData(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  'Import Dữ Liệu',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Lưu ý: Hành động này sẽ thêm dữ liệu mẫu về tỉnh/thành phố, rạp phim và phòng chiếu vào Firebase. Dữ liệu đã có sẽ được ghi đè.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
