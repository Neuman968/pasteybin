import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/screens/bin_screen.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/screens/main_screen.dart';

const API_HOST = String.fromEnvironment('API_HOST');

const USE_TLS = String.fromEnvironment('USE_TLS') == 'true';

const WS_PROTOCOL = USE_TLS ? 'wss' : 'ws';

const HTTP_PROTOCOL = USE_TLS ? 'https' : 'http';

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
      path: '/bin/:binId',
      builder: (BuildContext context, GoRouterState state) {
        return BinScreen(binId: state.pathParameters['binId']!);
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
          ),
        ),
      ),
      routerConfig: _router,
      themeMode: ThemeMode.dark,
    );
  }
}
