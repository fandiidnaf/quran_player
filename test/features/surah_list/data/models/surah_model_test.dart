import 'package:flutter_test/flutter_test.dart';
import 'package:quran_player/features/surah_list/data/models/surah_model.dart';
import 'package:quran_player/features/surah_list/domain/entities/surah.dart';

import '../../../../helpers/test_data.dart';

void main() {
  group('SurahModel.fromJson', () {
    test('is a subtype of the Surah entity', () {
      final model = SurahModel.fromJson(TestData.surahJson);
      expect(model, isA<Surah>());
    });

    test('maps all JSON fields correctly', () {
      final model = SurahModel.fromJson(TestData.surahJson);

      expect(model.number, 1);
      expect(model.arabicName, 'سُورَةُ الفَاتِحَةِ');
      expect(model.latinName, 'Al-Faatiha');
      expect(model.ayahCount, 7);
    });

    test('converts the English revelation type to Indonesian', () {
      // "Meccan" -> "Makkiyah"
      final meccan = SurahModel.fromJson({
        ...TestData.surahJson,
        'revelationType': 'Meccan',
      });
      expect(meccan.revelationType, 'Makkiyah');

      // "Medinan" -> "Madaniyah"
      final medinan = SurahModel.fromJson({
        ...TestData.surahJson,
        'revelationType': 'Medinan',
      });
      expect(medinan.revelationType, 'Madaniyah');
    });

    test('uses the Indonesian meaning lookup instead of the English one', () {
      final model = SurahModel.fromJson(TestData.surahJson);
      // surahNamesId[1] == 'Pembukaan' (not the English "The Opening")
      expect(model.meaning, 'Pembukaan');
    });

    test('builds the full-surah audio URL from the assigned reciter', () {
      final model = SurahModel.fromJson(TestData.surahJson);
      expect(model.reciterId, 'ar.alafasy');
      expect(
        model.audioUrl,
        'https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/1.mp3',
      );
    });
  });
}
