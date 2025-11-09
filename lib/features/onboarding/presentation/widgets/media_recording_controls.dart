import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_borders.dart';

enum MediaType { audio, video }

class MediaRecordingControls extends StatelessWidget {
  final MediaType type;
  final Duration duration;
  final VoidCallback onStop;
  final VoidCallback onCancel;

  const MediaRecordingControls({
    Key? key,
    required this.type,
    required this.duration,
    required this.onStop,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppBorders.borderRadiusMD,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.only(
            left: 4,
            right: 20,
            top: 8,
            bottom: 8,
          ),
          decoration: BoxDecoration(
            gradient: const RadialGradient(
              center: Alignment(-1.0, -0.9),
              radius: 2.5,
              colors: [
                Color(0x33222222), // rgba(34, 34, 34, 0.2)
                Color(0x33999999), // rgba(153, 153, 153, 0.2)
                Color(0x33222222), // rgba(34, 34, 34, 0.2)
              ],
              stops: [0.0, 0.4987, 1.0],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 1,
            ),
            borderRadius: AppBorders.borderRadiusMD,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recording label
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  type == MediaType.audio ? 'Recording Audio...' : 'Recording Video...',
                  style: AppTextStyles.b1Regular,
                ),
              ),

              // Waveform and controls
              Row(
                children: [
                  // Check icon
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryAccent,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(
                        Icons.check,
                        color: AppColors.text1,
                        size: 16,
                      ),
                    ),
                  ),

                  // Waveform
                  if (type == MediaType.audio)
                    Expanded(
                      child: _WaveformVisualizer(),
                    ),

                  const SizedBox(width: 20),

                  // Duration
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

class _WaveformVisualizer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Waveform heights based on Figma
    final heights = [
      14.22, 18.36, 18.86, 20.97, 7.7, 19.73, 19.39, 14.91,
      12.05, 11.96, 21.74, 17.37, 16.75, 8.97, 8.24, 16.52,
      8.81, 21.95, 20.56, 12.19, 16.29, 19.83, 16.02, 16.42
    ];

    return SizedBox(
      height: 28,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: heights.map((height) {
          return Container(
            width: 4,
            height: height,
            decoration: BoxDecoration(
              color: AppColors.text1,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class MediaPreview extends StatelessWidget {
  final MediaType type;
  final Duration duration;
  final VoidCallback onDelete;

  const MediaPreview({
    Key? key,
    required this.type,
    required this.duration,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: type == MediaType.audio
            ? AppColors.surfaceWhite2
            : AppColors.surfaceBlack2,
        borderRadius: AppBorders.borderRadiusMD,
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Media icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryAccent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              type == MediaType.audio ? Icons.mic : Icons.videocam,
              color: AppColors.text1,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          // Type label and duration
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type == MediaType.audio ? 'Audio Recording' : 'Video Recording',
                  style: AppTextStyles.b2Bold,
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDuration(duration),
                  style: AppTextStyles.s1Regular.copyWith(
                    color: AppColors.text3,
                  ),
                ),
              ],
            ),
          ),

          // Delete button
          IconButton(
            onPressed: onDelete,
            icon: Icon(Icons.delete_outline, color: AppColors.negative),
            iconSize: 24,
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}