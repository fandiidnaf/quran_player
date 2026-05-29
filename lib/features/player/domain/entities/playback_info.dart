import 'package:equatable/equatable.dart';

import '../../../surah_list/domain/entities/surah.dart';

/// Snapshot of the audio player's current state.
class PlaybackInfo extends Equatable {
  final Surah? currentSurah;
  final Duration position;
  final Duration duration;
  final bool isPlaying;
  final bool isLoading;
  final bool isShuffle;
  final bool isRepeat;

  const PlaybackInfo({
    this.currentSurah,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isPlaying = false,
    this.isLoading = false,
    this.isShuffle = false,
    this.isRepeat = false,
  });

  PlaybackInfo copyWith({
    Surah? currentSurah,
    Duration? position,
    Duration? duration,
    bool? isPlaying,
    bool? isLoading,
    bool? isShuffle,
    bool? isRepeat,
  }) {
    return PlaybackInfo(
      currentSurah: currentSurah ?? this.currentSurah,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      isShuffle: isShuffle ?? this.isShuffle,
      isRepeat: isRepeat ?? this.isRepeat,
    );
  }

  @override
  List<Object?> get props => [
    currentSurah,
    position,
    duration,
    isPlaying,
    isLoading,
    isShuffle,
    isRepeat,
  ];
}
