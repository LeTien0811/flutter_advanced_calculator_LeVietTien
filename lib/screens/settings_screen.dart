import 'package:advance_mobile_calculator/providers/history_provider.dart';
import 'package:advance_mobile_calculator/providers/settings_provider.dart';
import 'package:advance_mobile_calculator/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final historyProvider = context.read<HistoryProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt')),
      body: ListView(
        children: [
          // lựa chọn theme
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Giao diện'),
            trailing: DropdownButton<ThemeMode>(
              value: themeProvider.themeMode,
              onChanged: (ThemeMode? newValue) {
                if (newValue != null) themeProvider.setTheme(newValue);
              },
              items: const [
                DropdownMenuItem(value: ThemeMode.light, child: Text('Sáng')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Tối')),
                DropdownMenuItem(value: ThemeMode.system, child: Text('Hệ thống')),
              ],
            ),
          ),
          const Divider(),

          // lựa chọn độ chính xác số thập phân là cái thanh kéo
          ListTile(
            leading: const Icon(Icons.exposure_zero),
            title: const Text('Độ chính xác thập phân'),
            subtitle: Text('${settings.decimalPrecision} chữ số'),
            trailing: SizedBox(
              width: 150,
              child: Slider(
                value: settings.decimalPrecision.toDouble(),
                min: 0,
                max: 10,
                divisions: 10,
                label: settings.decimalPrecision.toString(),
                onChanged: (val) => settings.setPrecision(val.toInt()),
              ),
            ),
          ),
          const Divider(),

          // chế đọ angle mode cho scientific
          SwitchListTile(
            secondary: const Icon(Icons.change_history),
            title: const Text('Chế độ Góc (Radians)'),
            subtitle: Text(settings.angleMode == AngleMode.radians ? 'Đang dùng Radians' : 'Đang dùng Degrees'),
            value: settings.angleMode == AngleMode.radians,
            onChanged: (val) {
              settings.setAngleMode(val ? AngleMode.radians : AngleMode.degrees);
            },
          ),
          const Divider(),

          // lựa chọn rung khi nhấn chưa có làm
          SwitchListTile(
            secondary: const Icon(Icons.vibration),
            title: const Text('Rung khi nhấn'),
            value: settings.hapticFeedback,
            onChanged: (val) => settings.setHaptic(val),
          ),

          // lặ chọn âm thanh khi nhấn chưa có làm
          SwitchListTile(
            secondary: const Icon(Icons.volume_up),
            title: const Text('Âm thanh khi nhấn'),
            value: settings.soundEffects,
            onChanged: (val) => settings.setSound(val),
          ),
          const Divider(),

          // chọn kích thước lưu trữ cho lịch sử
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Kích thước lịch sử'),
            trailing: DropdownButton<int>(
              value: settings.historySize,
              onChanged: (val) {
                if (val != null) {
                  settings.setHistorySize(val);
                  historyProvider.resizeHistory(val);
                }
              },
              items: const [
                DropdownMenuItem(value: 25, child: Text('25 mục')),
                DropdownMenuItem(value: 50, child: Text('50 mục')),
                DropdownMenuItem(value: 100, child: Text('100 mục')),
              ],
            ),
          ),

          // xóa lịch sử
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Xóa toàn bộ lịch sử', style: TextStyle(color: Colors.red)),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Xác nhận'),
                  content: const Text('Bạn có chắc muốn xóa toàn bộ lịch sử?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
                    TextButton(
                      onPressed: () {
                        historyProvider.clear();
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đã xóa lịch sử')),
                        );
                      },
                      child: const Text('Xóa', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}