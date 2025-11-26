import 'package:advance_mobile_calculator/providers/calculator_provider.dart';
import 'package:advance_mobile_calculator/providers/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> with SingleTickerProviderStateMixin {
  double _fontSize = 64.0; // font size mặc định
  double _baseFontSize = 64.0; // biến tạm để lưu cỡ chữ khi bắt đầu zoom tránh lỗi

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _shakeAnimation = Tween<double>(begin: 0, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }
  
  // modal lịch sử custom
  void _showHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Consumer<HistoryProvider>(
        builder: (context, history, child) {
          if (history.history.isEmpty) {
            return const Center(child: Text("Không có lịch sử"));
          }
          return ListView.builder(
            itemCount: history.history.length,
            itemBuilder: (ctx, index) => ListTile(
              title: Text(history.history[index]),
              onTap: () {
                Navigator.pop(ctx);
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<CalculatorProvider>(
      builder: (context, calcProvider, child) {

        // tsrigger shake animation nếu có lỗi
        if (calcProvider.expression == 'Error' && !_shakeController.isAnimating) {
          _shakeController.forward(from: 0);
        }

        return GestureDetector(
          behavior: HitTestBehavior.translucent, // bắt sự kiện ngay cả nơi trống

          onScaleStart: (details) {
            _baseFontSize = _fontSize;
          },

          onScaleUpdate: (details) {
            // chỉ zoom khi scale thay đổi
            if (details.scale != 1.0) {
              setState(() {
                _fontSize = (_baseFontSize * details.scale).clamp(32.0, 96.0);
              });
            }
          },

          // xóa khi ngừi dùng vuốt phải
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              calcProvider.onButtonPressed('⌫');
            }
          },
          // mở modal khi vuốt lên
          onScaleEnd: (details) {
            // Lấy vận tốc vuốt
            double velocityX = details.velocity.pixelsPerSecond.dx;
            double velocityY = details.velocity.pixelsPerSecond.dy;

            // ngưỡng tốc độ để xác định là cú vuốt nhanh
            const double threshold = 500.0;

            // kiểm tra xem vuốt ngang hay dọc mạnh hơn
            if (velocityX.abs() > velocityY.abs()) {
              // vuốt Ngang
              if (velocityX > threshold) {
                // vuốt Phải xóa ký tự
                calcProvider.onButtonPressed('⌫');
              }
            } else {
              // vuốt Dọc
              if (velocityY < -threshold) {
                // vuốt Lên Mở Lịch sử
                _showHistory(context);
              }
            }
          },

          child: Container(
            color: Colors.transparent, // Để bắt sự kiện gesture
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: SingleChildScrollView(
              reverse: true,
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // phép tính cũ sao khi bấm bằng
                  Text(
                    calcProvider.history,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.secondary.withOpacity(0.7),
                      fontSize: 24,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),

                  AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_shakeAnimation.value, 0), // Lắc ngang
                        child: child,
                      );
                    },
                    // kết quả hoặc phép tính mới đang bấm
                    child: SizedBox(
                      width: double.infinity, // đảm bảo full width để canh phải
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: AnimatedOpacity( // fade-in effect cho kết quả
                          opacity: 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            calcProvider.expression.isEmpty ? '0' : calcProvider.expression,
                            style: theme.textTheme.displayMedium?.copyWith(
                              color: calcProvider.expression == 'Error' ? Colors.red : theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: _fontSize, // font size động
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}