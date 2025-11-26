import 'package:advance_mobile_calculator/providers/calculator_provider.dart';
import 'package:advance_mobile_calculator/screens/calculator_screen.dart';
import 'package:advance_mobile_calculator/widgets/button_grid.dart';
import 'package:advance_mobile_calculator/widgets/mode_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DisplayArea extends StatelessWidget {
  const DisplayArea({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<CalculatorProvider>().mode;

    // chi ti le man hinh và lưới nút theo mode
    final int displayFlex = (mode == CalculatorMode.basic) ? 2 : 1;
    final int gridFlex = (mode == CalculatorMode.basic) ? 3 : 4;

    // hien thị bo cuc lưới nut bam và màn hình tính toán
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ModeSelector(),
            Expanded(
              flex: displayFlex,
              child: const CalculatorScreen(),
            ),
            Expanded(
              flex: gridFlex,
              child: const CalculatorGridButton(),
            ),
          ],
        ),
      ),
    );
  }
}
