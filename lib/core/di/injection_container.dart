import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';

import '../../features/player/data/datasources/audio_datasource.dart';
import '../../features/player/data/repositories/player_repository_impl.dart';
import '../../features/player/domain/repositories/player_repository.dart';
import '../../features/player/domain/usecases/pause_audio_usecase.dart';
import '../../features/player/domain/usecases/play_surah_usecase.dart';
import '../../features/player/domain/usecases/seek_audio_usecase.dart';
import '../../features/player/presentation/bloc/player_bloc.dart';
import '../../features/search/presentation/bloc/search_bloc.dart';
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

  searchDependencies();

  playerDependencies();
}

void coreDependencies() {
  sl.registerLazySingleton<AudioPlayer>(() => AudioPlayer());
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

void searchDependencies() {
  // blocs
  sl.registerFactory<SearchBloc>(() => SearchBloc());
}

void playerDependencies() {
  // blocs
  sl.registerFactory<PlayerBloc>(
    () => PlayerBloc(
      playSurah: sl<PlaySurahUseCase>(),
      pauseAudio: sl<PauseAudioUseCase>(),
      seekAudio: sl<SeekAudioUseCase>(),
      repository: sl<PlayerRepository>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<PlaySurahUseCase>(
    () => PlaySurahUseCase(sl<PlayerRepository>()),
  );
  sl.registerLazySingleton<PauseAudioUseCase>(
    () => PauseAudioUseCase(sl<PlayerRepository>()),
  );
  sl.registerLazySingleton<SeekAudioUseCase>(
    () => SeekAudioUseCase(sl<PlayerRepository>()),
  );

  // Repositories
  sl.registerLazySingleton<PlayerRepository>(
    () => PlayerRepositoryImpl(sl<AudioDataSource>()),
  );

  // Data sources
  sl.registerLazySingleton<AudioDataSource>(
    () => AudioDataSourceImpl(sl<AudioPlayer>()),
  );
}
