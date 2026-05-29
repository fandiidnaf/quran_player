import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/surah.dart';
import 'cover_widget.dart';

/// One row in the surah list — cover art, Latin + reciter name, Arabic name.
class SurahRow extends StatelessWidget {
  final Surah surah;
  final bool isCurrent;
  final bool isPlaying;
  final VoidCallback onTap;

  const SurahRow({
    super.key,
    required this.surah,
    required this.isCurrent,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
        child: Row(
          children: [
            CoverWidget(surah: surah),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          surah.latinName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            color: isCurrent
                                ? AppColors.gold
                                : AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (isCurrent && isPlaying) ...[
                        const SizedBox(width: 6),
                        const _EqualizerBars(),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${surah.reciterName} · ${surah.ayahCount} ayat',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Arabic name
            Text(
              surah.arabicName,
              style: TextStyle(
                fontFamily: 'serif',
                color: isCurrent ? AppColors.gold : AppColors.textMuted,
                fontSize: 20,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}

/// Animated equalizer bars shown next to the currently-playing surah.
class _EqualizerBars extends StatefulWidget {
  const _EqualizerBars();

  @override
  State<_EqualizerBars> createState() => _EqualizerBarsState();
}

class _EqualizerBarsState extends State<_EqualizerBars>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (i) {
      return AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 600 + i * 120),
      )..repeat(reverse: true);
    });
    _animations = _controllers
        .map(
          (c) => Tween<double>(
            begin: 3,
            end: 12,
          ).animate(CurvedAnimation(parent: c, curve: Curves.easeInOut)),
        )
        .toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _animations[i],
          builder: (_, _) => Container(
            width: 2.5,
            height: _animations[i].value,
            margin: const EdgeInsets.only(right: 1.5),
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
