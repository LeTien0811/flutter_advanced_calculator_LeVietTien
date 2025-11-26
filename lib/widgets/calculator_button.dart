import 'package:flutter/material.dart';

// nút hiển thị trong lưới button
class CustomCalculatorButton extends StatefulWidget {
  final String ValueButton;
  final Color ButtonColor;
  // sự kiện call back về lưới khi dc nhấn
  final VoidCallback onPressed;

  const CustomCalculatorButton({
    super.key,
    required this.ValueButton,
    required this.ButtonColor,
    required this.onPressed,
  });

  @override
  State<CustomCalculatorButton> createState() => _CustomCalculatorButtonState();
}

class _CustomCalculatorButtonState extends State<CustomCalculatorButton>
    with SingleTickerProviderStateMixin {
  // sự kiện animation phản hồi khi được nhấn vào 
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // khởi tạo animation ngay từ đầu
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 150),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, 0.05),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              minimumSize: Size.zero,
              fixedSize: Size(
                  MediaQuery.of(context).size.width / 4 - 20,
                  MediaQuery.of(context).size.width / 4 - 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              backgroundColor: widget.ButtonColor,
              foregroundColor: Colors.white,
              disabledBackgroundColor: widget.ButtonColor,
              disabledForegroundColor: Colors.white,
              padding: EdgeInsets.zero,
            ),
            child: Text(
              widget.ValueButton,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 19,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
