import 'package:quran_player/features/surah_list/domain/entities/surah.dart';

/// Shared, deterministic test data so every test reads against the same surahs.
///
/// Kept tiny (3 entries) and independent of the network — perfect for unit and
/// widget tests.
class TestData {
  TestData._();

  static const surahAlFatihah = Surah(
    number: 1,
    arabicName: 'الفاتحة',
    latinName: 'Al-Fatihah',
    meaning: 'Pembukaan',
    ayahCount: 7,
    revelationType: 'Makkiyah',
    reciterId: 'ar.alafasy',
    reciterName: 'Mishary Rashid Alafasy',
    audioUrl:
        'https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/1.mp3',
  );

  static const surahAlBaqarah = Surah(
    number: 2,
    arabicName: 'البقرة',
    latinName: 'Al-Baqarah',
    meaning: 'Sapi Betina',
    ayahCount: 286,
    revelationType: 'Madaniyah',
    reciterId: 'ar.alafasy',
    reciterName: 'Mishary Rashid Alafasy',
    audioUrl:
        'https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/2.mp3',
  );

  static const surahYasin = Surah(
    number: 36,
    arabicName: 'يس',
    latinName: 'Yasin',
    meaning: 'Ya Sin',
    ayahCount: 83,
    revelationType: 'Makkiyah',
    reciterId: 'ar.alafasy',
    reciterName: 'Mishary Rashid Alafasy',
    audioUrl:
        'https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/36.mp3',
  );

  /// A small, ordered list used by list/search/player tests.
  static const List<Surah> surahs = [
    surahAlFatihah,
    surahAlBaqarah,
    surahYasin,
  ];

  /// A raw JSON object shaped exactly like one element of the AlQuran Cloud
  /// `/surah` response — used to test [SurahModel.fromJson].
  static const Map<String, dynamic> surahJson = {
    'number': 1,
    'name': 'سُورَةُ الفَاتِحَةِ',
    'englishName': 'Al-Faatiha',
    'englishNameTranslation': 'The Opening',
    'numberOfAyahs': 7,
    'revelationType': 'Meccan',
  };
}
