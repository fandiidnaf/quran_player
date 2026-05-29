import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/player_repository.dart';
import '../datasources/audio_datasource.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  final AudioDataSource _dataSource;

  const PlayerRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, void>> play(String url) async {
    try {
      await _dataSource.load(url);
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
}
