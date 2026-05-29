import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/surah.dart';
import '../../domain/usecases/get_all_surahs.dart';

part 'surah_list_event.dart';
part 'surah_list_state.dart';

class SurahListBloc extends Bloc<SurahListEvent, SurahListState> {
  final GetAllSurahs _getAllSurahs;

  SurahListBloc({required GetAllSurahs getAllSurahs})
    : _getAllSurahs = getAllSurahs,
      super(SurahListInitial()) {
    on<LoadSurahs>(_onLoadSurahs);
  }

  Future<void> _onLoadSurahs(
    LoadSurahs event,
    Emitter<SurahListState> emit,
  ) async {
    emit(SurahListLoading());
    final result = await _getAllSurahs();
    result.fold(
      (failure) => emit(SurahListError(failure.message)),
      (surahs) => emit(SurahListLoaded(surahs)),
    );
  }
}
