import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';

/// Contract for audio playback operations.
abstract class PlayerRepository {
  /// Load and start playing audio from [url].
  Future<Either<Failure, void>> play(String url);

  /// Pause the current audio.
  Future<Either<Failure, void>> pause();

  /// Resume a paused audio.
  Future<Either<Failure, void>> resume();

  /// Seek to a specific [position].
  Future<Either<Failure, void>> seek(Duration position);

  /// Stop and release audio resources.
  Future<Either<Failure, void>> stop();

  /// Current playback position stream.
  Stream<Duration> get positionStream;

  /// Current audio duration stream (null if not yet loaded).
  Stream<Duration?> get durationStream;

  /// Whether the player is currently playing.
  Stream<bool> get playingStream;
}
