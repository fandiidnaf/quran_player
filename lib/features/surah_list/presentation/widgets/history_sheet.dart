import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../player/presentation/bloc/player_bloc.dart';
import '../../domain/entities/surah.dart';
import 'surah_row.dart';

class HistorySheet extends StatelessWidget {
  final List<Surah> surahs;
  final List<int> history;
  final int? currentSurahNumber;
  final bool isPlaying;

  const HistorySheet({
    super.key,
    required this.surahs,
    required this.history,
    required this.currentSurahNumber,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Drag handle
        Container(
          margin: const EdgeInsets.only(top: 10),
          width: 38,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .22),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Riwayat dengar',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textPrimary,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Surah yang baru saja diputar',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textFaint,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: context.pop,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surface,
                    border: Border.all(color: AppColors.surfaceBorder),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textMuted,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 400),
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: history.length,
            itemBuilder: (context, i) {
              final Surah surah = surahs[history[i]];
              return SurahRow(
                surah: surah,
                isCurrent: surah.number == currentSurahNumber,
                isPlaying: isPlaying,
                onTap: () {
                  context.read<PlayerBloc>().add(
                    PlaySurahEvent(surahs: surahs, index: history[i]),
                  );
                  context.pop();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
