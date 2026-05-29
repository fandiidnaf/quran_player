import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/surah.dart';
import '../repositories/surah_repository.dart';

/// Fetches the complete surah list from the repository.
///
class GetAllSurahs {
  final SurahRepository repository;

  const GetAllSurahs(this.repository);

  Future<Either<Failure, List<Surah>>> call() => repository.getAllSurahs();
}
