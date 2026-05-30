import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_player/core/error/failures.dart';
import 'package:quran_player/features/surah_list/data/datasources/surah_remote_datasource.dart';
import 'package:quran_player/features/surah_list/data/models/surah_model.dart';
import 'package:quran_player/features/surah_list/data/repositories/surah_repository_impl.dart';

class MockSurahRemoteDataSource extends Mock implements SurahRemoteDataSource {}

void main() {
  late SurahRepositoryImpl repository;
  late MockSurahRemoteDataSource dataSource;

  setUp(() {
    dataSource = MockSurahRemoteDataSource();
    repository = SurahRepositoryImpl(dataSource);
  });

  const model = SurahModel(
    number: 1,
    arabicName: 'الفاتحة',
    latinName: 'Al-Fatihah',
    meaning: 'Pembukaan',
    ayahCount: 7,
    revelationType: 'Makkiyah',
    reciterId: 'ar.alafasy',
    reciterName: 'Mishary Rashid Alafasy',
    audioUrl:
        'https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/1.mp3',
  );

  group('getAllSurahs', () {
    test('returns Right(list) when the data source succeeds', () async {
      when(() => dataSource.getAllSurahs()).thenAnswer((_) async => [model]);

      final result = await repository.getAllSurahs();

      expect(result.isRight(), isTrue);
      result.match((_) => fail('expected Right'), (list) {
        expect(list, [model]);
      });
      verify(() => dataSource.getAllSurahs()).called(1);
    });

    test(
      'returns Left(NetworkFailure) when the data source throws one',
      () async {
        when(
          () => dataSource.getAllSurahs(),
        ).thenThrow(const NetworkFailure('No internet'));

        final result = await repository.getAllSurahs();

        expect(result.isLeft(), isTrue);
        result.match(
          (f) => expect(f, isA<NetworkFailure>()),
          (_) => fail('expected Left'),
        );
      },
    );

    test('wraps any unexpected error in a ServerFailure', () async {
      when(() => dataSource.getAllSurahs()).thenThrow(Exception('boom'));

      final result = await repository.getAllSurahs();

      expect(result.isLeft(), isTrue);
      result.match(
        (f) => expect(f, isA<ServerFailure>()),
        (_) => fail('expected Left'),
      );
    });
  });
}
