import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_player/features/surah_list/presentation/widgets/surah_row.dart';

import '../../../../helpers/test_data.dart';

void main() {
  // Prevent google_fonts from attempting a network fetch during tests.
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('shows the latin name, reciter + ayah count, and arabic name',
      (tester) async {
    await tester.pumpWidget(host(
      SurahRow(
        surah: TestData.surahAlFatihah,
        isCurrent: false,
        isPlaying: false,
        onTap: () {},
      ),
    ));

    expect(find.text('Al-Fatihah'), findsOneWidget);
    expect(find.text('Mishary Rashid Alafasy · 7 ayat'), findsOneWidget);
    expect(find.text('الفاتحة'), findsOneWidget);
  });

  testWidgets('invokes onTap when the row is tapped', (tester) async {
    var tapped = false;
    await tester.pumpWidget(host(
      SurahRow(
        surah: TestData.surahAlFatihah,
        isCurrent: false,
        isPlaying: false,
        onTap: () => tapped = true,
      ),
    ));

    await tester.tap(find.byType(SurahRow));
    expect(tapped, isTrue);
  });

  testWidgets('renders without error while marked as the current playing row',
      (tester) async {
    await tester.pumpWidget(host(
      SurahRow(
        surah: TestData.surahAlFatihah,
        isCurrent: true,
        isPlaying: true,
        onTap: () {},
      ),
    ));
    // Pump a couple frames to let the equalizer animation start.
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Al-Fatihah'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
