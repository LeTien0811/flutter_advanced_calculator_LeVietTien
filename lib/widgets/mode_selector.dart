import 'package:advance_mobile_calculator/providers/calculator_provider.dart';
import 'package:advance_mobile_calculator/providers/theme_provider.dart';
import 'package:advance_mobile_calculator/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum CalculatorMode { basic, scientific, programmer }

class ModeSelector extends StatelessWidget {
  const ModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final calcProvider = context.watch<CalculatorProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    
    // danh sách chế độ và chức năng nằm trên màn hình
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         
          Expanded(
            // chèn chế độ vào scroll view tránh chèn lỗi hiển thị
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildModeButton(context, 'Basic', CalculatorMode.basic, calcProvider),
                  _buildModeButton(context, 'Scientific', CalculatorMode.scientific, calcProvider),
                  _buildModeButton(context, 'Programmer', CalculatorMode.programmer, calcProvider),
                ],
              ),
            ),
          ),

          // Nhóm nút action cài đặt và chuyern theme
          Row(
            children: [
              IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round_outlined,
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  // custom cái nút chuyển chế độ
  Widget _buildModeButton(BuildContext context, String title, CalculatorMode mode, CalculatorProvider provider) {
    final bool isSelected = provider.mode == mode;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: TextButton(
        onPressed: () => provider.toggleMode(mode),
        style: TextButton.styleFrom(
          backgroundColor: isSelected ? theme.colorScheme.secondary.withOpacity(0.3) : Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.secondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
