import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../repositories/player_repository.dart';

/// Pauses the currently playing audio.
class PauseAudioUseCase {
  final PlayerRepository _repository;

  const PauseAudioUseCase(this._repository);

  Future<Either<Failure, void>> call() => _repository.pause();
}
