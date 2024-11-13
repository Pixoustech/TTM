import 'package:flutter/material.dart';

class PulsingDot extends StatefulWidget {
  @override
  _PulsingDotState createState() => _PulsingDotState();
}

class _PulsingDotState extends State<PulsingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Center(
          child: Container(
            width: 20 + _controller.value * 20, // Increase size with animation
            height: 20 + _controller.value * 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red.withOpacity(1 - _controller.value), // Pulsing effect with opacity
            ),
          ),
        );
      },
    );
  }
}
