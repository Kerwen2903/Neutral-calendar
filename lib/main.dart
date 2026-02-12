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

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neutral Calendar',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ru'), Locale('tk')],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF146B5D),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      home: const HomeScreen(),
    );
  }
}
