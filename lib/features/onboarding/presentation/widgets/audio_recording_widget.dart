import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_borders.dart';

class AudioRecordingWidget extends StatelessWidget {
  final Duration duration;
  final List<double> waveformData;
  final VoidCallback onStop;
  final VoidCallback onCancel;

  const AudioRecordingWidget({
    super.key,
    required this.duration,
    required this.waveformData,
    required this.onStop,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppBorders.borderRadiusMD,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.only(left: 4, right: 20, top: 8, bottom: 8),
          decoration: BoxDecoration(
            gradient: const RadialGradient(
              center: Alignment(-1.0, -0.9),
              radius: 2.5,
              colors: [
                Color(0x33222222),
                Color(0x33999999),
                Color(0x33222222),
              ],
              stops: [0.0, 0.4987, 1.0],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
            borderRadius: AppBorders.borderRadiusMD,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recording label
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text('Recording Audio...', style: AppTextStyles.b1Regular),
              ),

              Row(
                children: [
                  GestureDetector(
                    onTap: onStop,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _PulsingCheckIcon(),
                    ),
                  ),

                  Flexible(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 200, // Limit waveform width
                      ),
                      child: _RealTimeWaveform(waveformData: waveformData),
                    ),
                  ),

                  const SizedBox(width: 20),

                  Text(
                    _formatDuration(duration),
                    style: AppTextStyles.b1Regular.copyWith(
                      color: AppColors.primaryAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _PulsingCheckIcon extends StatefulWidget {
  @override
  State<_PulsingCheckIcon> createState() => _PulsingCheckIconState();
}

class _PulsingCheckIconState extends State<_PulsingCheckIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.secondaryAccent,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondaryAccent.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(Icons.check, color: AppColors.text1, size: 16),
          ),
        );
      },
    );
  }
}

class _RealTimeWaveform extends StatelessWidget {
  final List<double> waveformData;

  const _RealTimeWaveform({required this.waveformData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: CustomPaint(
        painter: _WaveformPainter(waveformData),
        child: Container(),
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final List<double> waveformData;

  _WaveformPainter(this.waveformData);

  @override
  void paint(Canvas canvas, Size size) {
    if (waveformData.isEmpty) return;

    final paint = Paint()
      ..color = AppColors.text1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final barWidth = 4.0;
    final spacing = 4.0;

    final maxBars = (size.width / (barWidth + spacing)).floor();
    final barsToShow = waveformData.length > maxBars
        ? waveformData.sublist(waveformData.length - maxBars)
        : waveformData;

    final totalWidth = (barWidth + spacing) * barsToShow.length;
    final startX = size.width - totalWidth;

    for (int i = 0; i < barsToShow.length; i++) {
      final amplitude = barsToShow[i];
      final height = (size.height * amplitude).clamp(4.0, size.height);
      final x = startX + (i * (barWidth + spacing));
      final y = (size.height - height) / 2;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, height),
        const Radius.circular(2),
      );

      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter oldDelegate) =>
      oldDelegate.waveformData != waveformData;
}