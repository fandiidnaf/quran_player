part of 'surah_list_bloc.dart';

sealed class SurahListEvent extends Equatable {
  const SurahListEvent();

  @override
  List<Object> get props => [];
}

/// Triggers loading (or reloading) the full surah list from the API.
class LoadSurahs extends SurahListEvent {
  const LoadSurahs();
}
