import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../surah_list/domain/entities/surah.dart';

part 'search_event.dart';
part 'search_state.dart';

/// Manages the search query and computes filtered results in real time.
///
/// Matches surah by:
///   - Romanised name  (latinName)
///   - Indonesian meaning
///   - Arabic name
///   - Reciter name
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchState()) {
    on<SearchSurahsLoaded>(_onSurahsLoaded);
    on<SearchQueryChanged>(_onQueryChanged);
  }

  void _onSurahsLoaded(SearchSurahsLoaded event, Emitter<SearchState> emit) {
    emit(state.copyWith(allSurahs: event.surahs, results: event.surahs));
  }

  void _onQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) {
    final String q = event.query.trim().toLowerCase();
    final List<Surah> results = q.isEmpty
        ? state.allSurahs
        : state.allSurahs.where((s) {
            return s.latinName.toLowerCase().contains(q) ||
                s.meaning.toLowerCase().contains(q) ||
                s.arabicName.contains(event.query.trim()) ||
                s.reciterName.toLowerCase().contains(q);
          }).toList();

    emit(state.copyWith(query: event.query, results: results));
  }
}
