/// AlQuran Cloud API and CDN endpoints.
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.alquran.cloud/v1';
  static const String surahListEndpoint = '/surah';

  /// CDN template for full-surah audio MP3.
  /// Params: [edition] e.g. "ar.alafasy", [number] 1-114.
  static const String audioCdnTemplate =
      'https://cdn.islamic.network/quran/audio-surah/128/{edition}/{number}.mp3';

  static String audioUrl(String edition, int surahNumber) =>
      audioCdnTemplate
          .replaceFirst('{edition}', edition)
          .replaceFirst('{number}', surahNumber.toString());
}
