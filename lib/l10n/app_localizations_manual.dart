import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ru'),
    Locale('tk'),
  ];

  // App strings
  String get appTitle =>
      _localizedStrings[locale.languageCode]?['appTitle'] ?? 'Neutral Calendar';
  String get calendar =>
      _localizedStrings[locale.languageCode]?['calendar'] ?? 'Calendar';
  String get normalCalendar =>
      _localizedStrings[locale.languageCode]?['normalCalendar'] ??
      'Normal Calendar';
  String get neutralCalendar =>
      _localizedStrings[locale.languageCode]?['neutralCalendar'] ??
      'Neutral Calendar';
  String get comparison =>
      _localizedStrings[locale.languageCode]?['comparison'] ?? 'Comparison';
  String get converter =>
      _localizedStrings[locale.languageCode]?['converter'] ?? 'Converter';
  String get settings =>
      _localizedStrings[locale.languageCode]?['settings'] ?? 'Settings';
  String get language =>
      _localizedStrings[locale.languageCode]?['language'] ?? 'Language';
  String get turkmen => 'Türkmen';
  String get russian => 'Русский';

  // Months
  String get january =>
      _localizedStrings[locale.languageCode]?['january'] ?? 'January';
  String get february =>
      _localizedStrings[locale.languageCode]?['february'] ?? 'February';
  String get march =>
      _localizedStrings[locale.languageCode]?['march'] ?? 'March';
  String get april =>
      _localizedStrings[locale.languageCode]?['april'] ?? 'April';
  String get may => _localizedStrings[locale.languageCode]?['may'] ?? 'May';
  String get june => _localizedStrings[locale.languageCode]?['june'] ?? 'June';
  String get july => _localizedStrings[locale.languageCode]?['july'] ?? 'July';
  String get august =>
      _localizedStrings[locale.languageCode]?['august'] ?? 'August';
  String get september =>
      _localizedStrings[locale.languageCode]?['september'] ?? 'September';
  String get october =>
      _localizedStrings[locale.languageCode]?['october'] ?? 'October';
  String get november =>
      _localizedStrings[locale.languageCode]?['november'] ?? 'November';
  String get december =>
      _localizedStrings[locale.languageCode]?['december'] ?? 'December';

  // Weekdays
  String get monday =>
      _localizedStrings[locale.languageCode]?['monday'] ?? 'Mon';
  String get tuesday =>
      _localizedStrings[locale.languageCode]?['tuesday'] ?? 'Tue';
  String get wednesday =>
      _localizedStrings[locale.languageCode]?['wednesday'] ?? 'Wed';
  String get thursday =>
      _localizedStrings[locale.languageCode]?['thursday'] ?? 'Thu';
  String get friday =>
      _localizedStrings[locale.languageCode]?['friday'] ?? 'Fri';
  String get saturday =>
      _localizedStrings[locale.languageCode]?['saturday'] ?? 'Sat';
  String get sunday =>
      _localizedStrings[locale.languageCode]?['sunday'] ?? 'Sun';

  // Actions
  String get convertDate =>
      _localizedStrings[locale.languageCode]?['convertDate'] ?? 'Convert Date';
  String get selectDate =>
      _localizedStrings[locale.languageCode]?['selectDate'] ?? 'Select Date';
  String get today =>
      _localizedStrings[locale.languageCode]?['today'] ?? 'Today';
  String get leapYear =>
      _localizedStrings[locale.languageCode]?['leapYear'] ?? 'Leap Year';
  String get specialDay =>
      _localizedStrings[locale.languageCode]?['specialDay'] ?? 'Special Day';
  String get from => _localizedStrings[locale.languageCode]?['from'] ?? 'From';
  String get aboutCalendar =>
      _localizedStrings[locale.languageCode]?['aboutCalendar'] ??
      'About Neutral Calendar';
  String get howToUse =>
      _localizedStrings[locale.languageCode]?['howToUse'] ?? 'How to use';

  static const Map<String, Map<String, String>> _localizedStrings = {
    'en': {
      'appTitle': 'Neutral Calendar',
      'calendar': 'Calendar',
      'normalCalendar': 'Normal Calendar',
      'neutralCalendar': 'Neutral Calendar',
      'comparison': 'Comparison',
      'converter': 'Converter',
      'settings': 'Settings',
      'language': 'Language',
      'january': 'January',
      'february': 'February',
      'march': 'March',
      'april': 'April',
      'may': 'May',
      'june': 'June',
      'july': 'July',
      'august': 'August',
      'september': 'September',
      'october': 'October',
      'november': 'November',
      'december': 'December',
      'monday': 'Mon',
      'tuesday': 'Tue',
      'wednesday': 'Wed',
      'thursday': 'Thu',
      'friday': 'Fri',
      'saturday': 'Sat',
      'sunday': 'Sun',
      'convertDate': 'Convert Date',
      'selectDate': 'Select Date',
      'today': 'Today',
      'leapYear': 'Leap Year',
      'specialDay': 'Special Day',
      'from': 'From',
      'aboutCalendar': 'About Neutral Calendar',
      'howToUse': 'How to use',
    },
    'ru': {
      'appTitle': 'Нейтральный Календарь',
      'calendar': 'Календарь',
      'normalCalendar': 'Обычный Календарь',
      'neutralCalendar': 'Нейтральный Календарь',
      'comparison': 'Сравнение',
      'converter': 'Конвертер',
      'settings': 'Настройки',
      'language': 'Язык',
      'january': 'Январь',
      'february': 'Февраль',
      'march': 'Март',
      'april': 'Апрель',
      'may': 'Май',
      'june': 'Июнь',
      'july': 'Июль',
      'august': 'Август',
      'september': 'Сентябрь',
      'october': 'Октябрь',
      'november': 'Ноябрь',
      'december': 'Декабрь',
      'monday': 'Пн',
      'tuesday': 'Вт',
      'wednesday': 'Ср',
      'thursday': 'Чт',
      'friday': 'Пт',
      'saturday': 'Сб',
      'sunday': 'Вс',
      'convertDate': 'Конвертировать дату',
      'selectDate': 'Выбрать дату',
      'today': 'Сегодня',
      'leapYear': 'Високосный год',
      'specialDay': 'Особый день',
      'from': 'От',
      'aboutCalendar': 'О Нейтральном Календаре',
      'howToUse': 'Как использовать',
    },
    'tk': {
      'appTitle': 'Bitarap Senenama',
      'calendar': 'Senenama',
      'normalCalendar': 'Adaty Senenama',
      'neutralCalendar': 'Bitarap Senenama',
      'comparison': 'Deňeşdirmek',
      'converter': 'Öwürmek',
      'settings': 'Sazlamalar',
      'language': 'Dil',
      'january': 'Ýanwar',
      'february': 'Fewral',
      'march': 'Mart',
      'april': 'Aprel',
      'may': 'Maý',
      'june': 'Iýun',
      'july': 'Iýul',
      'august': 'Awgust',
      'september': 'Sentýabr',
      'october': 'Oktýabr',
      'november': 'Noýabr',
      'december': 'Dekabr',
      'monday': 'Duş',
      'tuesday': 'Siş',
      'wednesday': 'Çar',
      'thursday': 'Pen',
      'friday': 'Ann',
      'saturday': 'Şen',
      'sunday': 'Ýek',
      'convertDate': 'Senäni öwürmek',
      'selectDate': 'Senäni saýla',
      'today': 'Şu gün',
      'leapYear': 'Artykmaç ýyl',
      'specialDay': 'Aýratyn gün',
      'from': 'Dan',
      'aboutCalendar': 'Bitarap Senenama barada',
      'howToUse': 'Nädip ulanmaly',
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ru', 'tk'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
