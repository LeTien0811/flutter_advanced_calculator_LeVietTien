import 'package:advance_mobile_calculator/providers/calculator_provider.dart';
import 'package:advance_mobile_calculator/providers/history_provider.dart';
import 'package:advance_mobile_calculator/providers/settings_provider.dart';
import 'package:advance_mobile_calculator/providers/theme_provider.dart';
import 'package:advance_mobile_calculator/widgets/display_area.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // khởi tạo các instance (Singleton)
  final themeProvider = await ThemeProvider.create();
  final settingsProvider = SettingsProvider();
  final historyProvider = HistoryProvider()..init();

  runApp(MultiProvider(
    providers: [
      // tạo provider độc lập
      ChangeNotifierProvider.value(value: themeProvider),
      ChangeNotifierProvider.value(value: settingsProvider),
      ChangeNotifierProvider.value(value: historyProvider),
      
      ChangeNotifierProvider(
        create: (context) => CalculatorProvider(
          settings: settingsProvider,
          historyProvider: historyProvider,
        ),
      ),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          // tắt cái banner và gọi cái theme được lưu
          debugShowCheckedModeBanner: false,
          theme: themeProvider.currentTheme,
          home: const DisplayArea(),
        );
      },
    );
  }
}
