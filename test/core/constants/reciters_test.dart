import 'package:flutter_test/flutter_test.dart';
import 'package:quran_player/core/constants/reciters.dart';

void main() {
  group('reciterFor', () {
    test('returns a reciter for the first surah', () {
      final Reciter r = reciterFor(1);
      expect(r.id, 'ar.alafasy');
      expect(r.name, 'Mishary Rashid Alafasy');
    });

    test('round-robins within the available reciters (never out of range)', () {
      // Whatever the size of kReciters, every surah 1..114 must map to a valid
      // reciter without throwing.
      for (int n = 1; n <= 114; n++) {
        final Reciter r = reciterFor(n);
        expect(kReciters, contains(r));
      }
    });

    test('mapping is stable for the same surah number', () {
      expect(reciterFor(36), reciterFor(36));
    });
  });
}
