import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../repositories/player_repository.dart';

/// Seeks the audio to a given position.
class SeekAudioUseCase {
  final PlayerRepository _repository;

  const SeekAudioUseCase(this._repository);

  Future<Either<Failure, void>> call(Duration position) =>
      _repository.seek(position);
}
