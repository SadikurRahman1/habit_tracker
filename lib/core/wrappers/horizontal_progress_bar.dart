import 'package:flutter/material.dart';

class HorizontalProgressBar extends StatelessWidget {
  final double progress; // 0.0 থেকে 1.0
  final double height;
  final Color backgroundColor;
  final Color progressColor;

  const HorizontalProgressBar({
    super.key,
    required this.progress,
    this.height = 8,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.progressColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: LinearProgressIndicator(
        value: progress.clamp(0.0, 1.0),
        minHeight: height,
        backgroundColor: backgroundColor,
        color: progressColor,
      ),
    );
  }
}
