import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_player/features/player/presentation/widgets/seek_bar.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  Widget host(Widget child) =>
      MaterialApp(home: Scaffold(body: Center(child: child)));

  testWidgets('formats short durations as m:ss', (tester) async {
    await tester.pumpWidget(host(
      SeekBar(
        position: const Duration(seconds: 65), // 1:05
        duration: const Duration(minutes: 10), // 10:00
        onSeek: (_) {},
      ),
    ));

    expect(find.text('1:05'), findsOneWidget);
    expect(find.text('10:00'), findsOneWidget);
  });

  testWidgets('formats long durations with an hours component', (tester) async {
    await tester.pumpWidget(host(
      SeekBar(
        position: Duration.zero, // 0:00
        duration: const Duration(hours: 2, minutes: 5, seconds: 9), // 2:5:09
        onSeek: (_) {},
      ),
    ));

    expect(find.text('0:00'), findsOneWidget);
    expect(find.text('2:5:09'), findsOneWidget);
  });

  testWidgets('renders a Slider and reports a new position on drag',
      (tester) async {
    Duration? seeked;
    await tester.pumpWidget(host(
      SizedBox(
        width: 300,
        child: SeekBar(
          position: Duration.zero,
          duration: const Duration(minutes: 10),
          onSeek: (d) => seeked = d,
        ),
      ),
    ));

    expect(find.byType(Slider), findsOneWidget);

    // Drag the slider thumb to the right; onChangeEnd → onSeek fires.
    await tester.drag(find.byType(Slider), const Offset(150, 0));
    await tester.pumpAndSettle();

    expect(seeked, isNotNull);
    expect(seeked!.inSeconds, greaterThan(0));
  });
}
