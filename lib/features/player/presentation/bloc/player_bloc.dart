import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../surah_list/domain/entities/surah.dart';
import '../../domain/usecases/pause_audio_usecase.dart';
import '../../domain/usecases/play_surah_usecase.dart';
import '../../domain/usecases/seek_audio_usecase.dart';
import '../../domain/repositories/player_repository.dart';

part 'player_event.dart';
part 'player_state.dart';

/// Controls all audio playback and exposes the current [PlayerState].
///
/// Responsibilities:
///  - Loading a surah and starting playback.
///  - Play / pause / seek / next / prev.
///  - Shuffle and repeat modes.
///  - Maintaining the recently-played history (max 8 items).
///  - Forwarding position/duration/playingState updates from the audio engine.
class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final PlaySurahUseCase _playSurah;
  final PauseAudioUseCase _pauseAudio;
  final SeekAudioUseCase _seekAudio;
  final PlayerRepository _repository;

  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<bool>? _playingSub;

  PlayerBloc({
    required PlaySurahUseCase playSurah,
    required PauseAudioUseCase pauseAudio,
    required SeekAudioUseCase seekAudio,
    required PlayerRepository repository,
  }) : _playSurah = playSurah,
       _pauseAudio = pauseAudio,
       _seekAudio = seekAudio,
       _repository = repository,
       super(const PlayerState()) {
    on<PlaySurahEvent>(_onPlaySurah);
    on<TogglePlayEvent>(_onTogglePlay);
    on<SeekEvent>(_onSeek);
    on<NextSurahEvent>(_onNext);
    on<PrevSurahEvent>(_onPrev);
    on<ToggleShuffleEvent>(_onToggleShuffle);
    on<ToggleRepeatEvent>(_onToggleRepeat);
    on<_PositionUpdated>(_onPositionUpdated);
    on<_DurationUpdated>(_onDurationUpdated);
    on<_PlayingStateUpdated>(_onPlayingStateUpdated);

    _subscribeToStreams();
  }

  //  Stream subscriptions

  void _subscribeToStreams() {
    _positionSub = _repository.positionStream.listen(
      (pos) => add(_PositionUpdated(pos)),
    );

    _durationSub = _repository.durationStream.listen(
      (dur) => add(_DurationUpdated(dur)),
    );

    _playingSub = _repository.playingStream.listen(
      (playing) => add(_PlayingStateUpdated(playing)),
    );
  }

  //  Handlers

  Future<void> _onPlaySurah(
    PlaySurahEvent event,
    Emitter<PlayerState> emit,
  ) async {
    final surah = event.surahs[event.index];

    // If tapping the same surah that's already loaded, just resume.
    if (state.currentSurah?.number == surah.number) {
      if (!state.isPlaying) await _repository.resume();
      emit(state.copyWith(isPlayerExpanded: true));
      return;
    }

    emit(
      state.copyWith(
        currentSurah: surah,
        currentIndex: event.index,
        surahs: event.surahs,
        position: Duration.zero,
        duration: Duration.zero,
        isLoading: true,
        isPlaying: false,
        isPlayerExpanded: true,
        history: _addToHistory(state.history, event.index),
        clearError: true,
      ),
    );

    final result = await _playSurah(surah.audioUrl);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isLoading: false)),
    );
  }

  Future<void> _onTogglePlay(
    TogglePlayEvent event,
    Emitter<PlayerState> emit,
  ) async {
    if (state.currentSurah == null) return;

    if (state.isPlaying) {
      await _pauseAudio();
    } else {
      await _repository.resume();
    }
  }

  Future<void> _onSeek(SeekEvent event, Emitter<PlayerState> emit) async {
    await _seekAudio(event.position);
    emit(state.copyWith(position: event.position));
  }

  Future<void> _onNext(NextSurahEvent event, Emitter<PlayerState> emit) async {
    if (state.surahs.isEmpty) return;
    final next = _nextIndex();
    add(PlaySurahEvent(surahs: state.surahs, index: next));
  }

  Future<void> _onPrev(PrevSurahEvent event, Emitter<PlayerState> emit) async {
    if (state.surahs.isEmpty) return;
    // If more than 3 s played, restart; otherwise go to previous surah.
    if (state.position.inSeconds > 3) {
      await _seekAudio(Duration.zero);
      return;
    }
    final prev = _prevIndex();
    add(PlaySurahEvent(surahs: state.surahs, index: prev));
  }

  void _onToggleShuffle(ToggleShuffleEvent event, Emitter<PlayerState> emit) {
    emit(state.copyWith(isShuffle: !state.isShuffle));
  }

  void _onToggleRepeat(ToggleRepeatEvent event, Emitter<PlayerState> emit) {
    emit(state.copyWith(isRepeat: !state.isRepeat));
  }

  void _onPositionUpdated(_PositionUpdated event, Emitter<PlayerState> emit) {
    emit(state.copyWith(position: event.position));
  }

  void _onDurationUpdated(_DurationUpdated event, Emitter<PlayerState> emit) {
    if (event.duration != null) {
      emit(state.copyWith(duration: event.duration!));
    }
  }

  void _onPlayingStateUpdated(
    _PlayingStateUpdated event,
    Emitter<PlayerState> emit,
  ) {
    emit(state.copyWith(isPlaying: event.isPlaying));
  }

  //  Helpers

  int _nextIndex() {
    if (state.isShuffle) return _randomExcept(state.currentIndex);
    return ((state.currentIndex ?? 0) + 1) % state.surahs.length;
  }

  int _prevIndex() {
    if (state.isShuffle) return _randomExcept(state.currentIndex);
    final idx = (state.currentIndex ?? 0);
    return (idx - 1 + state.surahs.length) % state.surahs.length;
  }

  int _randomExcept(int? exclude) {
    if (state.surahs.length < 2) return 0;
    int r;
    do {
      r = Random().nextInt(state.surahs.length);
    } while (r == exclude);
    return r;
  }

  /// Adds [index] to the front of [history], removing duplicates, capped at 8.
  List<int> _addToHistory(List<int> history, int index) =>
      [index, ...history.where((i) => i != index)].take(8).toList();

  @override
  Future<void> close() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _playingSub?.cancel();
    return super.close();
  }
}
