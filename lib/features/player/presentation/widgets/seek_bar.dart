import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

/// Custom seek slider with gold fill and time labels.
///
/// Supports dragging (with a larger thumb) and tap-to-seek,
/// matching the prototype's interactive progress bar.
class SeekBar extends StatefulWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration> onSeek;

  const SeekBar({
    super.key,
    required this.position,
    required this.duration,
    required this.onSeek,
  });

  @override
  State<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  Duration? _dragValue;

  String _fmt(Duration d) {
    final String h = d.inHours > 0 ? '${d.inHours}:' : '';
    final String m = d.inMinutes.remainder(60).toString();
    final String s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$h$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final Duration current = _dragValue ?? widget.position;
    final Duration total = widget.duration;

    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            activeTrackColor: AppColors.gold,
            inactiveTrackColor: Colors.white.withValues(alpha: .13),
            thumbColor: Colors.white,
            thumbShape: _RoundThumb(radius: _dragValue != null ? 9 : 7),
            overlayShape: SliderComponentShape.noOverlay,
          ),
          child: Slider(
            min: 0,
            max: total.inMilliseconds.toDouble().clamp(1, double.infinity),
            value: (current.inMilliseconds.toDouble().clamp(
              0,
              total.inMilliseconds.toDouble(),
            )),
            onChangeStart: (_) => setState(() => _dragValue = current),
            onChanged: (v) =>
                setState(() => _dragValue = Duration(milliseconds: v.toInt())),
            onChangeEnd: (v) {
              widget.onSeek(Duration(milliseconds: v.toInt()));
              setState(() => _dragValue = null);
            },
          ),
        ),
        // Progress indicator as a flat bar (replaces default slider padding)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _fmt(current),
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              Text(
                _fmt(total),
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoundThumb extends SliderComponentShape {
  final double radius;
  const _RoundThumb({required this.radius});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size(radius * 2, radius * 2);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
    // Subtle drop shadow
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.black.withValues(alpha: .3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );
  }
}
