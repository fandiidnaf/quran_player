import 'package:fpdart/fpdart.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/player_repository.dart';
import '../datasources/audio_datasource.dart';

/// Implements [PlayerRepository] by delegating to [AudioDataSource].
class PlayerRepositoryImpl implements PlayerRepository {
  final AudioDataSource _dataSource;

  const PlayerRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, void>> play(
    String url, {
    required String id,
    required String title,
    required String artist,
  }) async {
    try {
      // Pause first so the engine's `playing` flag is false during the load.
      // Otherwise the leftover `playing == true` from the previous track makes
      // the UI show "playing" while the new track is still loading (the cause
      // of the mini-player/detail mismatch and the stuck button).
      await _dataSource.pause();
      await _dataSource.load(url, id: id, title: title, artist: artist);
      await _dataSource.play();
      return const Right(null);
    } catch (e) {
      return Left(AudioFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> pause() async {
    try {
      await _dataSource.pause();
      return const Right(null);
    } catch (e) {
      return Left(AudioFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resume() async {
    try {
      await _dataSource.play();
      return const Right(null);
    } catch (e) {
      return Left(AudioFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> seek(Duration position) async {
    try {
      await _dataSource.seek(position);
      return const Right(null);
    } catch (e) {
      return Left(AudioFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> stop() async {
    try {
      await _dataSource.stop();
      return const Right(null);
    } catch (e) {
      return Left(AudioFailure(e.toString()));
    }
  }

  @override
  Stream<Duration> get positionStream => _dataSource.positionStream;

  @override
  Stream<Duration?> get durationStream => _dataSource.durationStream;

  @override
  Stream<bool> get playingStream => _dataSource.playingStream;

  @override
  Stream<void> get completedStream => _dataSource.playerStateStream
      .where((state) => state.processingState == ProcessingState.completed)
      .map((_) {});

  @override
  Stream<bool> get loadingStream => _dataSource.playerStateStream
      .map((state) => state.processingState == ProcessingState.loading)
      .distinct();
}
