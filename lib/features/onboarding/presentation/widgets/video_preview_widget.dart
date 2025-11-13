import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/services/full_screen_video_player.dart';

class VideoPreviewWidget extends StatefulWidget {
  final String videoPath;
  final Duration duration;
  final VoidCallback onDelete;

  const VideoPreviewWidget({
    super.key,
    required this.videoPath,
    required this.duration,
    required this.onDelete,
  });

  @override
  State<VideoPreviewWidget> createState() => _VideoPreviewWidgetState();
}

class _VideoPreviewWidgetState extends State<VideoPreviewWidget> {
  String? _thumbnailPath;
  bool _isLoadingThumbnail = true;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    try {
      final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: widget.videoPath,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG,
        maxHeight: 200,
        quality: 75,
      );

      if (mounted) {
        setState(() {
          _thumbnailPath = thumbnailPath;
          _isLoadingThumbnail = false;
        });
      }
    } catch (e) {
      print('Error generating thumbnail: $e');
      if (mounted) {
        setState(() {
          _isLoadingThumbnail = false;
        });
      }
    }
  }

  void _playVideo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPlayer(
          videoPath: widget.videoPath,
          totalDuration: widget.duration,
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 64,
          padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Thumbnail with play button overlay
              Stack(
                children: [
                  // Thumbnail container
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceBlack2,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _isLoadingThumbnail
                        ? const Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: AppColors.primaryAccent,
                          strokeWidth: 1.5,
                        ),
                      ),
                    )
                        : _thumbnailPath != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(_thumbnailPath!),
                        fit: BoxFit.cover,
                        width: 48,
                        height: 48,
                      ),
                    )
                        : const Center(
                      child: Icon(
                        Icons.videocam,
                        color: AppColors.text3,
                        size: 24,
                      ),
                    ),
                  ),

                  // Play button overlay
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _playVideo,
                        borderRadius: BorderRadius.circular(8),
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(26.67),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 26.67, sigmaY: 26.67),
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
                                    width: 1.11,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 13.33,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 12),

              // Video info and delete button
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Video text
                    Expanded(
                      child: Text(
                        'Video Recorded • ${_formatDuration(widget.duration)}',
                        style: const TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          height: 1.25,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Delete button
                    InkWell(
                      onTap: () {
                        _showDeleteConfirmation(context);
                      },
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Icon(
                          Icons.delete_outline,
                          color: AppColors.negative,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.base2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Delete Video?',
          style: AppTextStyles.h3Bold.copyWith(
            color: AppColors.text1,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this video recording?',
          style: AppTextStyles.b1Regular.copyWith(
            color: AppColors.text3,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.b1Bold.copyWith(
                color: AppColors.text3,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete();
            },
            child: Text(
              'Delete',
              style: AppTextStyles.b1Bold.copyWith(
                color: AppColors.negative,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up thumbnail file
    if (_thumbnailPath != null) {
      try {
        File(_thumbnailPath!).delete();
      } catch (e) {
        print('Error deleting thumbnail: $e');
      }
    }
    super.dispose();
  }
}