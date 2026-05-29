part of 'player_bloc.dart';

sealed class PlayerEvent extends Equatable {
  const PlayerEvent();
  @override
  List<Object?> get props => [];
}

/// User tapped a surah row → load and play it.
class PlaySurahEvent extends PlayerEvent {
  final List<Surah> surahs;
  final int index;
  const PlaySurahEvent({required this.surahs, required this.index});

  @override
  List<Object?> get props => [index];
}

/// User tapped the play/pause button.
class TogglePlayEvent extends PlayerEvent {}

/// User dragged the seek slider.
class SeekEvent extends PlayerEvent {
  final Duration position;
  const SeekEvent(this.position);

  @override
  List<Object?> get props => [position];
}

/// User tapped the next-track button.
class NextSurahEvent extends PlayerEvent {}

/// User tapped the previous-track button.
class PrevSurahEvent extends PlayerEvent {}

/// User toggled shuffle mode.
class ToggleShuffleEvent extends PlayerEvent {}

/// User toggled repeat mode.
class ToggleRepeatEvent extends PlayerEvent {}

/// Internal: audio position ticked forward.
class _PositionUpdated extends PlayerEvent {
  final Duration position;
  const _PositionUpdated(this.position);

  @override
  List<Object?> get props => [position];
}

/// Internal: audio duration resolved (after loading).
class _DurationUpdated extends PlayerEvent {
  final Duration? duration;
  const _DurationUpdated(this.duration);

  @override
  List<Object?> get props => [duration];
}

/// Internal: playing/paused state changed in the audio engine.
class _PlayingStateUpdated extends PlayerEvent {
  final bool isPlaying;
  const _PlayingStateUpdated(this.isPlaying);

  @override
  List<Object?> get props => [isPlaying];
}

/// Internal: the current track finished playing.
/// Triggers repeat (replay) or auto-advance to the next surah.
class _TrackCompleted extends PlayerEvent {
  const _TrackCompleted();
}

/// Internal: the engine's loading state changed (initial load only).
class _LoadingUpdated extends PlayerEvent {
  final bool isLoading;
  const _LoadingUpdated(this.isLoading);

  @override
  List<Object?> get props => [isLoading];
}
