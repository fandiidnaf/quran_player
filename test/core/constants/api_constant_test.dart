import 'package:flutter_test/flutter_test.dart';
import 'package:quran_player/core/constants/api_constant.dart';

void main() {
  group('ApiConstants', () {
    test('base url and endpoint are correct', () {
      expect(ApiConstants.baseUrl, 'https://api.alquran.cloud/v1');
      expect(ApiConstants.surahListEndpoint, '/surah');
    });

    test('audioUrl injects edition and surah number into the template', () {
      final url = ApiConstants.audioUrl('ar.alafasy', 1);
      expect(
        url,
        'https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/1.mp3',
      );
    });

    test('audioUrl works for any surah number', () {
      expect(
        ApiConstants.audioUrl('ar.alafasy', 114),
        'https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/114.mp3',
      );
    });
  });
}
