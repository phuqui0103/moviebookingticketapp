import 'package:flutter/material.dart';
import '../../Utils/data_import_util.dart';

class DataImportScreen extends StatefulWidget {
  const DataImportScreen({Key? key}) : super(key: key);

  @override
  _DataImportScreenState createState() => _DataImportScreenState();
}

class _DataImportScreenState extends State<DataImportScreen> {
  bool isLoading = false;
  String statusMessage = '';

  Future<void> _importFoodData() async {
    setState(() {
      isLoading = true;
      statusMessage = 'Đang import dữ liệu đồ ăn...';
    });

    try {
      await DataImportUtil.importFoodData();
      setState(() {
        statusMessage = 'Import dữ liệu đồ ăn thành công!';
      });
    } catch (e) {
      setState(() {
        statusMessage = 'Lỗi khi import dữ liệu đồ ăn: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteAllFoodData() async {
    setState(() {
      isLoading = true;
      statusMessage = 'Đang xóa dữ liệu đồ ăn...';
    });

    try {
      await DataImportUtil.deleteAllFoodData();
      setState(() {
        statusMessage = 'Xóa dữ liệu đồ ăn thành công!';
      });
    } catch (e) {
      setState(() {
        statusMessage = 'Lỗi khi xóa dữ liệu đồ ăn: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _importAllData() async {
    setState(() {
      isLoading = true;
      statusMessage = 'Đang import tất cả dữ liệu...';
    });

    try {
      await DataImportUtil.importAllData(context);
      setState(() {
        statusMessage = 'Import tất cả dữ liệu thành công!';
      });
    } catch (e) {
      setState(() {
        statusMessage = 'Lỗi khi import dữ liệu: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Dữ Liệu'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dữ Liệu Đồ Ăn',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: isLoading ? null : _importFoodData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: const Text('Import Đồ Ăn'),
                        ),
                        ElevatedButton(
                          onPressed: isLoading ? null : _deleteAllFoodData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: const Text('Xóa Tất Cả'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dữ Liệu Khác',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: isLoading ? null : _importAllData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Import Tất Cả'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (statusMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: statusMessage.contains('Lỗi')
                      ? Colors.red.withOpacity(0.1)
                      : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusMessage,
                  style: TextStyle(
                    color: statusMessage.contains('Lỗi')
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
