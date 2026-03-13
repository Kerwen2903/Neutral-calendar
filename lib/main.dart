import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations_manual.dart';
import 'screens/home_screen.dart';
import 'screens/lock_screen.dart';

void main() {
  runApp(const NeutralCalendarApp());
}

/// Falls back to Russian Material localisations for Turkmen
/// because [GlobalMaterialLocalizations] has no Turkmen bundle.
class _MaterialFallbackDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _MaterialFallbackDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    final effective =
        locale.languageCode == 'tk' ? const Locale('ru') : locale;
    return GlobalMaterialLocalizations.delegate.load(effective);
  }

  @override
  bool shouldReload(_MaterialFallbackDelegate old) => false;
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
  int _lockScreenColorIndex = 0; // 0=navy, 1=crimson, 2=black

  Locale get selectedLocale => _locale;
  int get lockScreenColorIndex => _lockScreenColorIndex;

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

  void setLockScreenColor(int index) {
    setState(() {
      _lockScreenColorIndex = index;
    });
  }

  bool get useNeutralMonthNames => _useNeutralMonthNames;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neutral Calendar',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        _MaterialFallbackDelegate(),   // maps tk → ru for Material widgets
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales, // en, ru, tk
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

// Simple wrapper – no Localizations.override needed now that MaterialApp
// properly loads AppLocalizations with the real locale (including 'tk').
class _LocalizedHome extends StatelessWidget {
  final Locale selectedLocale;

  const _LocalizedHome({required this.selectedLocale});

  @override
  Widget build(BuildContext context) {
    return LockScreen(child: const HomeScreen());
  }
}
