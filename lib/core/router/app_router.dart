import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    ],
  );
}
