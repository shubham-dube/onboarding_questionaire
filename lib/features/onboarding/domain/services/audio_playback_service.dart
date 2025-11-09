import 'dart:async';
import 'package:just_audio/just_audio.dart';

enum PlaybackState {
  idle,
  loading,
  playing,
  paused,
  completed,
  error,
}

class AudioPlaybackService {
  AudioPlayer? _audioPlayer;
  String? _currentAudioPath;

  final _playbackStateController = StreamController<PlaybackState>.broadcast();
  final _positionController = StreamController<Duration>.broadcast();

  Stream<PlaybackState> get playbackStateStream => _playbackStateController.stream;
  Stream<Duration> get positionStream => _positionController.stream;

  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  bool _isDisposed = false;
  PlaybackState _currentState = PlaybackState.idle;

  Future<void> loadAudio(String path) async {
    if (_isDisposed) return;

    try {
      // If same audio is already loaded, don't reload
      if (_currentAudioPath == path && _audioPlayer != null) {
        await _audioPlayer!.seek(Duration.zero);
        _emitState(PlaybackState.idle);
        return;
      }

      _emitState(PlaybackState.loading);

      // Safely dispose existing player
      await _safeDisposePlayer();

      // Create new player
      _audioPlayer = AudioPlayer();
      _currentAudioPath = path;

      // Load the audio file
      await _audioPlayer!.setFilePath(path);

      // Listen to player state changes
      _playerStateSubscription = _audioPlayer!.playerStateStream.listen(
            (playerState) {
          if (_isDisposed) return;

          if (playerState.processingState == ProcessingState.completed) {
            _emitState(PlaybackState.completed);
          } else if (playerState.processingState == ProcessingState.ready) {
            if (playerState.playing) {
              _emitState(PlaybackState.playing);
            } else {
              if (_currentState == PlaybackState.loading) {
                _emitState(PlaybackState.idle);
              }
            }
          }
        },
        onError: (error) {
          print('Player state error: $error');
          _emitState(PlaybackState.error);
        },
      );

      // Listen to position changes
      _positionSubscription = _audioPlayer!.positionStream.listen(
            (position) {
          if (_isDisposed) return;
          if (!_positionController.isClosed) {
            _positionController.add(position);
          }
        },
        onError: (error) {
          print('Position stream error: $error');
        },
      );

      _emitState(PlaybackState.idle);
    } catch (e) {
      print('Error loading audio: $e');
      _emitState(PlaybackState.error);
      rethrow;
    }
  }

  Future<void> play() async {
    if (_isDisposed || _audioPlayer == null) {
      throw Exception('Audio not loaded. Call loadAudio() first.');
    }

    try {
      // If completed, seek to start
      if (_currentState == PlaybackState.completed) {
        await _audioPlayer!.seek(Duration.zero);
      }

      await _audioPlayer!.play();
      _emitState(PlaybackState.playing);
    } catch (e) {
      print('Error playing audio: $e');
      _emitState(PlaybackState.error);
      rethrow;
    }
  }

  Future<void> pause() async {
    if (_isDisposed || _audioPlayer == null) return;

    try {
      await _audioPlayer!.pause();
      _emitState(PlaybackState.paused);
    } catch (e) {
      print('Error pausing audio: $e');
    }
  }

  Future<void> stop() async {
    if (_isDisposed || _audioPlayer == null) return;

    try {
      await _audioPlayer!.stop();
      await _audioPlayer!.seek(Duration.zero);
      _emitState(PlaybackState.idle);

      // Emit zero position
      if (!_positionController.isClosed) {
        _positionController.add(Duration.zero);
      }
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }

  Future<void> seek(Duration position) async {
    if (_isDisposed || _audioPlayer == null) return;

    try {
      final duration = _audioPlayer!.duration ?? Duration.zero;

      // Clamp position to valid range
      final clampedPosition = Duration(
        milliseconds: position.inMilliseconds.clamp(0, duration.inMilliseconds),
      );

      await _audioPlayer!.seek(clampedPosition);

      // Immediately emit the new position
      if (!_positionController.isClosed) {
        _positionController.add(clampedPosition);
      }
    } catch (e) {
      print('Error seeking audio: $e');
    }
  }

  Duration? get duration => _audioPlayer?.duration;
  Duration get position => _audioPlayer?.position ?? Duration.zero;
  PlaybackState get currentState => _currentState;

  void _emitState(PlaybackState state) {
    if (_isDisposed) return;

    _currentState = state;
    if (!_playbackStateController.isClosed) {
      _playbackStateController.add(state);
    }
  }

  Future<void> _safeDisposePlayer() async {
    if (_audioPlayer == null) return;

    try {
      // Cancel subscriptions first
      await _positionSubscription?.cancel();
      _positionSubscription = null;

      await _playerStateSubscription?.cancel();
      _playerStateSubscription = null;

      // Stop playback
      try {
        await _audioPlayer!.stop();
      } catch (e) {
        print('Error stopping player during disposal: $e');
      }

      // Dispose player
      try {
        await _audioPlayer!.dispose();
      } catch (e) {
        print('Error disposing player: $e');
      }

      _audioPlayer = null;
      _currentAudioPath = null;
    } catch (e) {
      print('Error in _safeDisposePlayer: $e');
    }
  }

  Future<void> dispose() async {
    if (_isDisposed) return;

    _isDisposed = true;

    // Dispose player
    await _safeDisposePlayer();

    // Close stream controllers
    await _playbackStateController.close();
    await _positionController.close();
  }
}