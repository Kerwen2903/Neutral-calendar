import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations_manual.dart';
import 'screens/home_screen.dart';
import 'screens/lock_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(NeutralCalendarApp(prefs: prefs));
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
  final SharedPreferences prefs;
  const NeutralCalendarApp({super.key, required this.prefs});

  @override
  State<NeutralCalendarApp> createState() => _NeutralCalendarAppState();

  static _NeutralCalendarAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_NeutralCalendarAppState>();
  }
}

class _NeutralCalendarAppState extends State<NeutralCalendarApp> {
  late Locale _locale;
  late bool _useNeutralMonthNames;
  late bool _useAllChristianCombo;
  late ThemeMode _themeMode;
  late int _lockScreenColorIndex;
  late int _lockScreenTextVariant;
  late int _lockScreenFontStyle; // 0=default, 1=serif, 2=monospace
  late int _lockScreenBgImage; // -1=solid color, 0+=image index, -2=custom gallery image
  String? _lockScreenCustomImage; // file path from gallery

  SharedPreferences get _prefs => widget.prefs;

  @override
  void initState() {
    super.initState();
    _locale = Locale(_prefs.getString('locale') ?? 'ru');
    _useNeutralMonthNames = _prefs.getBool('useNeutralMonthNames') ?? true;
    _useAllChristianCombo = _prefs.getBool('useAllChristianCombo') ?? false;
    _themeMode = (_prefs.getBool('isDarkMode') ?? false)
        ? ThemeMode.dark
        : ThemeMode.light;
    _lockScreenColorIndex = _prefs.getInt('lockScreenColorIndex') ?? 0;
    _lockScreenTextVariant = _prefs.getInt('lockScreenTextVariant') ?? 0;
    _lockScreenFontStyle = _prefs.getInt('lockScreenFontStyle') ?? 0;
    _lockScreenBgImage = _prefs.getInt('lockScreenBgImage') ?? -1;
    _lockScreenCustomImage = _prefs.getString('lockScreenCustomImage');
  }

  Locale get selectedLocale => _locale;
  int get lockScreenColorIndex => _lockScreenColorIndex;
  int get lockScreenTextVariant => _lockScreenTextVariant;
  int get lockScreenFontStyle => _lockScreenFontStyle;
  int get lockScreenBgImage => _lockScreenBgImage;
  String? get lockScreenCustomImage => _lockScreenCustomImage;

  void setLocale(Locale locale) {
    setState(() { _locale = locale; });
    _prefs.setString('locale', locale.languageCode);
  }

  void toggleMonthNames(bool useNeutral) {
    setState(() { _useNeutralMonthNames = useNeutral; });
    _prefs.setBool('useNeutralMonthNames', useNeutral);
  }

  void setComboCalendarMode(bool useAllChristian) {
    setState(() { _useAllChristianCombo = useAllChristian; });
    _prefs.setBool('useAllChristianCombo', useAllChristian);
  }

  void toggleTheme(bool isDark) {
    setState(() { _themeMode = isDark ? ThemeMode.dark : ThemeMode.light; });
    _prefs.setBool('isDarkMode', isDark);
  }

  void setLockScreenColor(int index) {
    setState(() { _lockScreenColorIndex = index; });
    _prefs.setInt('lockScreenColorIndex', index);
  }

  void setLockScreenTextVariant(int index) {
    setState(() { _lockScreenTextVariant = index; });
    _prefs.setInt('lockScreenTextVariant', index);
  }

  void setLockScreenFontStyle(int index) {
    setState(() { _lockScreenFontStyle = index; });
    _prefs.setInt('lockScreenFontStyle', index);
  }

  void setLockScreenBgImage(int index) {
    setState(() { _lockScreenBgImage = index; });
    _prefs.setInt('lockScreenBgImage', index);
  }

  void setLockScreenCustomImage(String? path) {
    setState(() {
      _lockScreenCustomImage = path;
      if (path != null) {
        _lockScreenBgImage = -2; // -2 = custom gallery image
      }
    });
    if (path != null) {
      _prefs.setString('lockScreenCustomImage', path);
    } else {
      _prefs.remove('lockScreenCustomImage');
    }
    _prefs.setInt('lockScreenBgImage', _lockScreenBgImage);
  }

  bool get useNeutralMonthNames => _useNeutralMonthNames;
  bool get useAllChristianCombo => _useAllChristianCombo;
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
        ).copyWith(
          primaryContainer: Colors.white,
          onPrimaryContainer: Colors.black87,
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
