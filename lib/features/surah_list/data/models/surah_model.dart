import '../../../../core/constants/api_constant.dart';
import '../../../../core/constants/reciters.dart';
import '../../../../core/constants/surah_names_id.dart';
import '../../domain/entities/surah.dart';

/// JSON data-transfer object for the AlQuran Cloud `/surah` endpoint.
class SurahModel extends Surah {
  const SurahModel({
    required super.number,
    required super.arabicName,
    required super.latinName,
    required super.meaning,
    required super.ayahCount,
    required super.revelationType,
    required super.reciterId,
    required super.reciterName,
    required super.audioUrl,
  });

  /// Deserialises a single surah object from the API JSON array.
  ///
  /// Example JSON shape:
  /// ```json
  /// {
  ///   "number": 1,
  ///   "name": "سُورَةُ الفَاتِحَةِ",
  ///   "englishName": "Al-Faatiha",
  ///   "englishNameTranslation": "The Opening",
  ///   "numberOfAyahs": 7,
  ///   "revelationType": "Meccan"
  /// }
  /// ```
  factory SurahModel.fromJson(Map<String, dynamic> json) {
    final int number = json['number'] as int;
    final Reciter reciter = reciterFor(number);

    // Map English revelation type → Indonesian equivalent.
    final revType = (json['revelationType'] as String) == 'Meccan'
        ? 'Makkiyah'
        : 'Madaniyah';

    return SurahModel(
      number: number,
      arabicName: json['name'] as String,
      latinName: json['englishName'] as String,
      meaning: surahNamesId[number] ?? json['englishNameTranslation'] as String,
      ayahCount: json['numberOfAyahs'] as int,
      revelationType: revType,
      reciterId: reciter.id,
      reciterName: reciter.name,
      audioUrl: ApiConstants.audioUrl(reciter.id, number),
    );
  }
}
