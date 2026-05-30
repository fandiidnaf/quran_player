import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_player/features/search/presentation/bloc/search_bloc.dart';

import '../../../../helpers/test_data.dart';

void main() {
  group('SearchBloc', () {
    test('initial state has an empty query and no results', () {
      final bloc = SearchBloc();
      expect(bloc.state.query, '');
      expect(bloc.state.results, isEmpty);
      bloc.close();
    });

    blocTest<SearchBloc, SearchState>(
      'SearchSurahsLoaded fills both the pool and the visible results',
      build: SearchBloc.new,
      act: (b) => b.add(const SearchSurahsLoaded(TestData.surahs)),
      expect: () => [
        isA<SearchState>()
            .having((s) => s.allSurahs, 'allSurahs', TestData.surahs)
            .having((s) => s.results, 'results', TestData.surahs),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'filters by Latin name (case-insensitive)',
      build: SearchBloc.new,
      seed: () => const SearchState(
        allSurahs: TestData.surahs,
        results: TestData.surahs,
      ),
      act: (b) => b.add(const SearchQueryChanged('baqarah')),
      expect: () => [
        isA<SearchState>().having(
          (s) => s.results.map((e) => e.latinName).toList(),
          'results',
          ['Al-Baqarah'],
        ),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'filters by reciter (artist) name',
      build: SearchBloc.new,
      seed: () => const SearchState(
        allSurahs: TestData.surahs,
        results: TestData.surahs,
      ),
      act: (b) => b.add(const SearchQueryChanged('alafasy')),
      expect: () => [
        isA<SearchState>()
            .having((s) => s.results.length, 'all match reciter', 3),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'filters by Indonesian meaning',
      build: SearchBloc.new,
      seed: () => const SearchState(
        allSurahs: TestData.surahs,
        results: TestData.surahs,
      ),
      act: (b) => b.add(const SearchQueryChanged('sapi')),
      expect: () => [
        isA<SearchState>().having(
          (s) => s.results.single.latinName,
          'result',
          'Al-Baqarah',
        ),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'an empty query restores the full list',
      build: SearchBloc.new,
      seed: () => const SearchState(
        allSurahs: TestData.surahs,
        results: [TestData.surahAlBaqarah],
        query: 'baqarah',
      ),
      act: (b) => b.add(const SearchQueryChanged('')),
      expect: () => [
        isA<SearchState>().having((s) => s.results, 'results', TestData.surahs),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'returns an empty result list when nothing matches',
      build: SearchBloc.new,
      seed: () => const SearchState(
        allSurahs: TestData.surahs,
        results: TestData.surahs,
      ),
      act: (b) => b.add(const SearchQueryChanged('zzzzz')),
      expect: () => [
        isA<SearchState>().having((s) => s.results, 'results', isEmpty),
      ],
    );
  });
}
