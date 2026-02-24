import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations_manual.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const NeutralCalendarApp());
}

class NeutralCalendarApp extends StatefulWidget {
  const NeutralCalendarApp({super.key});

  @override
  State<NeutralCalendarApp> createState() => _NeutralCalendarAppState();

  static _NeutralCalendarAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_NeutralCalendarAppState>();
  }
}

class _NeutralCalendarAppState extends State<NeutralCalendarApp> {
  Locale _locale = const Locale('ru'); // Default to Russian
  bool _useNeutralMonthNames = true; // Default to Neutral month names
  ThemeMode _themeMode = ThemeMode.light; // Default to light theme

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void toggleMonthNames(bool useNeutral) {
    setState(() {
      _useNeutralMonthNames = useNeutral;
    });
  }

  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  bool get useNeutralMonthNames => _useNeutralMonthNames;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    // For Turkmen locale, use Russian for Material widgets
    // since GlobalMaterialLocalizations doesn't support Turkmen
    final materialLocale = _locale.languageCode == 'tk'
        ? const Locale('ru')
        : _locale;

    return MaterialApp(
      title: 'Neutral Calendar',
      debugShowCheckedModeBanner: false,
      locale: materialLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ru')],
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF146B5D),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF146B5D),
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      home: _LocalizedHome(selectedLocale: _locale),
    );
  }
}

// Wrapper widget to provide Turkmen localizations when needed
class _LocalizedHome extends StatelessWidget {
  final Locale selectedLocale;

  const _LocalizedHome({required this.selectedLocale});

  @override
  Widget build(BuildContext context) {
    // If Turkmen is selected, override with Turkmen AppLocalizations
    // while Material widgets use Russian (already set in MaterialApp)
    if (selectedLocale.languageCode == 'tk') {
      return Localizations.override(
        context: context,
        locale: const Locale('tk'),
        delegates: const [AppLocalizations.delegate],
        child: const HomeScreen(),
      );
    }
    return const HomeScreen();
  }
}
