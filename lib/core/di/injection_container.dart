import 'package:get_it/get_it.dart';

import '../network/dio_client.dart';

/// Global service locator instance.
final GetIt sl = GetIt.instance;

/// Registers all dependencies.
///
/// Call once from [main] before [runApp].
void initDependencies() {
  coreDependencies();
}

void coreDependencies() {
  sl.registerLazySingleton<DioClient>(() => DioClient());
}
