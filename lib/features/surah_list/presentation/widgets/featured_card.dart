import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/surah.dart';

/// Hero card shown at the top of the home screen.
/// Displays the last-played surah (or a default), with a gradient background.
class FeaturedCard extends StatelessWidget {
  final Surah surah;
  final bool isPlaying;
  final bool hasHistory;
  final VoidCallback onTap;

  const FeaturedCard({
    super.key,
    required this.surah,
    required this.isPlaying,
    required this.hasHistory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.coverFor(surah.number);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
            border: Border.all(color: AppColors.surfaceBorder),
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              // Cross-hatch overlay
              Positioned.fill(
                child: CustomPaint(painter: _CrossHatchBgPainter()),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hasHistory ? 'TERAKHIR DIPUTAR' : 'PILIHAN',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white.withValues(alpha: .78),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            surah.latinName,
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${surah.meaning} · ${surah.reciterName}',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white.withValues(alpha: .8),
                              fontSize: 12.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Arabic name
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        surah.arabicName,
                        style: TextStyle(
                          fontFamily: 'serif',
                          color: Colors.white.withValues(alpha: .92),
                          fontSize: 36,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CrossHatchBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: .1)
      ..strokeWidth = 0.7;
    const spacing = 11.0;
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
