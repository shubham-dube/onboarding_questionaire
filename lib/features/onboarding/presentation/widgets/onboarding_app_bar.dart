import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class OnboardingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;
  final VoidCallback onClose;

  const OnboardingAppBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.base2,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + AppSpacing.md,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: AppSpacing.xxl,
      ),
      decoration: BoxDecoration(
        color: AppColors.base2,
        backgroundBlendMode: BlendMode.srcOver,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back,
                size: 20,
                color: AppColors.text1,
              ),
            ),
          ),

          // Progress indicator
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.huge),
              child: _AnimatedCurvedZigzagProgressIndicator(
                currentStep: currentStep,
                totalSteps: totalSteps,
              ),
            ),
          ),

          // Close button
          GestureDetector(
            onTap: onClose,
            child: Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              child: Icon(
                Icons.close,
                size: 20,
                color: AppColors.text1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _AnimatedCurvedZigzagProgressIndicator extends StatefulWidget {
  final int currentStep;
  final int totalSteps;

  const _AnimatedCurvedZigzagProgressIndicator({
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  State<_AnimatedCurvedZigzagProgressIndicator> createState() =>
      _AnimatedCurvedZigzagProgressIndicatorState();
}

class _AnimatedCurvedZigzagProgressIndicatorState
    extends State<_AnimatedCurvedZigzagProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _previousProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.currentStep / widget.totalSteps,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void didUpdateWidget(_AnimatedCurvedZigzagProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _previousProgress = oldWidget.currentStep / oldWidget.totalSteps;
      _animation = Tween<double>(
        begin: _previousProgress,
        end: widget.currentStep / widget.totalSteps,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ));

      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          height: AppSpacing.sm,
          child: CustomPaint(
            painter: _AnimatedCurvedZigzagPainter(
              progress: _animation.value,
              animationValue: _animationController.value,
              backgroundColor: AppColors.border2,
              progressColor: AppColors.primaryAccent,
            ),
            child: Container(),
          ),
        );
      },
    );
  }
}

class _AnimatedCurvedZigzagPainter extends CustomPainter {
  final double progress;
  final double animationValue;
  final Color backgroundColor;
  final Color progressColor;

  _AnimatedCurvedZigzagPainter({
    required this.progress,
    required this.animationValue,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background path (full width curved zigzag)
    final backgroundPath = _createCurvedZigzagPath(size, size.width);
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(backgroundPath, backgroundPaint);

    // Progress path (partial width curved zigzag)
    if (progress > 0) {
      final progressWidth = size.width * progress;
      final progressPath = _createCurvedZigzagPath(size, progressWidth);

      // Main progress color
      final progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      canvas.drawPath(progressPath, progressPaint);

      // Snake/glow effect at the leading edge
      if (animationValue > 0.1) {
        _drawSnakeEffect(canvas, size, progressWidth, progressPath);
      }
    }
  }

  void _drawSnakeEffect(Canvas canvas, Size size, double progressWidth, Path progressPath) {
    final metrics = progressPath.computeMetrics().first;
    final snakeLength = 30.0; // Length of the glowing snake effect

    // Create gradient shader for the snake effect
    final endPoint = metrics.getTangentForOffset(metrics.length)?.position ?? Offset(progressWidth, size.height / 2);
    final startPoint = metrics.getTangentForOffset((metrics.length - snakeLength).clamp(0.0, metrics.length))?.position ?? Offset(progressWidth - snakeLength, size.height / 2);

    // Draw multiple layers for glow effect
    for (int i = 3; i > 0; i--) {
      final glowPaint = Paint()
        ..color = progressColor.withOpacity(0.3 * (4 - i) / 3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0 + (i * 1.5)
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, i * 1.5);

      // Extract the tail portion of the path
      final extractPath = _extractPathSegment(progressPath, metrics.length - snakeLength, metrics.length);
      canvas.drawPath(extractPath, glowPaint);
    }

    // Brightest tip
    final tipPaint = Paint()
      ..color = progressColor.withOpacity(1.0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    final tipPath = _extractPathSegment(progressPath, (metrics.length - 10).clamp(0.0, metrics.length), metrics.length);
    canvas.drawPath(tipPath, tipPaint);
  }

  Path _extractPathSegment(Path originalPath, double start, double end) {
    final metrics = originalPath.computeMetrics().first;
    final extractedPath = Path();

    final startTangent = metrics.getTangentForOffset(start.clamp(0.0, metrics.length));
    if (startTangent != null) {
      extractedPath.moveTo(startTangent.position.dx, startTangent.position.dy);

      for (double i = start; i <= end && i <= metrics.length; i += 0.5) {
        final tangent = metrics.getTangentForOffset(i);
        if (tangent != null) {
          extractedPath.lineTo(tangent.position.dx, tangent.position.dy);
        }
      }
    }

    return extractedPath;
  }

  Path _createCurvedZigzagPath(Size size, double width) {
    final path = Path();
    final double waveLength = 16.0; // Length of each wave cycle
    final double amplitude = 2.5; // Height of the wave
    final double centerY = size.height / 2;

    path.moveTo(0, centerY);

    double x = 0;

    while (x < width) {
      final segmentWidth = waveLength / 2;
      final nextX = (x + segmentWidth).clamp(0.0, width);

      // Calculate control points for smooth curve
      final controlX1 = x + segmentWidth * 0.25;
      final controlX2 = x + segmentWidth * 0.75;

      // Alternate between up and down waves
      final waveDirection = ((x / segmentWidth) % 2 == 0) ? -1.0 : 1.0;
      final peakY = centerY + (amplitude * waveDirection);

      // Create smooth cubic bezier curve
      path.cubicTo(
        controlX1, peakY, // First control point
        controlX2, peakY, // Second control point
        nextX, centerY, // End point
      );

      x = nextX;

      if (x >= width) break;
    }

    return path;
  }

  @override
  bool shouldRepaint(_AnimatedCurvedZigzagPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor;
  }
}