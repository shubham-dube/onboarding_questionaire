import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class AudioRecordingService {
  final AudioRecorder _audioRecorder = AudioRecorder();
  StreamSubscription<Amplitude>? _amplitudeSubscription;
  final _amplitudeController = StreamController<double>.broadcast();

  Stream<double> get amplitudeStream => _amplitudeController.stream;

  /// Check and request microphone permission
  Future<bool> checkAndRequestPermission() async {
    final status = await Permission.microphone.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await Permission.microphone.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return false;
  }

  /// Start recording audio
  Future<bool> startRecording() async {
    try {
      final hasPermission = await checkAndRequestPermission();
      if (!hasPermission) {
        throw Exception('Microphone permission not granted');
      }

      // Check if already recording
      if (await _audioRecorder.isRecording()) {
        return false;
      }

      // Get temporary directory for recording
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

      // Configure recording
      const config = RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      );

      // Start recording
      await _audioRecorder.start(config, path: filePath);

      // Listen to amplitude changes for waveform
      _amplitudeSubscription = _audioRecorder.onAmplitudeChanged(
        const Duration(milliseconds: 100),
      ).listen((amplitude) {
        // Normalize amplitude to 0-1 range
        final normalizedAmplitude = (amplitude.current + 60) / 60;
        final clampedAmplitude = normalizedAmplitude.clamp(0.0, 1.0);
        _amplitudeController.add(clampedAmplitude);
      });

      return true;
    } catch (e) {
      print('Error starting recording: $e');
      return false;
    }
  }

  /// Stop recording and return file path
  Future<String?> stopRecording() async {
    try {
      await _amplitudeSubscription?.cancel();
      _amplitudeSubscription = null;

      final path = await _audioRecorder.stop();

      if (path != null && await File(path).exists()) {
        return path;
      }

      return null;
    } catch (e) {
      print('Error stopping recording: $e');
      return null;
    }
  }

  /// Cancel recording and delete file
  Future<void> cancelRecording() async {
    try {
      await _amplitudeSubscription?.cancel();
      _amplitudeSubscription = null;

      final path = await _audioRecorder.stop();

      if (path != null) {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (e) {
      print('Error canceling recording: $e');
    }
  }

  /// Check if currently recording
  Future<bool> isRecording() async {
    return await _audioRecorder.isRecording();
  }

  /// Dispose resources
  Future<void> dispose() async {
    await _amplitudeSubscription?.cancel();
    await _audioRecorder.dispose();
    await _amplitudeController.close();
  }
}