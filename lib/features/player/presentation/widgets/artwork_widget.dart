import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../surah_list/domain/entities/surah.dart';

/// Large artwork widget for the full-screen player —
/// a gradient card with the Arabic name and surah number, matching the prototype.
class ArtworkWidget extends StatelessWidget {
  final Surah surah;

  const ArtworkWidget({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = AppColors.coverFor(surah.number);

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
            transform: const GradientRotation(2.53), // ~145°
          ),
          boxShadow: [
            BoxShadow(
              color: colors.first.withValues(alpha: .45),
              blurRadius: 40,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Cross-hatch overlay
            Positioned.fill(child: CustomPaint(painter: _GridPainter())),
            // Inner border
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: .18),
                  ),
                ),
              ),
            ),
            // Arabic name — centered in the card
            Center(
              child: Text(
                surah.arabicName,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: GoogleFonts.amiri(
                  color: Colors.white,
                  fontSize: 76,
                  height: 1.0,
                  shadows: const [
                    Shadow(
                      color: Color(0x66000000),
                      offset: Offset(0, 6),
                      blurRadius: 24,
                    ),
                  ],
                ),
              ),
            ),
            // "SURAH KE-x" label — pinned below the glyph
            Positioned(
              left: 0,
              right: 0,
              bottom: 44,
              child: Text(
                'SURAH KE-${surah.number}',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white.withValues(alpha: .82),
                  fontSize: 13,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withValues(alpha: .1)
      ..strokeWidth = 0.7;
    const spacing = 13.0;
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
      canvas.drawLine(
        Offset(i, size.height),
        Offset(i + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
