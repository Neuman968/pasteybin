import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/screens/main_screen.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

final darkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 161, 215, 192));

final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 131, 57, 0),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() {
  usePathUrlStrategy();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
          colorScheme: darkColorScheme,
          cardTheme: const CardTheme(
              margin: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ))),
      home: Navigator(
        pages: [
         const MaterialPage(
            key: const ValueKey('Home Page'),
            child: const MainScreen(),
          )
        ],
        onPopPage: (route, result) => route.didPop(result),
      ),
      themeMode: ThemeMode.dark,
    );
  }
}
