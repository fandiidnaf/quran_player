import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_player/core/error/failures.dart';
import 'package:quran_player/features/player/domain/repositories/player_repository.dart';
import 'package:quran_player/features/player/domain/usecases/pause_audio_usecase.dart';
import 'package:quran_player/features/player/domain/usecases/play_surah_usecase.dart';
import 'package:quran_player/features/player/domain/usecases/seek_audio_usecase.dart';
import 'package:quran_player/features/player/presentation/bloc/player_bloc.dart';

import '../../../../helpers/test_data.dart';

class MockPlayerRepository extends Mock implements PlayerRepository {}

class MockPlaySurahUseCase extends Mock implements PlaySurahUseCase {}

class MockPauseAudioUseCase extends Mock implements PauseAudioUseCase {}

class MockSeekAudioUseCase extends Mock implements SeekAudioUseCase {}

void main() {
  late MockPlayerRepository repository;
  late MockPlaySurahUseCase playSurah;
  late MockPauseAudioUseCase pauseAudio;
  late MockSeekAudioUseCase seekAudio;

  setUpAll(() => registerFallbackValue(Duration.zero));

  PlayerBloc buildBloc() => PlayerBloc(
        playSurah: playSurah,
        pauseAudio: pauseAudio,
        seekAudio: seekAudio,
        repository: repository,
      );

  setUp(() {
    repository = MockPlayerRepository();
    playSurah = MockPlaySurahUseCase();
    pauseAudio = MockPauseAudioUseCase();
    seekAudio = MockSeekAudioUseCase();

    // The bloc subscribes to these five streams in its constructor — they must
    // all be stubbed or construction throws.
    when(() => repository.positionStream)
        .thenAnswer((_) => const Stream<Duration>.empty());
    when(() => repository.durationStream)
        .thenAnswer((_) => const Stream<Duration?>.empty());
    when(() => repository.playingStream)
        .thenAnswer((_) => const Stream<bool>.empty());
    when(() => repository.completedStream)
        .thenAnswer((_) => const Stream<void>.empty());
    when(() => repository.loadingStream)
        .thenAnswer((_) => const Stream<bool>.empty());

    when(() => repository.stop())
        .thenAnswer((_) async => const Right<Failure, void>(null));
    when(() => repository.resume())
        .thenAnswer((_) async => const Right<Failure, void>(null));
    when(() => repository.pause())
        .thenAnswer((_) async => const Right<Failure, void>(null));

    when(() => playSurah(
          any(),
          id: any(named: 'id'),
          title: any(named: 'title'),
          artist: any(named: 'artist'),
        )).thenAnswer((_) async => const Right<Failure, void>(null));
    when(() => pauseAudio())
        .thenAnswer((_) async => const Right<Failure, void>(null));
    when(() => seekAudio(any()))
        .thenAnswer((_) async => const Right<Failure, void>(null));
  });

  group('PlayerBloc', () {
    test('initial state has nothing loaded and is not playing', () {
      final bloc = buildBloc();
      expect(bloc.state.currentSurah, isNull);
      expect(bloc.state.isPlaying, isFalse);
      expect(bloc.state.isLoading, isFalse);
      bloc.close();
    });

    blocTest<PlayerBloc, PlayerState>(
      'PlaySurahEvent loads the surah, expands the player and records history',
      build: buildBloc,
      act: (b) => b.add(
        const PlaySurahEvent(surahs: TestData.surahs, index: 0),
      ),
      expect: () => [
        isA<PlayerState>()
            .having((s) => s.currentSurah, 'currentSurah',
                TestData.surahAlFatihah)
            .having((s) => s.currentIndex, 'currentIndex', 0)
            .having((s) => s.isLoading, 'isLoading', true)
            .having((s) => s.isPlayerExpanded, 'isPlayerExpanded', true)
            .having((s) => s.history, 'history', [0]),
      ],
      verify: (_) {
        // It always stops the previous track before loading the new one.
        verify(() => repository.stop()).called(1);
        verify(() => playSurah(
              any(),
              id: any(named: 'id'),
              title: any(named: 'title'),
              artist: any(named: 'artist'),
            )).called(1);
      },
    );

    blocTest<PlayerBloc, PlayerState>(
      'PlaySurahEvent surfaces an error when the stop step fails',
      build: () {
        when(() => repository.stop()).thenAnswer(
          (_) async => const Left<Failure, void>(AudioFailure('cannot stop')),
        );
        return buildBloc();
      },
      act: (b) => b.add(
        const PlaySurahEvent(surahs: TestData.surahs, index: 0),
      ),
      expect: () => [
        // loading state
        isA<PlayerState>().having((s) => s.isLoading, 'isLoading', true),
        // error state
        isA<PlayerState>()
            .having((s) => s.errorMessage, 'errorMessage', 'cannot stop'),
      ],
      verify: (_) {
        // Playback must NOT be attempted if stopping failed.
        verifyNever(() => playSurah(
              any(),
              id: any(named: 'id'),
              title: any(named: 'title'),
              artist: any(named: 'artist'),
            ));
      },
    );

    blocTest<PlayerBloc, PlayerState>(
      'ToggleShuffleEvent flips the shuffle flag',
      build: buildBloc,
      act: (b) => b.add(ToggleShuffleEvent()),
      expect: () => [
        isA<PlayerState>().having((s) => s.isShuffle, 'isShuffle', true),
      ],
    );

    blocTest<PlayerBloc, PlayerState>(
      'ToggleRepeatEvent flips the repeat flag',
      build: buildBloc,
      act: (b) => b.add(ToggleRepeatEvent()),
      expect: () => [
        isA<PlayerState>().having((s) => s.isRepeat, 'isRepeat', true),
      ],
    );

    blocTest<PlayerBloc, PlayerState>(
      'SeekEvent updates the position and calls the seek use case',
      build: buildBloc,
      act: (b) => b.add(const SeekEvent(Duration(seconds: 42))),
      expect: () => [
        isA<PlayerState>()
            .having((s) => s.position, 'position', const Duration(seconds: 42)),
      ],
      verify: (_) =>
          verify(() => seekAudio(const Duration(seconds: 42))).called(1),
    );

    blocTest<PlayerBloc, PlayerState>(
      'TogglePlayEvent is a no-op when nothing is loaded',
      build: buildBloc,
      act: (b) => b.add(TogglePlayEvent()),
      expect: () => const <PlayerState>[],
      verify: (_) {
        verifyNever(() => pauseAudio());
        verifyNever(() => repository.resume());
      },
    );
  });
}
