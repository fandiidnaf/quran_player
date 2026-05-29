part of 'search_bloc.dart';

class SearchState extends Equatable {
  final String query;
  final List<Surah> results;
  final List<Surah> allSurahs;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.allSurahs = const [],
  });

  SearchState copyWith({
    String? query,
    List<Surah>? results,
    List<Surah>? allSurahs,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      allSurahs: allSurahs ?? this.allSurahs,
    );
  }

  @override
  List<Object> get props => [query, results, allSurahs];
}
