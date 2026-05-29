import 'package:get_it/get_it.dart';

import '../../features/surah_list/data/datasources/surah_remote_datasource.dart';
import '../../features/surah_list/data/repositories/surah_repository_impl.dart';
import '../../features/surah_list/domain/repositories/surah_repository.dart';
import '../../features/surah_list/domain/usecases/get_all_surahs.dart';
import '../../features/surah_list/presentation/bloc/surah_list_bloc.dart';
import '../network/dio_client.dart';

/// Global service locator instance.
final GetIt sl = GetIt.instance;

/// Registers all dependencies.
///
/// Call once from [main] before [runApp].
void initDependencies() {
  coreDependencies();

  surahListDependencies();
}

void coreDependencies() {
  sl.registerLazySingleton<DioClient>(() => DioClient());
}

void surahListDependencies() {
  // blocs
  sl.registerFactory<SurahListBloc>(
    () => SurahListBloc(getAllSurahs: sl<GetAllSurahs>()),
  );

  // Use cases
  sl.registerLazySingleton<GetAllSurahs>(
    () => GetAllSurahs(sl<SurahRepository>()),
  );

  // Repositories
  sl.registerLazySingleton<SurahRepository>(
    () => SurahRepositoryImpl(sl<SurahRemoteDataSource>()),
  );

  // Data sources
  sl.registerLazySingleton<SurahRemoteDataSource>(
    () => SurahRemoteDataSourceImpl(sl<DioClient>().dio),
  );
}
