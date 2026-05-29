import 'package:equatable/equatable.dart';

/// Core domain entity representing a single Quranic surah ("song").
///
/// In the music-player metaphor:
///   - [latinName] → track title
///   - [reciterName] → artist
///   - [audioUrl]   → stream URL
class Surah extends Equatable {
  /// Official surah number (1–114).
  final int number;

  /// Full Arabic script name, e.g. "الفاتحة".
  final String arabicName;

  /// Romanised name, e.g. "Al-Fatihah".
  final String latinName;

  /// Indonesian meaning, e.g. "Pembukaan".
  final String meaning;

  /// Number of verses.
  final int ayahCount;

  /// Revelation type: "Makkiyah" or "Madaniyah".
  final String revelationType;

  /// Reciter / qari ID, e.g. "ar.alafasy".
  final String reciterId;

  /// Reciter display name.
  final String reciterName;

  /// Full audio CDN URL.
  final String audioUrl;

  const Surah({
    required this.number,
    required this.arabicName,
    required this.latinName,
    required this.meaning,
    required this.ayahCount,
    required this.revelationType,
    required this.reciterId,
    required this.reciterName,
    required this.audioUrl,
  });

  @override
  List<Object> get props => [number];
}
