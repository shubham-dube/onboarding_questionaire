import 'package:flutter/material.dart';

class BackgroundImageWidget extends StatelessWidget {
  final String imagePath;
  final double opacity;
  final Widget child;

  const BackgroundImageWidget({
    super.key,
    required this.imagePath,
    this.opacity = 0.2,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Opacity(
            opacity: opacity,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Content
        child,
      ],
    );
  }
}