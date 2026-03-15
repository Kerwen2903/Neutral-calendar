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
      'Gregorian Calendar';
  String get neutralCalendar =>
      _localizedStrings[locale.languageCode]?['neutralCalendar'] ??
      'Neutral Calendar';
  String get comparison =>
      _localizedStrings[locale.languageCode]?['comparison'] ?? 'Comparison';
  String get converter =>
      _localizedStrings[locale.languageCode]?['converter'] ?? 'Converter';
  String get settings =>
      _localizedStrings[locale.languageCode]?['settings'] ?? 'Settings';
  String get lockScreen =>
      _localizedStrings[locale.languageCode]?['lockScreen'] ?? 'Lock Styles';
  String get lockTextVariant =>
      _localizedStrings[locale.languageCode]?['lockTextVariant'] ?? 'Text';
  String get lockTextBoth =>
      _localizedStrings[locale.languageCode]?['lockTextBoth'] ?? 'Both';
  String get lockTextNeutralOnly =>
      _localizedStrings[locale.languageCode]?['lockTextNeutralOnly'] ?? 'Neutral';
  String get lockTextGregorianOnly =>
      _localizedStrings[locale.languageCode]?['lockTextGregorianOnly'] ?? 'Gregorian';
  String get lockTextTimeOnly =>
      _localizedStrings[locale.languageCode]?['lockTextTimeOnly'] ?? 'Time only';
  String get lockFontStyle =>
      _localizedStrings[locale.languageCode]?['lockFontStyle'] ?? 'Font';
  String get lockFontDefault =>
      _localizedStrings[locale.languageCode]?['lockFontDefault'] ?? 'Default';
  String get lockFontSerif =>
      _localizedStrings[locale.languageCode]?['lockFontSerif'] ?? 'Serif';
  String get lockFontMono =>
      _localizedStrings[locale.languageCode]?['lockFontMono'] ?? 'Mono';
  String get language =>
      _localizedStrings[locale.languageCode]?['language'] ?? 'Language';
  String get turkmen => 'Türkmen';
  String get russian => 'Русский';

  // Gregorian Months
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

  // Neutral Calendar Months
  String get adam => _localizedStrings[locale.languageCode]?['adam'] ?? 'Adam';
  String get eve => _localizedStrings[locale.languageCode]?['eve'] ?? 'Eve';
  String get noah => _localizedStrings[locale.languageCode]?['noah'] ?? 'Noah';
  String get abraham =>
      _localizedStrings[locale.languageCode]?['abraham'] ?? 'Abraham';
  String get moses =>
      _localizedStrings[locale.languageCode]?['moses'] ?? 'Moses';
  String get icon => _localizedStrings[locale.languageCode]?['icon'] ?? 'Icon';
  String get ilham =>
      _localizedStrings[locale.languageCode]?['ilham'] ?? 'Ilham';
  String get avesta =>
      _localizedStrings[locale.languageCode]?['avesta'] ?? 'Avesta';
  String get shinto =>
      _localizedStrings[locale.languageCode]?['shinto'] ?? 'Shinto';
  String get aqdas =>
      _localizedStrings[locale.languageCode]?['aqdas'] ?? 'Aqdas';
  String get nirvana =>
      _localizedStrings[locale.languageCode]?['nirvana'] ?? 'Nirvana';
  String get dharma =>
      _localizedStrings[locale.languageCode]?['dharma'] ?? 'Dharma';

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
  String get monthNames =>
      _localizedStrings[locale.languageCode]?['monthNames'] ?? 'Month Names';
  String get gregorianMonths =>
      _localizedStrings[locale.languageCode]?['gregorianMonths'] ?? 'Gregorian';
  String get neutralMonths =>
      _localizedStrings[locale.languageCode]?['neutralMonths'] ?? 'Neutral';
  String get gregorianStyle =>
      _localizedStrings[locale.languageCode]?['gregorianStyle'] ??
      'Gregorian Style';
  String get darkMode =>
      _localizedStrings[locale.languageCode]?['darkMode'] ?? 'Dark Mode';
  String get darkModeOn =>
      _localizedStrings[locale.languageCode]?['darkModeOn'] ?? 'Dark';
  String get lightModeOn =>
      _localizedStrings[locale.languageCode]?['lightModeOn'] ?? 'Light';

  static const Map<String, Map<String, String>> _localizedStrings = {
    'en': {
      'appTitle': 'Neutral Calendar',
      'calendar': 'Neutral Style',
      'normalCalendar': 'Gregorian Calendar',
      'neutralCalendar': 'Neutral Calendar',
      'comparison': 'Combo Style',
      'converter': 'Converter',
      'settings': 'Settings',
      'lockScreen': 'Lock Styles',
      'lockTextVariant': 'Text',
      'lockTextBoth': 'Both',
      'lockTextNeutralOnly': 'Neutral',
      'lockTextGregorianOnly': 'Gregorian',
      'lockTextTimeOnly': 'Time only',
      'lockFontStyle': 'Font',
      'lockFontDefault': 'Default',
      'lockFontSerif': 'Serif',
      'lockFontMono': 'Mono',
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
      'adam': 'Adam',
      'eve': 'Eve',
      'noah': 'Noah',
      'abraham': 'Abraham',
      'moses': 'Moses',
      'icon': 'Icon',
      'ilham': 'Ilham',
      'avesta': 'Avesta',
      'shinto': 'Shinto',
      'aqdas': 'Aqdas',
      'nirvana': 'Nirvana',
      'dharma': 'Dharma',
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
      'monthNames': 'Month Names',
      'gregorianMonths': 'Gregorian',
      'neutralMonths': 'Neutral',
      'gregorianStyle': 'Gregorian Style',
      'darkMode': 'Dark Mode',
      'darkModeOn': 'Dark',
      'lightModeOn': 'Light',
    },
    'ru': {
      'appTitle': 'Нейтральный Календарь',
      'calendar': 'Нейтральный стиль',
      'normalCalendar': 'Григорианский Календарь',
      'neutralCalendar': 'Нейтральный Календарь',
      'comparison': 'Комбинация стилей',
      'converter': 'Конвертер',
      'settings': 'Настройки',
      'lockScreen': 'Стили заставки',
      'lockTextVariant': 'Текст',
      'lockTextBoth': 'Оба',
      'lockTextNeutralOnly': 'Нейтральный',
      'lockTextGregorianOnly': 'Григорианский',
      'lockTextTimeOnly': 'Только время',
      'lockFontStyle': 'Шрифт',
      'lockFontDefault': 'Обычный',
      'lockFontSerif': 'Serif',
      'lockFontMono': 'Моно',
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
      'adam': 'Адам',
      'eve': 'Ева',
      'noah': 'Ной',
      'abraham': 'Авраам',
      'moses': 'Моисей',
      'icon': 'Икона',
      'ilham': 'Ильхам',
      'avesta': 'Авеста',
      'shinto': 'Синто',
      'aqdas': 'Акдас',
      'nirvana': 'Нирвана',
      'dharma': 'Дхарма',
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
      'monthNames': 'Названия месяцев',
      'gregorianMonths': 'Григорианские',
      'neutralMonths': 'Нейтральные',
      'gregorianStyle': 'Григорианский стиль',
      'darkMode': 'Темная тема',
      'darkModeOn': 'Темная',
      'lightModeOn': 'Светлая',
    },
    'tk': {
      'appTitle': 'Bitarap Senenama',
      'calendar': 'Bitarap stil',
      'normalCalendar': 'Grigorian Senenama',
      'neutralCalendar': 'Bitarap Senenama',
      'comparison': 'Stil utgaşmasy',
      'converter': 'Öwürmek',
      'settings': 'Sazlamalar',
      'lockScreen': 'Zasawka stilleri',
      'lockTextVariant': 'Ýazgy',
      'lockTextBoth': 'Ikisi',
      'lockTextNeutralOnly': 'Bitarap',
      'lockTextGregorianOnly': 'Grigorian',
      'lockTextTimeOnly': 'Diňe wagt',
      'lockFontStyle': 'Şrift',
      'lockFontDefault': 'Adaty',
      'lockFontSerif': 'Serif',
      'lockFontMono': 'Mono',
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
      'adam': 'Adam',
      'eve': 'Ewa',
      'noah': 'Nuh',
      'abraham': 'Ybraýym',
      'moses': 'Musa',
      'icon': 'Nyşan',
      'ilham': 'Ylham',
      'avesta': 'Awesta',
      'shinto': 'Şinto',
      'aqdas': 'Agdas',
      'nirvana': 'Nirwana',
      'dharma': 'Dharma',
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
      'monthNames': 'Aý atlary',
      'gregorianMonths': 'Gregorian',
      'neutralMonths': 'Bitarap',
      'gregorianStyle': 'Grigorian stili',
      'darkMode': 'Garaňky tema',
      'darkModeOn': 'Garaňky',
      'lightModeOn': 'Ýagty',
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
