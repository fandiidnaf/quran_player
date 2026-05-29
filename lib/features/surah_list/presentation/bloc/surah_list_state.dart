part of 'surah_list_bloc.dart';

sealed class SurahListState extends Equatable {
  const SurahListState();

  @override
  List<Object> get props => [];
}

class SurahListInitial extends SurahListState {}

class SurahListLoading extends SurahListState {}

class SurahListLoaded extends SurahListState {
  final List<Surah> surahs;
  const SurahListLoaded(this.surahs);

  @override
  List<Object> get props => [surahs];
}

class SurahListError extends SurahListState {
  final String message;
  const SurahListError(this.message);

  @override
  List<Object> get props => [message];
}
