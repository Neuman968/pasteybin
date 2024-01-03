import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/screens/bin_screen.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/screens/main_screen.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;

Future<String> API_HOST = getOrigin();

bool USE_TLS = html.window.location.href.startsWith('https') == true;

String WS_PROTOCOL = USE_TLS ? 'wss' : 'ws';

String HTTP_PROTOCOL = USE_TLS ? 'https' : 'http';

Future<String> getOrigin () async {

  print('Pringint location host!');
  print(html.window.location.host);
  final response = await http.get(Uri.parse('$HTTP_PROTOCOL://${html.window.location.host}/apihost'));
  if (response.statusCode == 200 && response.body.startsWith('<') == false) {
    return response.body;
  }
  return 'localhost:8080';
}

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
