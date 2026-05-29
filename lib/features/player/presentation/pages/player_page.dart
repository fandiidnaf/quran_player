import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/route_structure.dart';
import '../bloc/player_bloc.dart';
import '../widgets/artwork_widget.dart';
import '../widgets/seek_bar.dart';

/// Full-screen "Now Playing" overlay.
/// Slides up from the bottom (modal route).
class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  static const RouteStructure route = .new(path: '/player', name: 'player');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        if (state.currentSurah == null) {
          return const SizedBox.shrink();
        }

        final surah = state.currentSurah!;
        final colors = AppColors.coverFor(surah.number);

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [colors.first, AppColors.bg1, AppColors.bg2],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // ── Top bar ─────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: context.pop,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          color: AppColors.textPrimary,
                          iconSize: 32,
                        ),
                        Column(
                          children: [
                            Text(
                              'SEDANG DIPUTAR',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textMuted,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.4,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              surah.revelationType,
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        // Spacer to keep the title block centered
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),

                  // ── Artwork ─────────────────────────────────
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(28, 8, 28, 8),
                      child: ArtworkWidget(surah: surah),
                    ),
                  ),

                  // ── Meta + controls ──────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(26, 0, 26, 24),
                    child: Column(
                      children: [
                        // Title block (full-width, left-aligned)
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                surah.latinName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.textPrimary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${surah.reciterName} · ${surah.ayahCount} ayat',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.textMuted,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ── Seek bar ──────────────────────────
                        SeekBar(
                          position: state.position,
                          duration: state.duration,
                          onSeek: (pos) =>
                              context.read<PlayerBloc>().add(SeekEvent(pos)),
                        ),

                        const SizedBox(height: 14),

                        // ── Playback controls ────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Shuffle
                            IconButton(
                              onPressed: () => context.read<PlayerBloc>().add(
                                ToggleShuffleEvent(),
                              ),
                              icon: const Icon(Icons.shuffle_rounded),
                              color: state.isShuffle
                                  ? AppColors.gold
                                  : AppColors.textMuted,
                              iconSize: 22,
                            ),
                            // Previous
                            IconButton(
                              onPressed: () => context.read<PlayerBloc>().add(
                                PrevSurahEvent(),
                              ),
                              icon: const Icon(Icons.skip_previous_rounded),
                              color: AppColors.textPrimary,
                              iconSize: 36,
                            ),
                            // Play / Pause — gold circular button
                            GestureDetector(
                              onTap: () => context.read<PlayerBloc>().add(
                                TogglePlayEvent(),
                              ),
                              child: Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.gold,
                                      AppColors.goldDeep,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.gold.withValues(
                                        alpha: .4,
                                      ),
                                      blurRadius: 26,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: _buildPlayPauseIcon(state),
                              ),
                            ),
                            // Next
                            IconButton(
                              onPressed: () => context.read<PlayerBloc>().add(
                                NextSurahEvent(),
                              ),
                              icon: const Icon(Icons.skip_next_rounded),
                              color: AppColors.textPrimary,
                              iconSize: 36,
                            ),
                            // Repeat
                            IconButton(
                              onPressed: () => context.read<PlayerBloc>().add(
                                ToggleRepeatEvent(),
                              ),
                              icon: const Icon(Icons.repeat_rounded),
                              color: state.isRepeat
                                  ? AppColors.gold
                                  : AppColors.textMuted,
                              iconSize: 22,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlayPauseIcon(PlayerState state) {
    if (state.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: CircularProgressIndicator(
          color: Color(0xFF1A1208),
          strokeWidth: 2.5,
        ),
      );
    }
    return Icon(
      state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
      color: const Color(0xFF1A1208),
      size: 34,
    );
  }
}
