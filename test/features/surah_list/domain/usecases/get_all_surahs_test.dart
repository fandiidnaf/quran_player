import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_player/core/error/failures.dart';
import 'package:quran_player/features/surah_list/domain/entities/surah.dart';
import 'package:quran_player/features/surah_list/domain/repositories/surah_repository.dart';
import 'package:quran_player/features/surah_list/domain/usecases/get_all_surahs.dart';

import '../../../../helpers/test_data.dart';

/// Mock of the repository the use-case depends on.
class MockSurahRepository extends Mock implements SurahRepository {}

void main() {
  late GetAllSurahs useCase;
  late MockSurahRepository repository;

  setUp(() {
    repository = MockSurahRepository();
    useCase = GetAllSurahs(repository);
  });

  group('GetAllSurahs', () {
    test('returns the surah list from the repository on success', () async {
      // arrange
      when(
        () => repository.getAllSurahs(),
      ).thenAnswer((_) async => const Right(TestData.surahs));

      // act
      final result = await useCase();

      // assert
      expect(result, const Right<Failure, List<Surah>>(TestData.surahs));
      verify(() => repository.getAllSurahs()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('propagates a ServerFailure from the repository', () async {
      const failure = ServerFailure('Server error');
      when(
        () => repository.getAllSurahs(),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase();

      expect(result, const Left<Failure, List<Surah>>(failure));
    });

    test('propagates a NetworkFailure from the repository', () async {
      const failure = NetworkFailure('No internet');
      when(
        () => repository.getAllSurahs(),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase();

      expect(result, const Left<Failure, List<Surah>>(failure));
    });
  });
}
