import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  final String videoPath;
  final Duration totalDuration;

  const FullScreenVideoPlayer({
    Key? key,
    required this.videoPath,
    required this.totalDuration,
  }) : super(key: key);

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showControls = true;
  Timer? _hideControlsTimer;
  Duration _currentPosition = Duration.zero;
  bool _isDragging = false;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.file(File(widget.videoPath));

    try {
      await _controller.initialize();

      _controller.addListener(() {
        if (!_isDragging && mounted) {
          setState(() {
            _currentPosition = _controller.value.position;
            _isPlaying = _controller.value.isPlaying;
          });
        }

        // Auto-pause at end
        if (_controller.value.position >= _controller.value.duration) {
          _controller.pause();
          _controller.seekTo(Duration.zero);
        }
      });

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        _startHideControlsTimer();
      }
    } catch (e) {
      _showError('Failed to load video: $e');
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
        _startHideControlsTimer();
      }
    });
  }

  void _seekForward() {
    final newPosition = _currentPosition + const Duration(seconds: 10);
    _controller.seekTo(
      newPosition > _controller.value.duration
          ? _controller.value.duration
          : newPosition,
    );
  }

  void _seekBackward() {
    final newPosition = _currentPosition - const Duration(seconds: 10);
    _controller.seekTo(
      newPosition < Duration.zero ? Duration.zero : newPosition,
    );
  }

  void _changePlaybackSpeed() {
    setState(() {
      if (_playbackSpeed == 1.0) {
        _playbackSpeed = 1.5;
      } else if (_playbackSpeed == 1.5) {
        _playbackSpeed = 2.0;
      } else if (_playbackSpeed == 2.0) {
        _playbackSpeed = 0.5;
      } else {
        _playbackSpeed = 1.0;
      }
      _controller.setPlaybackSpeed(_playbackSpeed);
    });
    _resetHideControlsTimer();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startHideControlsTimer();
    } else {
      _hideControlsTimer?.cancel();
    }
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _controller.value.isPlaying) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _resetHideControlsTimer() {
    setState(() {
      _showControls = true;
    });
    _startHideControlsTimer();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.negative,
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video player
          Center(
            child: _isInitialized
                ? GestureDetector(
              onTap: _toggleControls,
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            )
                : const CircularProgressIndicator(
              color: AppColors.primaryAccent,
            ),
          ),

          // Controls overlay
          if (_showControls)
            GestureDetector(
              onTap: _toggleControls,
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Top bar
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Back button
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Spacer(),
                            // Playback speed button
                            GestureDetector(
                              onTap: _changePlaybackSpeed,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  '${_playbackSpeed}x',
                                  style: AppTextStyles.b2Bold.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Center controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Seek backward
                          _ControlButton(
                            icon: Icons.replay_10,
                            onPressed: _seekBackward,
                          ),
                          const SizedBox(width: 32),
                          // Play/Pause
                          _ControlButton(
                            icon: _isPlaying ? Icons.pause : Icons.play_arrow,
                            onPressed: _togglePlayPause,
                            size: 64,
                            iconSize: 40,
                          ),
                          const SizedBox(width: 32),
                          // Seek forward
                          _ControlButton(
                            icon: Icons.forward_10,
                            onPressed: _seekForward,
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Bottom controls
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Progress bar
                            Row(
                              children: [
                                Text(
                                  _formatDuration(_currentPosition),
                                  style: AppTextStyles.s1Regular.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: SliderTheme(
                                    data: SliderThemeData(
                                      trackHeight: 4,
                                      thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 8,
                                      ),
                                      overlayShape: const RoundSliderOverlayShape(
                                        overlayRadius: 16,
                                      ),
                                      activeTrackColor: AppColors.primaryAccent,
                                      inactiveTrackColor: Colors.white.withOpacity(0.3),
                                      thumbColor: AppColors.primaryAccent,
                                      overlayColor: AppColors.primaryAccent.withOpacity(0.3),
                                    ),
                                    child: Slider(
                                      value: _currentPosition.inMilliseconds.toDouble(),
                                      min: 0,
                                      max: _controller.value.duration.inMilliseconds.toDouble(),
                                      onChanged: (value) {
                                        setState(() {
                                          _isDragging = true;
                                          _currentPosition = Duration(
                                            milliseconds: value.toInt(),
                                          );
                                        });
                                      },
                                      onChangeEnd: (value) {
                                        _controller.seekTo(
                                          Duration(milliseconds: value.toInt()),
                                        );
                                        setState(() {
                                          _isDragging = false;
                                        });
                                        _resetHideControlsTimer();
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _formatDuration(_controller.value.duration),
                                  style: AppTextStyles.s1Regular.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Loading indicator
          if (!_isInitialized)
            const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryAccent,
              ),
            ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final double iconSize;

  const _ControlButton({
    required this.icon,
    required this.onPressed,
    this.size = 48,
    this.iconSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: iconSize,
        ),
      ),
    );
  }
}