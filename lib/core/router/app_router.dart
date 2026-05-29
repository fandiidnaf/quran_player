import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/player/presentation/pages/player_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/surah_list/domain/entities/surah.dart';
import '../../features/surah_list/presentation/pages/home_page.dart';

class AppRouter {
  const AppRouter._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: navigatorKey,
    debugLogDiagnostics: kDebugMode,
    routes: [
      // home page
      GoRoute(
        path: HomePage.route.path,
        name: HomePage.route.name,
        builder: (context, state) => HomePage(),
      ),

      // search page
      GoRoute(
        path: SearchPage.route.path,
        name: SearchPage.route.name,
        builder: (context, state) =>
            SearchPage(allSurahs: state.extra as List<Surah>?),
      ),

      // player page
      GoRoute(
        path: PlayerPage.route.path,
        name: PlayerPage.route.name,
        pageBuilder: (context, state) => CustomTransitionPage(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 380),
          reverseTransitionDuration: const Duration(milliseconds: 280),
          child: PlayerPage(),
        ),
      ),
    ],
  );
}
