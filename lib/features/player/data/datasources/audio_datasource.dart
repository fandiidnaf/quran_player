import 'package:just_audio/just_audio.dart';

abstract class AudioDataSource {
  Future<void> load(String url);
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
  final AudioPlayer audioPlayer;

  AudioDataSourceImpl({required this.audioPlayer});

  @override
  Future<void> load(String url) async {
    await audioPlayer.setUrl(url);
  }

  @override
  Future<void> play() => audioPlayer.play();

  @override
  Future<void> pause() => audioPlayer.pause();

  @override
  Future<void> seek(Duration position) => audioPlayer.seek(position);

  @override
  Future<void> stop() => audioPlayer.stop();

  @override
  Stream<Duration> get positionStream => audioPlayer.positionStream;

  @override
  Stream<Duration?> get durationStream => audioPlayer.durationStream;

  @override
  Stream<bool> get playingStream => audioPlayer.playingStream;

  @override
  Stream<PlayerState> get playerStateStream => audioPlayer.playerStateStream;

  @override
  void dispose() => audioPlayer.dispose();
}
