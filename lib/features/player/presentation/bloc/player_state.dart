part of 'player_bloc.dart';

/// Single unified state for the player.
///
/// Using a single state class (instead of subclasses) keeps BlocBuilder
/// straightforward — the UI rebuilds whenever any field changes.
class PlayerState extends Equatable {
  /// Surah currently loaded (null = nothing selected yet).
  final Surah? currentSurah;

  /// Index of [currentSurah] in [surahs].
  final int? currentIndex;

  /// The full surah list — needed for next/prev navigation.
  final List<Surah> surahs;

  /// Playback position.
  final Duration position;

  /// Total duration of the loaded audio.
  final Duration duration;

  final bool isPlaying;

  /// True while the audio file is buffering/loading.
  final bool isLoading;

  final bool isShuffle;
  final bool isRepeat;

  /// Recently-played surah indices (newest first, max 8).
  final List<int> history;

  /// True when the full-screen player overlay is showing.
  final bool isPlayerExpanded;

  final String? errorMessage;

  const PlayerState({
    this.currentSurah,
    this.currentIndex,
    this.surahs = const [],
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isPlaying = false,
    this.isLoading = false,
    this.isShuffle = false,
    this.isRepeat = false,
    this.history = const [],
    this.isPlayerExpanded = false,
    this.errorMessage,
  });

  PlayerState copyWith({
    Surah? currentSurah,
    int? currentIndex,
    List<Surah>? surahs,
    Duration? position,
    Duration? duration,
    bool? isPlaying,
    bool? isLoading,
    bool? isShuffle,
    bool? isRepeat,
    List<int>? history,
    bool? isPlayerExpanded,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PlayerState(
      currentSurah: currentSurah ?? this.currentSurah,
      currentIndex: currentIndex ?? this.currentIndex,
      surahs: surahs ?? this.surahs,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      isShuffle: isShuffle ?? this.isShuffle,
      isRepeat: isRepeat ?? this.isRepeat,
      history: history ?? this.history,
      isPlayerExpanded: isPlayerExpanded ?? this.isPlayerExpanded,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    currentSurah,
    currentIndex,
    surahs,
    position,
    duration,
    isPlaying,
    isLoading,
    isShuffle,
    isRepeat,
    history,
    isPlayerExpanded,
    errorMessage,
  ];
}
