import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/router/route_structure.dart';
import '../../domain/entities/surah.dart';
import '../../../player/presentation/bloc/player_bloc.dart';
import '../../../player/presentation/pages/player_page.dart';
import '../../../player/presentation/widgets/mini_player.dart';
import '../../../search/presentation/pages/search_page.dart';
import '../bloc/surah_list_bloc.dart';
import '../widgets/featured_card.dart';
import '../widgets/history_sheet.dart';
import '../widgets/surah_row.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const RouteStructure route = .new(path: '/', name: 'home');

  void _showHistory(
    BuildContext context,
    PlayerState playerState,
    List<Surah> surahs,
  ) {
    if (playerState.history.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Belum ada riwayat. Putar sebuah surah terlebih dahulu.',
            style: GoogleFonts.plusJakartaSans(),
          ),
          // backgroundColor: const Color(0xFF12211D),
          backgroundColor: AppColors.gold,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF12211D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (sheetCtx) {
        return BlocProvider.value(
          value: context.read<PlayerBloc>(),
          child: HistorySheet(
            surahs: surahs,
            history: playerState.history,
            currentSurahNumber: playerState.currentSurah?.number,
            isPlaying: playerState.isPlaying,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SurahListBloc>()..add(const LoadSurahs()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.bg1,
            body: BlocBuilder<SurahListBloc, SurahListState>(
              builder: (context, listState) {
                return BlocBuilder<PlayerBloc, PlayerState>(
                  builder: (context, playerState) {
                    return Stack(
                      children: [
                        _buildBody(context, listState, playerState),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: playerState.currentSurah != null
                              ? const MiniPlayer()
                              : const SizedBox.shrink(),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    SurahListState listState,
    PlayerState playerState,
  ) {
    return CustomScrollView(
      slivers: [
        SliverSafeArea(
          sliver: SliverToBoxAdapter(child: _buildHeader(context, playerState)),
        ),
        // Search bar
        SliverToBoxAdapter(child: _buildSearchBar(context)),
        // Featured card
        if (listState is SurahListLoaded || playerState.currentSurah != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 4),
              child: _buildFeatured(context, listState, playerState),
            ),
          ),
        // Section header
        if (listState is SurahListLoaded)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daftar Surah',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${listState.surahs.length} surah',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textFaint,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        // Surah list
        _buildSurahList(context, listState, playerState),
        // Bottom padding for mini-player
        const SliverToBoxAdapter(child: SizedBox(height: 140)),
      ],
    );
  }

  //  Header
  Widget _buildHeader(BuildContext context, PlayerState playerState) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Assalamu'alaikum",
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textMuted,
                  fontSize: 13,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Al-Qur'an Player",
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          // History clock button
          GestureDetector(
            onTap: () {
              final surahs = context.read<SurahListBloc>().state;
              if (surahs is SurahListLoaded) {
                _showHistory(context, playerState, surahs.surahs);
              }
            },
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: const Icon(
                Icons.access_time_rounded,
                color: AppColors.gold,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
      child: GestureDetector(
        onTap: () {
          final SurahListState listState = context.read<SurahListBloc>().state;

          context.pushNamed(
            SearchPage.route.name,
            extra: listState is SurahListLoaded ? listState.surahs : null,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.surfaceBorder),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.search_rounded,
                color: AppColors.textMuted,
                size: 19,
              ),
              const SizedBox(width: 11),
              Text(
                'Cari surah atau qari…',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textMuted,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  Featured card
  Widget _buildFeatured(
    BuildContext context,
    SurahListState listState,
    PlayerState playerState,
  ) {
    final Surah? displaySurah =
        playerState.currentSurah ??
        (listState is SurahListLoaded ? listState.surahs[2] : null);

    if (displaySurah == null) return const SizedBox.shrink();

    final bool hasHistory = playerState.currentSurah != null;

    return FeaturedCard(
      surah: displaySurah,
      isPlaying: playerState.isPlaying && hasHistory,
      hasHistory: hasHistory,
      onTap: () {
        if (hasHistory) {
          context.pushNamed(PlayerPage.route.name);
        } else if (listState is SurahListLoaded) {
          context.read<PlayerBloc>().add(
            PlaySurahEvent(surahs: listState.surahs, index: 2),
          );
        }
      },
    );
  }

  //  Surah list
  Widget _buildSurahList(
    BuildContext context,
    SurahListState listState,
    PlayerState playerState,
  ) {
    if (listState is SurahListLoading) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator(color: AppColors.gold)),
      );
    }

    if (listState is SurahListError) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                color: AppColors.textMuted,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                listState.message,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () =>
                    context.read<SurahListBloc>().add(const LoadSurahs()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: const Color(0xFF1A1208),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Coba lagi',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (listState is SurahListLoaded) {
      final surahs = listState.surahs;
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => SurahRow(
            surah: surahs[i],
            isCurrent: playerState.currentSurah?.number == surahs[i].number,
            isPlaying: playerState.isPlaying,
            onTap: () => context.read<PlayerBloc>().add(
              PlaySurahEvent(surahs: surahs, index: i),
            ),
          ),
          childCount: surahs.length,
        ),
      );
    }

    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}
