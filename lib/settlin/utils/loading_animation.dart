import 'package:flutter/material.dart';

class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({super.key});

  @override
  _LoadingAnimationState createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DotPainter(animation: _controller),
      child: const SizedBox(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class DotPainter extends CustomPainter {
  final Animation<double> animation;

  DotPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    const double dotSize = 6.0;
    const double separation = 60.0;
    const double totalWidth = 3 * dotSize + 2 * separation;

    for (int i = 0; i < 3; i++) {
      final double relativePosition = i * (dotSize + separation);
      final double alpha =
          ((animation.value * totalWidth) - relativePosition).clamp(0.0, 1.0);

      final Paint dotPaint = Paint()
        ..color = Color.lerp(Colors.white, Colors.orange, alpha)!;

      canvas.drawCircle(
        Offset(relativePosition, size.height / 2),
        dotSize,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
