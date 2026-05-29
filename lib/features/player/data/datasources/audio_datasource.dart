import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

/// Low-level wrapper around [AudioPlayer] from the just_audio package.
///
/// Exposes only the interface used by the repository so the rest of the
/// code never depends on the just_audio library directly.
abstract class AudioDataSource {
  /// Loads [url], attaching media metadata so the system notification /
  /// lock-screen shows the surah [title] and reciter [artist].
  Future<void> load(
    String url, {
    required String id,
    required String title,
    required String artist,
  });
  Future<void> play();
  Future<void> pause();
  Future<void> seek(Duration position);
  Future<void> stop();

  Stream<Duration> get positionStream;
  Stream<Duration?> get durationStream;
  Stream<bool> get playingStream;
  Stream<PlayerState> get playerStateStream;

  void dispose();
}

class AudioDataSourceImpl implements AudioDataSource {
  final AudioPlayer _player;

  AudioDataSourceImpl(this._player);

  @override
  Future<void> load(
    String url, {
    required String id,
    required String title,
    required String artist,
  }) async {
    // A MediaItem tag is required by just_audio_background; it powers the
    // notification + lock-screen metadata and enables background playback.
    await _player.setAudioSource(
      AudioSource.uri(
        Uri.parse(url),
        tag: MediaItem(
          id: id,
          title: title,
          artist: artist,
          album: "Al-Qur'an",
        ),
      ),
    );
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();

  @override
  Stream<Duration> get positionStream => _player.positionStream;

  @override
  Stream<Duration?> get durationStream => _player.durationStream;

  @override
  Stream<bool> get playingStream => _player.playingStream;

  @override
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  @override
  void dispose() => _player.dispose();
}
