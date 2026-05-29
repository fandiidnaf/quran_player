import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/surah.dart';

abstract class SurahRepository {
  /// Returns all 114 surahs or a [Failure].
  Future<Either<Failure, List<Surah>>> getAllSurahs();
}
