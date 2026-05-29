import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/surah.dart';
import '../../domain/repositories/surah_repository.dart';
import '../datasources/surah_remote_datasource.dart';
import '../models/surah_model.dart';

class SurahRepositoryImpl implements SurahRepository {
  final SurahRemoteDataSource _remoteDataSource;

  const SurahRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Surah>>> getAllSurahs() async {
    try {
      final List<SurahModel> surahs = await _remoteDataSource.getAllSurahs();
      return Right(surahs);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
