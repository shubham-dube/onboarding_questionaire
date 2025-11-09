import 'package:flutter/material.dart';

import '../../../../core/theme/app_borders.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/services/audio_playback_service.dart';

class AudioPreviewWidget extends StatelessWidget {
  final Duration duration;
  final Duration currentPosition;
  final PlaybackState playbackState;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final ValueChanged<Duration> onSeek;
  final VoidCallback onDelete;

  const AudioPreviewWidget({
    Key? key,
    required this.duration,
    required this.currentPosition,
    required this.playbackState,
    required this.onPlay,
    required this.onPause,
    required this.onSeek,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPlaying = playbackState == PlaybackState.playing;
    final isLoading = playbackState == PlaybackState.loading;
    final isCompleted = playbackState == PlaybackState.completed;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite2,
        borderRadius: AppBorders.borderRadiusMD,
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Play/Pause button with loading state
              GestureDetector(
                onTap: isLoading
                    ? null
                    : (isPlaying ? onPause : onPlay),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isLoading
                        ? AppColors.primaryAccent.withOpacity(0.5)
                        : AppColors.primaryAccent,
                    shape: BoxShape.circle,
                  ),
                  child: isLoading
                      ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.text1),
                    ),
                  )
                      : Icon(
                    isPlaying
                        ? Icons.pause
                        : (isCompleted ? Icons.replay : Icons.play_arrow),
                    color: AppColors.text1,
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Title and duration
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Audio Recording', style: AppTextStyles.b2Bold),
                    const SizedBox(height: 2),
                    Text(
                      _formatDuration(duration),
                      style: AppTextStyles.s1Regular.copyWith(color: AppColors.text3),
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

          const SizedBox(height: 12),

          // Progress bar
          _AudioProgressBar(
            duration: duration,
            position: currentPosition,
            onSeek: onSeek,
            isEnabled: !isLoading,
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

class _AudioProgressBar extends StatelessWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration> onSeek;
  final bool isEnabled;

  const _AudioProgressBar({
    required this.duration,
    required this.position,
    required this.onSeek,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final safeDuration = duration.inMilliseconds > 0
        ? duration
        : const Duration(milliseconds: 1);

    final safePosition = Duration(
      milliseconds: position.inMilliseconds.clamp(0, safeDuration.inMilliseconds),
    );

    final sliderValue = safePosition.inMilliseconds.toDouble();
    final sliderMax = safeDuration.inMilliseconds.toDouble();

    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
            activeTrackColor: isEnabled
                ? AppColors.primaryAccent
                : AppColors.primaryAccent.withOpacity(0.5),
            inactiveTrackColor: AppColors.border2,
            thumbColor: isEnabled
                ? AppColors.primaryAccent
                : AppColors.primaryAccent.withOpacity(0.5),
            overlayColor: AppColors.primaryAccent.withOpacity(0.2),
            disabledActiveTrackColor: AppColors.border2,
            disabledInactiveTrackColor: AppColors.border2,
            disabledThumbColor: AppColors.border2,
          ),
          child: Slider(
            value: sliderValue,
            min: 0.0,
            max: sliderMax,
            onChanged: isEnabled
                ? (value) {
              if (safeDuration.inMilliseconds > 0) {
                onSeek(Duration(milliseconds: value.toInt()));
              }
            }
                : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(safePosition),
                style: AppTextStyles.s1Regular.copyWith(
                  color: isEnabled ? AppColors.text3 : AppColors.text5,
                ),
              ),
              Text(
                _formatDuration(safeDuration),
                style: AppTextStyles.s1Regular.copyWith(
                  color: isEnabled ? AppColors.text3 : AppColors.text5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}