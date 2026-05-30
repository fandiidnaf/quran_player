import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_player/core/error/failures.dart';
import 'package:quran_player/features/surah_list/domain/entities/surah.dart';
import 'package:quran_player/features/surah_list/domain/usecases/get_all_surahs.dart';
import 'package:quran_player/features/surah_list/presentation/bloc/surah_list_bloc.dart';

import '../../../../helpers/test_data.dart';

class MockGetAllSurahs extends Mock implements GetAllSurahs {}

void main() {
  late MockGetAllSurahs getAllSurahs;

  setUp(() => getAllSurahs = MockGetAllSurahs());

  test('initial state is SurahListInitial', () {
    final bloc = SurahListBloc(getAllSurahs: getAllSurahs);
    expect(bloc.state, isA<SurahListInitial>());
    bloc.close();
  });

  blocTest<SurahListBloc, SurahListState>(
    'emits [Loading, Loaded] when the use case succeeds',
    build: () {
      when(() => getAllSurahs()).thenAnswer(
        (_) async => const Right<Failure, List<Surah>>(TestData.surahs),
      );
      return SurahListBloc(getAllSurahs: getAllSurahs);
    },
    act: (bloc) => bloc.add(const LoadSurahs()),
    expect: () => [
      isA<SurahListLoading>(),
      isA<SurahListLoaded>().having((s) => s.surahs, 'surahs', TestData.surahs),
    ],
  );

  blocTest<SurahListBloc, SurahListState>(
    'emits [Loading, Error] when the use case fails',
    build: () {
      when(() => getAllSurahs()).thenAnswer(
        (_) async =>
            const Left<Failure, List<Surah>>(NetworkFailure('No internet')),
      );
      return SurahListBloc(getAllSurahs: getAllSurahs);
    },
    act: (bloc) => bloc.add(const LoadSurahs()),
    expect: () => [
      isA<SurahListLoading>(),
      isA<SurahListError>().having((s) => s.message, 'message', 'No internet'),
    ],
  );
}
