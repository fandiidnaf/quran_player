import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../surah_list/presentation/widgets/cover_widget.dart';
import '../bloc/player_bloc.dart';
import '../pages/player_page.dart';

/// Persistent mini-player bar shown at the bottom of every screen
/// when a surah is loaded but the full player is not open.
class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      buildWhen: (prev, curr) =>
          prev.currentSurah != curr.currentSurah ||
          prev.isPlaying != curr.isPlaying ||
          prev.position != curr.position ||
          prev.duration != curr.duration,
      builder: (context, state) {
        if (state.currentSurah == null) return const SizedBox.shrink();

        final surah = state.currentSurah!;
        final pct = state.duration.inMilliseconds > 0
            ? (state.position.inMilliseconds / state.duration.inMilliseconds)
                  .clamp(0.0, 1.0)
            : 0.0;

        return GestureDetector(
          onTap: () => context.pushNamed(PlayerPage.route.name),
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 12),
            decoration: BoxDecoration(
              color: const Color(0xD014221E), // rgba(20,34,30,0.82)
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.surfaceBorder),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x73000000),
                  blurRadius: 30,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 9, 12, 9),
                      child: Row(
                        children: [
                          CoverWidget(surah: surah, size: 44, radius: 11),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  surah.latinName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  surah.reciterName,
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
                          const SizedBox(width: 8),
                          // Play / pause button
                          GestureDetector(
                            onTap: () => context.read<PlayerBloc>().add(
                              TogglePlayEvent(),
                            ),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.surface,
                              ),
                              child: Icon(
                                state.isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: AppColors.gold,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Thin progress bar at the bottom
                    Container(
                      height: 2.5,
                      margin: const EdgeInsets.fromLTRB(14, 0, 14, 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: pct,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
