import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/router/route_structure.dart';
import '../../../search/presentation/pages/search_page.dart';
import '../../domain/entities/surah.dart';
import '../bloc/surah_list_bloc.dart';
import '../widgets/surah_row.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const RouteStructure route = .new(path: '/', name: 'home');

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SurahListBloc>()..add(const LoadSurahs()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.bg1,

            body: BlocBuilder<SurahListBloc, SurahListState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    // main scrollable content
                    _buildBody(context, state),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, SurahListState state) {
    return CustomScrollView(
      slivers: [
        SliverSafeArea(
          sliver: SliverToBoxAdapter(child: _buildHeader(context)),
        ),
        // Search bar
        SliverToBoxAdapter(child: _buildSearchBar(context)),

        // Section header
        if (state is SurahListLoaded)
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
                    '${state.surahs.length} surah',
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
        _buildSurahList(context, state),
        // Bottom padding for mini-player
        const SliverToBoxAdapter(child: SizedBox(height: 140)),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
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
            onTap: () {},
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

  Widget _buildSurahList(BuildContext context, SurahListState state) {
    if (state is SurahListLoading) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator(color: AppColors.gold)),
      );
    }

    if (state is SurahListError) {
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
                state.message,
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

    if (state is SurahListLoaded) {
      final List<Surah> surahs = state.surahs;
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => SurahRow(surah: surahs[i], onTap: () {}),
          childCount: surahs.length,
        ),
      );
    }

    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}
