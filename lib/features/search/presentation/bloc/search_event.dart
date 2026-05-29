part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object> get props => [];
}

/// User typed or cleared the search query.
class SearchQueryChanged extends SearchEvent {
  final String query;
  const SearchQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

/// Populate the pool of surahs to search within.
class SearchSurahsLoaded extends SearchEvent {
  final List<Surah> surahs;
  const SearchSurahsLoaded(this.surahs);

  @override
  List<Object> get props => [surahs];
}
