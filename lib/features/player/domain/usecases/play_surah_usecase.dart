import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../repositories/player_repository.dart';

/// Loads and starts audio playback for a given URL.
class PlaySurahUseCase {
  final PlayerRepository _repository;

  const PlaySurahUseCase(this._repository);

  Future<Either<Failure, void>> call(String audioUrl) =>
      _repository.play(audioUrl);
}
