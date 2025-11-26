import 'package:advance_mobile_calculator/providers/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculation History'),
        actions: [
          // nút xóa lịch sử
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear History',
            onPressed: () {
              // confirm
              _showClearConfirmationDialog(context);
            },
          )
        ],
      ),
      body: Consumer<HistoryProvider>(
        builder: (context, historyProvider, child) {
          if (historyProvider.history.isEmpty) {
            return const Center(
              child: Text(
                'No history yet.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          // hiển thị lịch sử trong ListView
          return ListView.builder(
            itemCount: historyProvider.history.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  historyProvider.history[index],
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 20),
                ),
                onTap: () {
                  // chưa có làm
                },
              );
            },
          );
        },
      ),
    );
  }

  // dialog xác nhận xóa
  void _showClearConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear History?'),
          content: const Text('Are you sure you want to delete all calculation history?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Clear', style: TextStyle(color: Colors.red)),
              onPressed: () {
                // gọi hàm clear từ provider
                context.read<HistoryProvider>().clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
