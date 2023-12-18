import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/screens/main_screen.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

final darkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 161, 215, 192));

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MainScreen();
      },
    ),
    GoRoute(
      path: '/hi/:path',
      builder: (BuildContext context, GoRouterState state) {
        return Text("Hello!! ${state.pathParameters['path']}");
      },
    ),
  ],
);

void main() {
  usePathUrlStrategy();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      darkTheme: ThemeData.dark().copyWith(
          colorScheme: darkColorScheme,
          cardTheme: const CardTheme(
              margin: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ))),
      routerConfig: _router,
      themeMode: ThemeMode.dark,
    );
  }
}
