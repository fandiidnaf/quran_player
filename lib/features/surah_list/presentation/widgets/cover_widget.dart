import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/surah.dart';

/// Gradient cover art for a surah, with a subtle cross-hatch overlay
/// and the surah number centered — matching the prototype design.
class CoverWidget extends StatelessWidget {
  final Surah surah;
  final double size;
  final double radius;

  const CoverWidget({
    super.key,
    required this.surah,
    this.size = 52,
    this.radius = 13,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.coverFor(surah.number);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
          stops: const [0.0, 1.0],
          transform: const GradientRotation(2.6), // ~150°
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x14FFFFFF), blurRadius: 0, spreadRadius: 1),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Cross-hatch decorative pattern
            Positioned.fill(child: CustomPaint(painter: _CrossHatchPainter())),
            // Surah number
            Text(
              '${surah.number}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: .92),
                fontSize: size * 0.36,
                fontWeight: FontWeight.w700,
                shadows: const [
                  Shadow(
                    color: Color(0x59000000),
                    offset: Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Paints the subtle diagonal cross-hatch visible in the prototype covers.
class _CrossHatchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: .12)
      ..strokeWidth = 0.8;

    const spacing = 10.0;
    // 45° lines
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
    // -45° lines
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
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
