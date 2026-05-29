import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/router/route_structure.dart';
import '../../../surah_list/domain/entities/surah.dart';
import '../../../surah_list/presentation/widgets/surah_row.dart';
import '../bloc/search_bloc.dart';

/// Search screen — filters surahs by title, meaning, Arabic name, or reciter.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key, this.allSurahs});

  final List<Surah>? allSurahs;

  static const RouteStructure route = .new(path: '/search', name: 'search');

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchCont = TextEditingController();
  final FocusNode focusNodeText = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => focusNodeText.requestFocus(),
    );
  }

  @override
  void dispose() {
    searchCont.dispose();
    focusNodeText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SearchBloc>(),
      child: Builder(
        builder: (context) {
          if (widget.allSurahs != null) {
            context.read<SearchBloc>().add(
              SearchSurahsLoaded(widget.allSurahs ?? []),
            );
          }
          return Scaffold(
            backgroundColor: AppColors.bg1,
            body: SafeArea(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //  Search input row
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: AppColors.surfaceBorder,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.search_rounded,
                                      color: AppColors.gold,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        controller: searchCont,
                                        focusNode: focusNodeText,
                                        onChanged: (q) => context
                                            .read<SearchBloc>()
                                            .add(SearchQueryChanged(q)),
                                        style: GoogleFonts.plusJakartaSans(
                                          color: AppColors.textPrimary,
                                          fontSize: 15.5,
                                        ),
                                        decoration: InputDecoration(
                                          hintText:
                                              'Judul surah atau nama qari…',
                                          hintStyle:
                                              GoogleFonts.plusJakartaSans(
                                                color: AppColors.textMuted,
                                                fontSize: 15.5,
                                              ),
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                    if (searchCont.text.isNotEmpty)
                                      GestureDetector(
                                        onTap: () {
                                          searchCont.clear();
                                          context.read<SearchBloc>().add(
                                            const SearchQueryChanged(''),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.close_rounded,
                                          color: AppColors.textMuted,
                                          size: 18,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: context.pop,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: Text(
                                  'Batal',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.gold,
                                    fontSize: 15.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //  Result count label
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 6,
                        ),
                        child: Text(
                          state.query.isEmpty
                              ? 'Semua surah'
                              : '${state.results.length} hasil untuk '
                                    '"${state.query.trim()}"',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.textFaint,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      //  Results list
                      Expanded(
                        child: state.results.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Text(
                                    'Tidak ditemukan.\nCoba kata kunci lain\n'
                                    '(mis. "Yaseen", "Rahmaan", "Alafasy").',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textMuted,
                                      fontSize: 14.5,
                                      height: 1.6,
                                    ),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.only(bottom: 120),
                                itemCount: state.results.length,
                                itemBuilder: (context, i) {
                                  final surah = state.results[i];

                                  return SurahRow(surah: surah, onTap: () {});
                                },
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
