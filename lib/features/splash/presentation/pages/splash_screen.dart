import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/route_structure.dart';
import '../../../surah_list/presentation/pages/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const RouteStructure route = RouteStructure(
    path: '/splash',
    name: 'splash',
  );

  /// How long the splash stays before routing to home.
  static const Duration _hold = Duration(milliseconds: 2400);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulse; // disc pulse (loop)
  late final AnimationController _intro; // entrance fade/scale
  late final AnimationController _loader; // loader bar fill
  late final Animation<double> _introFade;
  late final Animation<double> _introScale;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _introFade = CurvedAnimation(parent: _intro, curve: Curves.easeOut);
    _introScale = Tween<double>(
      begin: 0.86,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _intro, curve: Curves.easeOutBack));

    _loader = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..forward();

    _timer = Timer(SplashScreen._hold, () {
      if (mounted) context.go(HomePage.route.path);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulse.dispose();
    _intro.dispose();
    _loader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        // radial-gradient(120% 120% at 50% 38%, #15302a, #0a1714 50%, #060d0b)
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.24),
            radius: 1.3,
            colors: [Color(0xFF15302A), Color(0xFF0A1714), Color(0xFF060D0B)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // faint gold cross-hatch
            const Positioned.fill(child: CustomPaint(painter: _HatchPainter())),

            // centre: mark + name + ayah
            Center(
              child: FadeTransition(
                opacity: _introFade,
                child: ScaleTransition(
                  scale: _introScale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildMark(),
                      const SizedBox(height: 26),
                      Text(
                        "Al-Qur'an Player",
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textPrimary,
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ٱقْرَأْ بِٱسْمِ رَبِّكَ',
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.amiri(
                          color: AppColors.gold,
                          fontSize: 22,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // bottom: loader bar + BISMILLAH
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 56),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 120 x 3 track with an animated gold fill
                    SizedBox(
                      width: 120,
                      height: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ColoredBox(
                                color: Colors.white.withValues(alpha: .1),
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: AnimatedBuilder(
                                  animation: _loader,
                                  builder: (_, _) => FractionallySizedBox(
                                    widthFactor: Curves.easeInOut.transform(
                                      _loader.value,
                                    ),
                                    heightFactor: 1,
                                    child: const DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.goldDeep,
                                            AppColors.gold,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'BISMILLAH',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textFaint,
                        fontSize: 11.5,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 132×132 mark: pulsing emerald disc + inner ring + gold brand glyph.
  Widget _buildMark() {
    return SizedBox(
      width: 132,
      height: 132,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // pulsing disc
          ScaleTransition(
            scale: Tween<double>(
              begin: 1.0,
              end: 1.06,
            ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut)),
            child: FadeTransition(
              opacity: Tween<double>(begin: 1.0, end: 0.85).animate(_pulse),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0x8C1F6F5C), Color(0x330C332B)],
                  ),
                  border: Border.all(color: const Color(0x59E0BE7B)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x80000000),
                      blurRadius: 50,
                      offset: Offset(0, 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // inner ring
          Padding(
            padding: const EdgeInsets.all(14),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x2EE0BE7B)),
              ),
            ),
          ),
          // brand glyph
          const SizedBox(
            width: 70,
            height: 70,
            child: CustomPaint(painter: BrandMarkPainter()),
          ),
        ],
      ),
    );
  }
}

/// Draws the brand mark (mihrab arch + 5 equalizer bars) from the design's
/// SVG, scaled from its 100×100 coordinate space to the given size.
class BrandMarkPainter extends CustomPainter {
  const BrandMarkPainter({this.color = AppColors.gold});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 100.0;

    // Mihrab arch: M28 78 L28 47 Q28 23 50 16 Q72 23 72 47 L72 78
    final arch = Path()
      ..moveTo(28 * s, 78 * s)
      ..lineTo(28 * s, 47 * s)
      ..quadraticBezierTo(28 * s, 23 * s, 50 * s, 16 * s)
      ..quadraticBezierTo(72 * s, 23 * s, 72 * s, 47 * s)
      ..lineTo(72 * s, 78 * s);

    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.4 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(arch, stroke);

    // Equalizer bars (x, y, w, h) in 100-space.
    const bars = [
      [33.5, 58.0, 4.2, 12.0],
      [40.6, 50.0, 4.2, 20.0],
      [47.7, 44.0, 4.2, 26.0],
      [54.8, 50.0, 4.2, 20.0],
      [61.9, 58.0, 4.2, 12.0],
    ];
    final fill = Paint()..color = color;
    for (final b in bars) {
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(b[0] * s, b[1] * s, b[2] * s, b[3] * s),
        Radius.circular(2.1 * s),
      );
      canvas.drawRRect(rect, fill);
    }
  }

  @override
  bool shouldRepaint(covariant BrandMarkPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Faint gold diagonal cross-hatch, matching the splash background pattern
/// (gold at ~5% opacity, ~22px period, both diagonals).
class _HatchPainter extends CustomPainter {
  const _HatchPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE0BE7B).withValues(alpha: 0.05)
      ..strokeWidth = 1;
    const gap = 22.0;
    for (double i = -size.height; i < size.width + size.height; i += gap) {
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
