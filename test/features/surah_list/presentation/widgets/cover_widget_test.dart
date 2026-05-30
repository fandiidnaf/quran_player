import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_player/features/surah_list/presentation/widgets/cover_widget.dart';

import '../../../../helpers/test_data.dart';

void main() {
  Widget host(Widget child) => MaterialApp(home: Scaffold(body: Center(child: child)));

  testWidgets('renders the surah number as the cover label', (tester) async {
    await tester.pumpWidget(host(
      const CoverWidget(surah: TestData.surahYasin),
    ));

    expect(find.text('36'), findsOneWidget);
  });

  testWidgets('respects the provided size', (tester) async {
    await tester.pumpWidget(host(
      const CoverWidget(surah: TestData.surahAlFatihah, size: 80, radius: 16),
    ));

    final box = tester.getSize(find.byType(CoverWidget));
    expect(box.width, 80);
    expect(box.height, 80);
  });
}
