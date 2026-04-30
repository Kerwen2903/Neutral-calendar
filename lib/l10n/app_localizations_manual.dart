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
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
    Locale('de'),
    Locale('it'),
    Locale('tr'),
    Locale('vi'),
    Locale('id'),
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
      _localizedStrings[locale.languageCode]?['lockTextVariant'] ?? 'Lock screen style';
  String get lockTextBoth =>
      _localizedStrings[locale.languageCode]?['lockTextBoth'] ?? 'All styles';
  String get lockImageLabel =>
      _localizedStrings[locale.languageCode]?['lockImageLabel'] ??
      'Images for lockscreen';
  String get lockTextNeutralOnly =>
      _localizedStrings[locale.languageCode]?['lockTextNeutralOnly'] ??
      'Neutral';
  String get lockTextGregorianOnly =>
      _localizedStrings[locale.languageCode]?['lockTextGregorianOnly'] ??
      'Gregorian';
  String get lockTextTimer =>
      _localizedStrings[locale.languageCode]?['lockTextTimer'] ??
      'Timer';
  String get lockTextStopwatch =>
      _localizedStrings[locale.languageCode]?['lockTextStopwatch'] ??
      'Stopwatch';
  String get lockFontStyle =>
      _localizedStrings[locale.languageCode]?['lockFontStyle'] ?? 'Lock screen font';
  String get lockFontDefault =>
      _localizedStrings[locale.languageCode]?['lockFontDefault'] ?? 'Default';
  String get lockFontSerif =>
      _localizedStrings[locale.languageCode]?['lockFontSerif'] ?? 'Serif';
  String get lockFontMono =>
      _localizedStrings[locale.languageCode]?['lockFontMono'] ?? 'Mono';
  String get lockColorLabel =>
      _localizedStrings[locale.languageCode]?['lockColorLabel'] ?? 'Lock screen color';
  String get lockScreenChanged =>
      _localizedStrings[locale.languageCode]?['lockScreenChanged'] ??
      'Lock screen updated — tap to preview';
  String get preview =>
      _localizedStrings[locale.languageCode]?['preview'] ?? 'Preview';
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
  String get leapDay =>
      _localizedStrings[locale.languageCode]?['leapDay'] ?? 'Leap day ✦';
  String get leapDayShort =>
      _localizedStrings[locale.languageCode]?['leapDayShort'] ?? 'Leap ✦';
  String get specialDay =>
      _localizedStrings[locale.languageCode]?['specialDay'] ?? 'Special Day';
  String get from => _localizedStrings[locale.languageCode]?['from'] ?? 'From';
  String get aboutCalendar =>
      _localizedStrings[locale.languageCode]?['aboutCalendar'] ??
      'About Neutral Calendar';
  String get howToUse =>
      _localizedStrings[locale.languageCode]?['howToUse'] ?? 'How to use';
  String get aboutReformCalendar =>
      _localizedStrings[locale.languageCode]?['aboutReformCalendar'] ??
      'About Reform Calendar';
  String get aboutCalendarText =>
      _localizedStrings[locale.languageCode]?['aboutCalendarText'] ?? '';
  String get aboutReformCalendarText =>
      _localizedStrings[locale.languageCode]?['aboutReformCalendarText'] ?? '';
  String get website =>
      _localizedStrings[locale.languageCode]?['website'] ?? 'Website';
  String get contactEmail =>
      _localizedStrings[locale.languageCode]?['contactEmail'] ?? 'Email';
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

  String get lockGallery =>
      _localizedStrings[locale.languageCode]?['lockGallery'] ?? 'Gallery';

  String get combinationOfStyles =>
      _localizedStrings[locale.languageCode]?['combinationOfStyles'] ??
      'Combination of styles';
  String get allChristian =>
      _localizedStrings[locale.languageCode]?['allChristian'] ?? 'All Christian';

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
      'lockTextVariant': 'Lock screen style',
      'lockTextBoth': 'All styles',
      'lockTextNeutralOnly': 'Neutral',
      'lockTextGregorianOnly': 'Gregorian',
      'lockTextTimer': 'Timer',
      'lockTextStopwatch': 'Stopwatch',
      'lockImageLabel': 'Images for lockscreen',
      'lockFontStyle': 'Lock screen font',
      'lockFontDefault': 'Default',
      'lockFontSerif': 'Serif',
      'lockFontMono': 'Mono',
      'lockColorLabel': 'Lock screen color',
      'lockScreenChanged': 'Lock screen updated — tap to preview',
      'preview': 'Preview',
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
      'leapYear': 'Leap month',
      'leapDay': 'Leap day ✦',
      'leapDayShort': 'Leap ✦',
      'specialDay': 'Special Day',
      'from': 'From',
      'aboutCalendar': 'About Neutral Calendar',
      'howToUse': 'How to use',
      'aboutReformCalendar': 'About Reform Calendar',
      'monthNames': 'Month Names',
      'gregorianMonths': 'Gregorian',
      'neutralMonths': 'Neutral',
      'gregorianStyle': 'Gregorian Style',
      'darkMode': 'Dark Mode',
      'darkModeOn': 'Dark',
      'lightModeOn': 'Light',
      'lockGallery': 'Gallery',
      'combinationOfStyles': 'Combination of styles',
      'allChristian': 'All Christian',
      'website': 'Website',
      'contactEmail': 'Email',
      'aboutCalendarText':
          'About the International Neutral Calendar (Project)\n\n'
          'Calendars are divided into lunar, lunisolar, and solar. The most widespread solar calendar is the Gregorian calendar (new style), but it too has its drawbacks. Mainly, this is the non-proportional distribution of days in months, quarters, and half-years. The Neutral Calendar project maximally eliminates these drawbacks, and thanks to an addition to the Gregorian leap year system, makes the calendar system more accurate for many millennia. For this, every fourth millennium of our era (year 4000) must be counted as a non-leap year.\n\n'
          'The use of a fixed week in the Neutral Calendar will facilitate the work of civil society throughout the world. This way, 27 working days will steadily fall on each month annually, and each calendar date is assigned a specific day of the week.\n\n'
          'The distinct naming of months will serve to strengthen the cultural commonwealth of peoples around the world, and will also not introduce inappropriate confusion among the proposed calendar projects.',
      'aboutReformCalendarText':
          'About the Calendar Reform and the All-Christian Calendar Project.\n\n'
          'The topic of reforming the Gregorian calendar has been ongoing since the last millennium and for various reasons and circumstances has been postponed indefinitely. The calendar project of French writer and astronomer Amerlin, which subsequently became known as "Y2K" (World Calendar), was also rejected by the UN in 1956.\n\n'
          'In order to avoid calendar disagreements between the church and civil society, it is proposed to simultaneously introduce both the All-Christian and the International Neutral Calendar. As is known, it is most practical to carry out the reform in a year that begins on Sunday and ends on Sunday. The nearest such Sunday year will be 2034.\n\n'
          'Now a little about the All-Christian Calendar project. If the classic continuous week is applied to the internal structure of the International Neutral Calendar project, while keeping the month names the same, then no better All-Christian Calendar project can be presented. Mainly, this project will meet the requirements of all Christian churches and will serve to strengthen relationships between various churches of the world.',
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
      'lockTextVariant': 'Выбор стиля на заставке',
      'lockTextBoth': 'Все стили',
      'lockTextNeutralOnly': 'Нейтральный',
      'lockTextGregorianOnly': 'Григорианский',
      'lockTextTimer': 'Таймер',
      'lockTextStopwatch': 'Секундомер',
      'lockImageLabel': 'Изображения для заставки',
      'lockFontStyle': 'Выбор шрифта на заставке',
      'lockFontDefault': 'Обычный',
      'lockFontSerif': 'Serif',
      'lockFontMono': 'Моно',
      'lockColorLabel': 'Выбор цвета заставки',
      'lockScreenChanged': 'Заставка обновлена — нажмите для просмотра',
      'preview': 'Просмотр',
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
      'aqdas': 'Агдас',
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
      'leapYear': 'Високосный месяц',
      'leapDay': 'Високосный день ✦',
      'leapDayShort': 'Висок. ✦',
      'specialDay': 'Особый день',
      'from': 'От',
      'aboutCalendar': 'О Нейтральном Календаре',
      'howToUse': 'Как использовать',
      'aboutReformCalendar': 'О Реформе Календаря',
      'monthNames': 'Названия месяцев',
      'gregorianMonths': 'Григорианские',
      'neutralMonths': 'Нейтральные',
      'gregorianStyle': 'Григорианский стиль',
      'darkMode': 'Темная тема',
      'darkModeOn': 'Темная',
      'lightModeOn': 'Светлая',
      'lockGallery': 'Галерея',
      'combinationOfStyles': 'Комбинация стилей',
      'allChristian': 'Всехристианский',
      'website': 'Сайт',
      'contactEmail': 'Эл. почта',
      'aboutCalendarText':
          'О Международном Нейтральном календаре (Проект)\n\n'
          'Календари различаются на лунные, лунно-солнечные и солнечные. Самым распространенным солнечным календарем является григорианский календарь (новый стиль), но и он имеет свои недостатки. Главным образом, это не пропорциональное распределение дней в месяцах, кварталах и полугодиях. Проект Нейтрального календаря максимально устраняет эти недостатки, а благодаря дополнению к григорианской системе високосов, делает календарную систему более точной на многие тысячелетия. Для этого, каждое четвертое тысячелетие нашей эры (4000 год), необходимо считать не високосным годом.\n\n'
          'Применение в Нейтральном календаре фиксированной недели, облегчит работу гражданского общества во всём мире. Этим самым ежегодно будет стабильно выпадать по 27 рабочих дней на каждый месяц, а за каждой датой календаря закреплен определенный день недели.\n\n'
          'Обособленное наименование месяцев послужит укреплению культурного содружества народов всего мира, а также не будет вносить неуместной путаницы между проектами предлагаемых календарей.',
      'aboutReformCalendarText':
          'О календарной реформе и проекте Всехристианского календаря.\n\n'
          'Тема о реформе григорианского календаря ведется с прошлого тысячелетия и по различным причинам и обстоятельствам отклонялась на неопределенное время. Календарный проект французского писателя и астронома Амерлина, получивший в последствии название «Y2K» (Всемирный календарь) был также отклонен в 1956 году ООН.\n\n'
          'Для того чтобы не возникало календарных разногласий между церковью и гражданским обществом, предлагается одновременное введение, как Всехристианского, так и Международного Нейтрального календаря. Реформу как известно практичнее всего произвести в год который начинается с воскресенья и заканчивается воскресным днем. Ближайшим таким (воскресным) годом будет 2034 год.\n\n'
          'Теперь немного о проекте Всехристианского календаря. Если к внутренней структуре проекта Международного Нейтрального календаря применить классическую непрерывную неделю, а наименование месяцев оставить прежним, то лучшего проекта Всехристианского календаря не представить. Главным образом этот проект будет отвечать требованиям всех христианских церквей и послужит укреплению взаимоотношений между различными церквями мира.',
    },
    'tk': {
      'appTitle': 'Bitarap Senenama',
      'calendar': 'Bitarap stil',
      'normalCalendar': 'Grigorian Senenama',
      'neutralCalendar': 'Bitarap Senenama',
      'comparison': 'Stil utgaşmasy',
      'converter': 'Öwürmek',
      'settings': 'Sazlamalar',
      'lockScreen': 'Zastawka stilleri',
      'lockTextVariant': 'Zastawka stilini saýla',
      'lockTextBoth': 'Ähli stiller',
      'lockTextNeutralOnly': 'Bitarap',
      'lockTextGregorianOnly': 'Grigorian',
      'lockTextTimer': 'Taýmer',
      'lockTextStopwatch': 'Sekundomer',
      'lockImageLabel': 'Zastawka üçin suratlar',
      'lockFontStyle': 'Zastawkada şrift saýla',
      'lockFontDefault': 'Adaty',
      'lockFontSerif': 'Serif',
      'lockFontMono': 'Mono',
      'lockColorLabel': 'Zastawka reňkini saýla',
      'lockScreenChanged': 'Zastawka täzelendi — görmek üçin basyň',
      'preview': 'Görmek',
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
      'leapYear': 'Artykmaç aý',
      'leapDay': 'Artykmaç gün ✦',
      'leapDayShort': 'Artyk. ✦',
      'specialDay': 'Aýratyn gün',
      'from': 'Dan',
      'aboutCalendar': 'Bitarap Senenama barada',
      'howToUse': 'Nädip ulanmaly',
      'aboutReformCalendar': 'Senenama reformasy barada',
      'monthNames': 'Aý atlary',
      'gregorianMonths': 'Gregorian',
      'neutralMonths': 'Bitarap',
      'gregorianStyle': 'Grigorian stili',
      'darkMode': 'Garaňky tema',
      'darkModeOn': 'Garaňky',
      'lightModeOn': 'Ýagty',
      'lockGallery': 'Galereýa',
      'combinationOfStyles': 'Stilleriň utgaşmasy',
      'allChristian': 'Hristian',
      'website': 'Saýt',
      'contactEmail': 'El. poçta',
      'aboutCalendarText':
          'Halkara Bitarap Senenama barada (Taslama)\n\n'
          'Senenamalar aý, aý-gün we gün senenamalaryna bölünýär. Iň köp ýaýran gün senenamasy Grigorian senenamasy (täze stil), emma ol hem kemçiliklerden halas däldir. Esasan bu, aýlardaky, çäreklerdäki we ýarym ýyllardaky günleriň deňsiz paýlanmasydyr. Bitarap Senenama taslamasy bu kemçilikleri iň ýokary derejede aradan aýyrýar, Grigorian ulgamyndaky artykmaç ýyla goşundy saldaly edip, senenama ulgamyny müňýyllyklara has takyk edýär. Munuň üçin biziň eýýamymyzyň her dördünji müňýyllygy (4000-nji ýyl) artykmaç bolmadyk ýyl hasap edilmelidir.\n\n'
          'Bitarap Senenamada kesgitlenen hepdäniň ulanylmagy bütin dünýäde raýat jemgyýetiniň işini ýeňilleşdirer. Şeýlelikde her aýda 27 iş güni durnukly bolup, her senenama senesine belli bir hepde güni berkidiler.\n\n'
          'Aýlaryň aýratyn atlandyrylmagy tutuş dünýäniň halklarynyň medeni agzybirligini berkitmäge hyzmat eder, şeýle hem teklip edilýän senenama taslamalary arasyndaky ýerliksiz düşünişmezlikleri aradan aýyrar.',
      'aboutReformCalendarText':
          'Senenama reformasy we Hristian senenamasy taslamasy barada.\n\n'
          'Grigorian senenamasynyň reformasy hakyndaky mesele geçen müňýyllykdan bäri gozgalýar we dürli sebäplere görä näbelli möhlete yza süýşürildi. Fransuz ýazyjysy we astronomy Amerliniň soňradan «Y2K» (Bütindünýä senenamasy) adyny alan senenama taslamasy hem 1956-njy ýylda BMG tarapyndan ret edildi.\n\n'
          'Ruhanylar bilen raýat jemgyýetiniň arasynda senenama bilen baglanyşykly düşünişmezlikleriň döremezligi üçin, Hristian senenamasy bilen Halkara Bitarap Senenamasynyň bir wagtda girizilmegi teklip edilýär. Belli bolşy ýaly, islegi ýerine getirmegiň iň amatly usuly ýekşenbe güni başlanýan we ýekşenbe güni gutarýan ýylda amala aşyrmaqdyr. Iň golaý şeýle ýyl 2034-nji ýyl bolar.\n\n'
          'Indi Hristian senenamasy taslamasy barada biraz. Halkara Bitarap Senenama taslamasynyň içki gurluşyna klassiki bölünmez hepdäni ulanyp, aýlaryň atlaryny öňkiçe galdyrsak, Hristian senenamasynyň has gowy taslamasyny hödürlemek mümkin däl. Esasan bu taslama ähli hristian kiliseleriniň talaplaryny kanagatlandyrar we dünýäniň dürli kiliseleriniň aragatnaşygyny berkitmäge hyzmat eder.',
    },
    'es': {
      'appTitle': 'Calendario Neutral',
      'calendar': 'Estilo Neutral',
      'normalCalendar': 'Calendario Gregoriano',
      'neutralCalendar': 'Calendario Neutral',
      'comparison': 'Estilo Combinado',
      'converter': 'Convertidor',
      'settings': 'Ajustes',
      'lockScreen': 'Estilos de bloqueo',
      'lockTextVariant': 'Estilo de pantalla de bloqueo',
      'lockTextBoth': 'Todos los estilos',
      'lockTextNeutralOnly': 'Neutral',
      'lockTextGregorianOnly': 'Gregoriano',
      'lockTextTimer': 'Temporizador',
      'lockTextStopwatch': 'Cronómetro',
      'lockImageLabel': 'Imágenes para pantalla de bloqueo',
      'lockFontStyle': 'Fuente de pantalla de bloqueo',
      'lockFontDefault': 'Predeterminado',
      'lockFontSerif': 'Serif',
      'lockFontMono': 'Mono',
      'lockColorLabel': 'Color de pantalla de bloqueo',
      'lockScreenChanged': 'Pantalla de bloqueo actualizada — toca para previsualizar',
      'preview': 'Vista previa',
      'language': 'Idioma',
      'january': 'Enero',
      'february': 'Febrero',
      'march': 'Marzo',
      'april': 'Abril',
      'may': 'Mayo',
      'june': 'Junio',
      'july': 'Julio',
      'august': 'Agosto',
      'september': 'Septiembre',
      'october': 'Octubre',
      'november': 'Noviembre',
      'december': 'Diciembre',
      'adam': 'Adán',
      'eve': 'Eva',
      'noah': 'Noé',
      'abraham': 'Abraham',
      'moses': 'Moisés',
      'icon': 'Ícono',
      'ilham': 'Ilham',
      'avesta': 'Avesta',
      'shinto': 'Shinto',
      'aqdas': 'Aqdas',
      'nirvana': 'Nirvana',
      'dharma': 'Dharma',
      'monday': 'Lun',
      'tuesday': 'Mar',
      'wednesday': 'Mié',
      'thursday': 'Jue',
      'friday': 'Vie',
      'saturday': 'Sáb',
      'sunday': 'Dom',
      'convertDate': 'Convertir fecha',
      'selectDate': 'Seleccionar fecha',
      'today': 'Hoy',
      'leapYear': 'Mes bisiesto',
      'leapDay': 'Día bisiesto ✦',
      'leapDayShort': 'Bis. ✦',
      'specialDay': 'Día especial',
      'from': 'De',
      'aboutCalendar': 'Sobre el Calendario Neutral',
      'howToUse': 'Cómo usar',
      'aboutReformCalendar': 'Sobre la Reforma del Calendario',
      'monthNames': 'Nombres de meses',
      'gregorianMonths': 'Gregoriano',
      'neutralMonths': 'Neutral',
      'gregorianStyle': 'Estilo Gregoriano',
      'darkMode': 'Modo oscuro',
      'darkModeOn': 'Oscuro',
      'lightModeOn': 'Claro',
      'lockGallery': 'Galería',
      'combinationOfStyles': 'Combinación de estilos',
      'allChristian': 'Todos Cristiano',
      'website': 'Sitio web',
      'contactEmail': 'Correo electrónico',
      'aboutCalendarText':
          'Sobre el Calendario Neutral Internacional (Proyecto)\n\n'
          'Los calendarios se dividen en lunares, lunisolares y solares. El calendario solar más extendido es el calendario gregoriano (nuevo estilo), pero también tiene sus desventajas. Principalmente, se trata de la distribución no proporcional de días en meses, trimestres y semestres. El proyecto del Calendario Neutral elimina al máximo estas desventajas y, gracias a una adición al sistema gregoriano de años bisiestos, hace que el sistema calendario sea más preciso durante muchos milenios. Para ello, cada cuarto milenio de nuestra era (año 4000) debe considerarse un año no bisiesto.\n\n'
          'El uso de una semana fija en el Calendario Neutral facilitará el trabajo de la sociedad civil en todo el mundo. De esta manera, 27 días laborables caerán establemente en cada mes anualmente, y a cada fecha del calendario se le asigna un día específico de la semana.\n\n'
          'La denominación distinta de los meses servirá para fortalecer la hermandad cultural de los pueblos de todo el mundo, y tampoco introducirá confusión inapropiada entre los proyectos de calendarios propuestos.',
      'aboutReformCalendarText':
          'Sobre la Reforma del Calendario y el Proyecto del Calendario Pancristiano.\n\n'
          'El tema de la reforma del calendario gregoriano ha continuado desde el último milenio y por diversas razones y circunstancias se ha postergado indefinidamente. El proyecto de calendario del escritor y astrónomo francés Amerlin, que posteriormente se conoció como «Y2K» (Calendario Mundial), también fue rechazado por la ONU en 1956.\n\n'
          'Para evitar desacuerdos de calendario entre la iglesia y la sociedad civil, se propone la introducción simultánea tanto del Calendario Pancristiano como del Calendario Neutral Internacional. Como es sabido, es más práctico llevar a cabo la reforma en un año que comience en domingo y termine en domingo. El año más próximo de este tipo será 2034.\n\n'
          'Ahora un poco sobre el proyecto del Calendario Pancristiano. Si se aplica la semana continua clásica a la estructura interna del proyecto del Calendario Neutral Internacional, manteniendo los mismos nombres de los meses, no se podría presentar un mejor proyecto de Calendario Pancristiano. Principalmente, este proyecto cumplirá con los requisitos de todas las iglesias cristianas y servirá para fortalecer las relaciones entre las diversas iglesias del mundo.',
    },
    'fr': {
      'appTitle': 'Calendrier Neutre',
      'calendar': 'Style Neutre',
      'normalCalendar': 'Calendrier Grégorien',
      'neutralCalendar': 'Calendrier Neutre',
      'comparison': 'Style Combiné',
      'converter': 'Convertisseur',
      'settings': 'Paramètres',
      'lockScreen': 'Styles de verrouillage',
      'lockTextVariant': "Style d'écran de verrouillage",
      'lockTextBoth': 'Tous les styles',
      'lockTextNeutralOnly': 'Neutre',
      'lockTextGregorianOnly': 'Grégorien',
      'lockTextTimer': 'Minuterie',
      'lockTextStopwatch': 'Chronomètre',
      'lockImageLabel': "Images pour l'écran de verrouillage",
      'lockFontStyle': "Police d'écran de verrouillage",
      'lockFontDefault': 'Par défaut',
      'lockFontSerif': 'Serif',
      'lockFontMono': 'Mono',
      'lockColorLabel': "Couleur d'écran de verrouillage",
      'lockScreenChanged': 'Écran de verrouillage mis à jour — appuyez pour aperçu',
      'preview': 'Aperçu',
      'language': 'Langue',
      'january': 'Janvier',
      'february': 'Février',
      'march': 'Mars',
      'april': 'Avril',
      'may': 'Mai',
      'june': 'Juin',
      'july': 'Juillet',
      'august': 'Août',
      'september': 'Septembre',
      'october': 'Octobre',
      'november': 'Novembre',
      'december': 'Décembre',
      'adam': 'Adam',
      'eve': 'Ève',
      'noah': 'Noé',
      'abraham': 'Abraham',
      'moses': 'Moïse',
      'icon': 'Icône',
      'ilham': 'Ilham',
      'avesta': 'Avesta',
      'shinto': 'Shinto',
      'aqdas': 'Aqdas',
      'nirvana': 'Nirvana',
      'dharma': 'Dharma',
      'monday': 'Lun',
      'tuesday': 'Mar',
      'wednesday': 'Mer',
      'thursday': 'Jeu',
      'friday': 'Ven',
      'saturday': 'Sam',
      'sunday': 'Dim',
      'convertDate': 'Convertir la date',
      'selectDate': 'Sélectionner la date',
      'today': "Aujourd'hui",
      'leapYear': 'Mois bissextile',
      'leapDay': 'Jour bissextile ✦',
      'leapDayShort': 'Bis. ✦',
      'specialDay': 'Jour spécial',
      'from': 'De',
      'aboutCalendar': 'À propos du Calendrier Neutre',
      'howToUse': 'Comment utiliser',
      'aboutReformCalendar': 'À propos de la Réforme du Calendrier',
      'monthNames': 'Noms des mois',
      'gregorianMonths': 'Grégorien',
      'neutralMonths': 'Neutre',
      'gregorianStyle': 'Style Grégorien',
      'darkMode': 'Mode sombre',
      'darkModeOn': 'Sombre',
      'lightModeOn': 'Clair',
      'lockGallery': 'Galerie',
      'combinationOfStyles': 'Combinaison de styles',
      'allChristian': 'Tout Chrétien',
      'website': 'Site web',
      'contactEmail': 'E-mail',
      'aboutCalendarText':
          'À propos du Calendrier Neutre International (Projet)\n\n'
          'Les calendriers se divisent en lunaires, luni-solaires et solaires. Le calendrier solaire le plus répandu est le calendrier grégorien (nouveau style), mais il a aussi ses inconvénients. Principalement, il s\'agit de la répartition non proportionnelle des jours dans les mois, les trimestres et les semestres. Le projet du Calendrier Neutre élimine au maximum ces inconvénients et, grâce à un complément au système grégorien d\'années bissextiles, rend le système calendaire plus précis pour de nombreux millénaires. Pour cela, chaque quatrième millénaire de notre ère (année 4000) doit être considéré comme une année non bissextile.\n\n'
          'L\'utilisation d\'une semaine fixe dans le Calendrier Neutre facilitera le travail de la société civile dans le monde entier. Ainsi, 27 jours ouvrables tomberont régulièrement sur chaque mois chaque année, et chaque date du calendrier est associée à un jour de la semaine spécifique.\n\n'
          'La dénomination distincte des mois servira à renforcer la fraternité culturelle des peuples du monde entier, et n\'introduira pas non plus de confusion inappropriée entre les projets de calendriers proposés.',
      'aboutReformCalendarText':
          'À propos de la Réforme du Calendrier et du Projet de Calendrier Panchrétien.\n\n'
          'Le sujet de la réforme du calendrier grégorien est discuté depuis le dernier millénaire et pour diverses raisons et circonstances a été reporté indéfiniment. Le projet de calendrier de l\'écrivain et astronome français Amerlin, qui a été ensuite connu sous le nom de «Y2K» (Calendrier Mondial), a également été rejeté par l\'ONU en 1956.\n\n'
          'Afin d\'éviter des désaccords calendaires entre l\'Église et la société civile, il est proposé d\'introduire simultanément à la fois le Calendrier Panchrétien et le Calendrier Neutre International. Comme on le sait, il est plus pratique d\'effectuer la réforme au cours d\'une année qui commence un dimanche et se termine un dimanche. L\'année la plus proche de ce type sera 2034.\n\n'
          'Maintenant, quelques mots sur le projet du Calendrier Panchrétien. Si la semaine continue classique est appliquée à la structure interne du projet du Calendrier Neutre International, tout en conservant les mêmes noms de mois, aucun meilleur projet de Calendrier Panchrétien ne pourrait être présenté. Principalement, ce projet répondra aux exigences de toutes les églises chrétiennes et servira à renforcer les relations entre les diverses églises du monde.',
    },
    'pt': {
      'appTitle': 'Calendário Neutro',
      'calendar': 'Estilo Neutro',
      'normalCalendar': 'Calendário Gregoriano',
      'neutralCalendar': 'Calendário Neutro',
      'comparison': 'Estilo Combinado',
      'converter': 'Conversor',
      'settings': 'Configurações',
      'lockScreen': 'Estilos de bloqueio',
      'lockTextVariant': 'Estilo de tela de bloqueio',
      'lockTextBoth': 'Todos os estilos',
      'lockTextNeutralOnly': 'Neutro',
      'lockTextGregorianOnly': 'Gregoriano',
      'lockTextTimer': 'Temporizador',
      'lockTextStopwatch': 'Cronómetro',
      'lockImageLabel': 'Imagens para tela de bloqueio',
      'lockFontStyle': 'Fonte da tela de bloqueio',
      'lockFontDefault': 'Padrão',
      'lockFontSerif': 'Serif',
      'lockFontMono': 'Mono',
      'lockColorLabel': 'Cor da tela de bloqueio',
      'lockScreenChanged': 'Tela de bloqueio atualizada — toque para visualizar',
      'preview': 'Visualizar',
      'language': 'Idioma',
      'january': 'Janeiro',
      'february': 'Fevereiro',
      'march': 'Março',
      'april': 'Abril',
      'may': 'Maio',
      'june': 'Junho',
      'july': 'Julho',
      'august': 'Agosto',
      'september': 'Setembro',
      'october': 'Outubro',
      'november': 'Novembro',
      'december': 'Dezembro',
      'adam': 'Adão',
      'eve': 'Eva',
      'noah': 'Noé',
      'abraham': 'Abraão',
      'moses': 'Moisés',
      'icon': 'Ícone',
      'ilham': 'Ilham',
      'avesta': 'Avesta',
      'shinto': 'Shinto',
      'aqdas': 'Aqdas',
      'nirvana': 'Nirvana',
      'dharma': 'Dharma',
      'monday': 'Seg',
      'tuesday': 'Ter',
      'wednesday': 'Qua',
      'thursday': 'Qui',
      'friday': 'Sex',
      'saturday': 'Sáb',
      'sunday': 'Dom',
      'convertDate': 'Converter data',
      'selectDate': 'Selecionar data',
      'today': 'Hoje',
      'leapYear': 'Mês bissexto',
      'leapDay': 'Dia bissexto ✦',
      'leapDayShort': 'Bis. ✦',
      'specialDay': 'Dia especial',
      'from': 'De',
      'aboutCalendar': 'Sobre o Calendário Neutro',
      'howToUse': 'Como usar',
      'aboutReformCalendar': 'Sobre a Reforma do Calendário',
      'monthNames': 'Nomes dos meses',
      'gregorianMonths': 'Gregoriano',
      'neutralMonths': 'Neutro',
      'gregorianStyle': 'Estilo Gregoriano',
      'darkMode': 'Modo escuro',
      'darkModeOn': 'Escuro',
      'lightModeOn': 'Claro',
      'lockGallery': 'Galeria',
      'combinationOfStyles': 'Combinação de estilos',
      'allChristian': 'Todo Cristão',
      'website': 'Site',
      'contactEmail': 'E-mail',
      'aboutCalendarText':
          'Sobre o Calendário Neutro Internacional (Projeto)\n\n'
          'Os calendários dividem-se em lunares, lunisolares e solares. O calendário solar mais difundido é o calendário gregoriano (novo estilo), mas ele também tem suas desvantagens. Principalmente, trata-se da distribuição não proporcional dos dias em meses, trimestres e semestres. O projeto do Calendário Neutro elimina ao máximo essas desvantagens e, graças a um acréscimo ao sistema gregoriano de anos bissextos, torna o sistema calendário mais preciso por muitos milênios. Para isso, cada quarto milênio da nossa era (ano 4000) deve ser considerado um ano não bissexto.\n\n'
          'O uso de uma semana fixa no Calendário Neutro facilitará o trabalho da sociedade civil em todo o mundo. Assim, 27 dias úteis cairão regularmente em cada mês anualmente, e cada data do calendário tem um dia específico da semana atribuído.\n\n'
          'A denominação distinta dos meses servirá para fortalecer a fraternidade cultural dos povos de todo o mundo, e também não introduzirá confusão inadequada entre os projetos de calendários propostos.',
      'aboutReformCalendarText':
          'Sobre a Reforma do Calendário e o Projeto do Calendário Pan-Cristão.\n\n'
          'O tema da reforma do calendário gregoriano vem sendo discutido desde o último milênio e por diversas razões e circunstâncias foi adiado por tempo indefinido. O projeto de calendário do escritor e astrônomo francês Amerlin, que posteriormente ficou conhecido como «Y2K» (Calendário Mundial), também foi rejeitado pela ONU em 1956.\n\n'
          'Para evitar divergências de calendário entre a Igreja e a sociedade civil, propõe-se a introdução simultânea tanto do Calendário Pan-Cristão como do Calendário Neutro Internacional. Como se sabe, é mais prático realizar a reforma em um ano que começa no domingo e termina no domingo. O ano mais próximo desse tipo será 2034.\n\n'
          'Agora um pouco sobre o projeto do Calendário Pan-Cristão. Se a semana contínua clássica for aplicada à estrutura interna do projeto do Calendário Neutro Internacional, mantendo os mesmos nomes dos meses, nenhum projeto melhor de Calendário Pan-Cristão poderia ser apresentado. Principalmente, este projeto atenderá aos requisitos de todas as igrejas cristãs e servirá para fortalecer as relações entre as diversas igrejas do mundo.',
    },
    'de': {
      'appTitle': 'Neutraler Kalender',
      'calendar': 'Neutraler Stil',
      'normalCalendar': 'Gregorianischer Kalender',
      'neutralCalendar': 'Neutraler Kalender',
      'comparison': 'Kombistil',
      'converter': 'Konverter',
      'settings': 'Einstellungen',
      'lockScreen': 'Sperrbildschirm-Stile',
      'lockTextVariant': 'Sperrbildschirm-Stil',
      'lockTextBoth': 'Alle Stile',
      'lockTextNeutralOnly': 'Neutral',
      'lockTextGregorianOnly': 'Gregorianisch',
      'lockTextTimer': 'Timer',
      'lockTextStopwatch': 'Stoppuhr',
      'lockImageLabel': 'Bilder für Sperrbildschirm',
      'lockFontStyle': 'Sperrbildschirm-Schrift',
      'lockFontDefault': 'Standard',
      'lockFontSerif': 'Serif',
      'lockFontMono': 'Mono',
      'lockColorLabel': 'Sperrbildschirm-Farbe',
      'lockScreenChanged': 'Sperrbildschirm aktualisiert — tippen zur Vorschau',
      'preview': 'Vorschau',
      'language': 'Sprache',
      'january': 'Januar',
      'february': 'Februar',
      'march': 'März',
      'april': 'April',
      'may': 'Mai',
      'june': 'Juni',
      'july': 'Juli',
      'august': 'August',
      'september': 'September',
      'october': 'Oktober',
      'november': 'November',
      'december': 'Dezember',
      'adam': 'Adam',
      'eve': 'Eva',
      'noah': 'Noah',
      'abraham': 'Abraham',
      'moses': 'Mose',
      'icon': 'Symbol',
      'ilham': 'Ilham',
      'avesta': 'Avesta',
      'shinto': 'Shinto',
      'aqdas': 'Aqdas',
      'nirvana': 'Nirwana',
      'dharma': 'Dharma',
      'monday': 'Mo',
      'tuesday': 'Di',
      'wednesday': 'Mi',
      'thursday': 'Do',
      'friday': 'Fr',
      'saturday': 'Sa',
      'sunday': 'So',
      'convertDate': 'Datum konvertieren',
      'selectDate': 'Datum auswählen',
      'today': 'Heute',
      'leapYear': 'Schaltmonat',
      'leapDay': 'Schalttag ✦',
      'leapDayShort': 'Schalt ✦',
      'specialDay': 'Besonderer Tag',
      'from': 'Von',
      'aboutCalendar': 'Über den Neutralen Kalender',
      'howToUse': 'Wie zu benutzen',
      'aboutReformCalendar': 'Über die Kalenderreform',
      'monthNames': 'Monatsnamen',
      'gregorianMonths': 'Gregorianisch',
      'neutralMonths': 'Neutral',
      'gregorianStyle': 'Gregorianischer Stil',
      'darkMode': 'Dunkler Modus',
      'darkModeOn': 'Dunkel',
      'lightModeOn': 'Hell',
      'lockGallery': 'Galerie',
      'combinationOfStyles': 'Stilkombination',
      'allChristian': 'Allchristlich',
      'website': 'Website',
      'contactEmail': 'E-Mail',
      'aboutCalendarText':
          'Über den Internationalen Neutralen Kalender (Projekt)\n\n'
          'Kalender werden in Mond-, Mond-Sonne- und Sonnenkalender eingeteilt. Der verbreitetste Sonnenkalender ist der Gregorianische Kalender (neuer Stil), aber auch er hat seine Nachteile. In erster Linie ist dies die unproportionale Verteilung der Tage in Monaten, Quartalen und Halbjahren. Das Projekt des Neutralen Kalenders beseitigt diese Nachteile maximal und macht durch eine Ergänzung zum Gregorianischen Schaltjahrsystem das Kalendersystem für viele Jahrtausende präziser. Dazu muss jedes vierte Jahrtausend unserer Ära (Jahr 4000) als kein Schaltjahr gezählt werden.\n\n'
          'Die Verwendung einer festen Woche im Neutralen Kalender wird die Arbeit der Zivilgesellschaft auf der ganzen Welt erleichtern. Dadurch werden jährlich stabil 27 Arbeitstage auf jeden Monat fallen, und jedem Kalenderdatum ist ein bestimmter Wochentag zugeordnet.\n\n'
          'Die eigenständige Benennung der Monate wird dazu dienen, die kulturelle Gemeinschaft der Völker der ganzen Welt zu stärken, und wird auch keine unangemessene Verwirrung zwischen den vorgeschlagenen Kalenderprojekten einführen.',
      'aboutReformCalendarText':
          'Über die Kalenderreform und das Projekt des Allchristlichen Kalenders.\n\n'
          'Das Thema der Reform des Gregorianischen Kalenders wird seit dem letzten Jahrtausend diskutiert und wurde aus verschiedenen Gründen und Umständen auf unbestimmte Zeit verschoben. Das Kalenderprojekt des französischen Schriftstellers und Astronomen Amerlin, das später den Namen «Y2K» (Weltkalender) erhielt, wurde 1956 ebenfalls von der UNO abgelehnt.\n\n'
          'Um Kalenderstreitigkeiten zwischen der Kirche und der Zivilgesellschaft zu vermeiden, wird die gleichzeitige Einführung sowohl des Allchristlichen als auch des Internationalen Neutralen Kalenders vorgeschlagen. Wie bekannt, ist es am praktischsten, die Reform in einem Jahr durchzuführen, das an einem Sonntag beginnt und an einem Sonntag endet. Das nächste solche Jahr wird 2034 sein.\n\n'
          'Nun ein wenig über das Projekt des Allchristlichen Kalenders. Wenn auf die innere Struktur des Projekts des Internationalen Neutralen Kalenders die klassische kontinuierliche Woche angewendet und die Monatsnamen beibehalten werden, lässt sich kein besseres Projekt des Allchristlichen Kalenders vorstellen. In erster Linie wird dieses Projekt den Anforderungen aller christlichen Kirchen entsprechen und dazu dienen, die Beziehungen zwischen den verschiedenen Kirchen der Welt zu stärken.',
    },
    'it': {
      'appTitle': 'Calendario Neutro',
      'calendar': 'Stile Neutro',
      'normalCalendar': 'Calendario Gregoriano',
      'neutralCalendar': 'Calendario Neutro',
      'comparison': 'Stile Combinato',
      'converter': 'Convertitore',
      'settings': 'Impostazioni',
      'lockScreen': 'Stili di blocco',
      'lockTextVariant': 'Stile schermata di blocco',
      'lockTextBoth': 'Tutti gli stili',
      'lockTextNeutralOnly': 'Neutro',
      'lockTextGregorianOnly': 'Gregoriano',
      'lockTextTimer': 'Timer',
      'lockTextStopwatch': 'Cronometro',
      'lockImageLabel': 'Immagini per schermata di blocco',
      'lockFontStyle': 'Carattere schermata di blocco',
      'lockFontDefault': 'Predefinito',
      'lockFontSerif': 'Serif',
      'lockFontMono': 'Mono',
      'lockColorLabel': 'Colore schermata di blocco',
      'lockScreenChanged': 'Schermata di blocco aggiornata — tocca per anteprima',
      'preview': 'Anteprima',
      'language': 'Lingua',
      'january': 'Gennaio',
      'february': 'Febbraio',
      'march': 'Marzo',
      'april': 'Aprile',
      'may': 'Maggio',
      'june': 'Giugno',
      'july': 'Luglio',
      'august': 'Agosto',
      'september': 'Settembre',
      'october': 'Ottobre',
      'november': 'Novembre',
      'december': 'Dicembre',
      'adam': 'Adamo',
      'eve': 'Eva',
      'noah': 'Noè',
      'abraham': 'Abramo',
      'moses': 'Mosè',
      'icon': 'Icona',
      'ilham': 'Ilham',
      'avesta': 'Avesta',
      'shinto': 'Shinto',
      'aqdas': 'Aqdas',
      'nirvana': 'Nirvana',
      'dharma': 'Dharma',
      'monday': 'Lun',
      'tuesday': 'Mar',
      'wednesday': 'Mer',
      'thursday': 'Gio',
      'friday': 'Ven',
      'saturday': 'Sab',
      'sunday': 'Dom',
      'convertDate': 'Converti data',
      'selectDate': 'Seleziona data',
      'today': 'Oggi',
      'leapYear': 'Mese bisestile',
      'leapDay': 'Giorno bisestile ✦',
      'leapDayShort': 'Bis. ✦',
      'specialDay': 'Giorno speciale',
      'from': 'Da',
      'aboutCalendar': 'Sul Calendario Neutro',
      'howToUse': 'Come usare',
      'aboutReformCalendar': 'Sulla Riforma del Calendario',
      'monthNames': 'Nomi dei mesi',
      'gregorianMonths': 'Gregoriano',
      'neutralMonths': 'Neutro',
      'gregorianStyle': 'Stile Gregoriano',
      'darkMode': 'Modalità scura',
      'darkModeOn': 'Scuro',
      'lightModeOn': 'Chiaro',
      'lockGallery': 'Galleria',
      'combinationOfStyles': 'Combinazione di stili',
      'allChristian': 'Tutti i Cristiani',
      'website': 'Sito web',
      'contactEmail': 'E-mail',
      'aboutCalendarText':
          'Sul Calendario Neutro Internazionale (Progetto)\n\n'
          'I calendari si dividono in lunari, lunisolari e solari. Il calendario solare più diffuso è il calendario gregoriano (nuovo stile), ma anch\'esso ha i suoi svantaggi. Principalmente, si tratta della distribuzione non proporzionale dei giorni nei mesi, nei trimestri e nei semestri. Il progetto del Calendario Neutro elimina al massimo questi svantaggi e, grazie a un\'aggiunta al sistema gregoriano di anni bisestili, rende il sistema calendare più preciso per molti millenni. Per questo, ogni quarto millennio della nostra era (anno 4000) deve essere considerato un anno non bisestile.\n\n'
          'L\'uso di una settimana fissa nel Calendario Neutro faciliterà il lavoro della società civile in tutto il mondo. In questo modo, 27 giorni lavorativi cadranno stabilmente su ogni mese ogni anno, e ad ogni data del calendario è assegnato un giorno specifico della settimana.\n\n'
          'La denominazione distinta dei mesi servirà a rafforzare la fraternità culturale dei popoli di tutto il mondo, e non introdurrà nemmeno confusione inappropriata tra i progetti di calendari proposti.',
      'aboutReformCalendarText':
          'Sulla Riforma del Calendario e sul Progetto del Calendario Pancristiano.\n\n'
          'Il tema della riforma del calendario gregoriano è discusso dall\'ultimo millennio e per vari motivi e circostanze è stato rinviato a tempo indeterminato. Il progetto di calendario dello scrittore e astronomo francese Amerlin, che successivamente ha preso il nome di «Y2K» (Calendario Mondiale), è stato anch\'esso respinto dall\'ONU nel 1956.\n\n'
          'Per evitare disaccordi di calendario tra la chiesa e la società civile, si propone l\'introduzione simultanea sia del Calendario Pancristiano che del Calendario Neutro Internazionale. Come è noto, è più pratico effettuare la riforma in un anno che inizia di domenica e finisce di domenica. L\'anno più vicino di questo tipo sarà il 2034.\n\n'
          'Ora un po\' sul progetto del Calendario Pancristiano. Se la settimana continua classica viene applicata alla struttura interna del progetto del Calendario Neutro Internazionale, mantenendo gli stessi nomi dei mesi, non si potrebbe presentare un progetto migliore di Calendario Pancristiano. Principalmente, questo progetto soddisferà i requisiti di tutte le chiese cristiane e servirà a rafforzare le relazioni tra le varie chiese del mondo.',
    },
    'tr': {
      'appTitle': 'Tarafsız Takvim',
      'calendar': 'Tarafsız Stil',
      'normalCalendar': 'Gregoryen Takvim',
      'neutralCalendar': 'Tarafsız Takvim',
      'comparison': 'Karma Stil',
      'converter': 'Dönüştürücü',
      'settings': 'Ayarlar',
      'lockScreen': 'Kilit Ekranı Stilleri',
      'lockTextVariant': 'Kilit ekranı stili',
      'lockTextBoth': 'Tüm stiller',
      'lockTextNeutralOnly': 'Tarafsız',
      'lockTextGregorianOnly': 'Gregoryen',
      'lockTextTimer': 'Zamanlayıcı',
      'lockTextStopwatch': 'Kronometre',
      'lockImageLabel': 'Kilit ekranı için resimler',
      'lockFontStyle': 'Kilit ekranı yazı tipi',
      'lockFontDefault': 'Varsayılan',
      'lockFontSerif': 'Serif',
      'lockFontMono': 'Mono',
      'lockColorLabel': 'Kilit ekranı rengi',
      'lockScreenChanged': 'Kilit ekranı güncellendi — önizleme için dokun',
      'preview': 'Önizleme',
      'language': 'Dil',
      'january': 'Ocak',
      'february': 'Şubat',
      'march': 'Mart',
      'april': 'Nisan',
      'may': 'Mayıs',
      'june': 'Haziran',
      'july': 'Temmuz',
      'august': 'Ağustos',
      'september': 'Eylül',
      'october': 'Ekim',
      'november': 'Kasım',
      'december': 'Aralık',
      'adam': 'Âdem',
      'eve': 'Havva',
      'noah': 'Nuh',
      'abraham': 'İbrahim',
      'moses': 'Musa',
      'icon': 'Simge',
      'ilham': 'İlham',
      'avesta': 'Avesta',
      'shinto': 'Şinto',
      'aqdas': 'Aqdas',
      'nirvana': 'Nirvana',
      'dharma': 'Dharma',
      'monday': 'Pzt',
      'tuesday': 'Sal',
      'wednesday': 'Çar',
      'thursday': 'Per',
      'friday': 'Cum',
      'saturday': 'Cmt',
      'sunday': 'Paz',
      'convertDate': 'Tarihi dönüştür',
      'selectDate': 'Tarih seç',
      'today': 'Bugün',
      'leapYear': 'Artık ay',
      'leapDay': 'Artık gün ✦',
      'leapDayShort': 'Artık ✦',
      'specialDay': 'Özel gün',
      'from': 'Gönderen',
      'aboutCalendar': 'Tarafsız Takvim Hakkında',
      'howToUse': 'Nasıl kullanılır',
      'aboutReformCalendar': 'Takvim Reformu Hakkında',
      'monthNames': 'Ay isimleri',
      'gregorianMonths': 'Gregoryen',
      'neutralMonths': 'Tarafsız',
      'gregorianStyle': 'Gregoryen Stili',
      'darkMode': 'Karanlık mod',
      'darkModeOn': 'Karanlık',
      'lightModeOn': 'Aydınlık',
      'lockGallery': 'Galeri',
      'combinationOfStyles': 'Stil kombinasyonu',
      'allChristian': 'Tüm Hristiyan',
      'website': 'Web sitesi',
      'contactEmail': 'E-posta',
      'aboutCalendarText':
          'Uluslararası Tarafsız Takvim Hakkında (Proje)\n\n'
          'Takvimler ay, luni-güneş ve güneş takvimleri olarak ayrılır. En yaygın güneş takvimi Gregoryen takvimdir (yeni stil), ancak onun da dezavantajları vardır. Başlıca dezavantajı, aylardaki, çeyreklerdeki ve yarıyıllardaki günlerin orantısız dağılımıdır. Tarafsız Takvim projesi bu dezavantajları en üst düzeyde ortadan kaldırır ve Gregoryen artık yıl sistemine yapılan bir ekleme sayesinde takvim sistemini birçok milenyum için daha hassas hale getirir. Bunun için, çağımızın her dördüncü binyılının (4000 yılı) artık yıl sayılmaması gerekmektedir.\n\n'
          'Tarafsız Takvimde sabit bir haftanın kullanılması, tüm dünyada sivil toplumun çalışmasını kolaylaştıracaktır. Böylece her yıl her aya istikrarlı bir şekilde 27 iş günü düşecek ve her takvim tarihine belirli bir haftanın günü atanacaktır.\n\n'
          'Ayların özgün adlandırılması, tüm dünyanın halklarının kültürel birliğini güçlendirmeye hizmet edecek ve önerilen takvim projeleri arasında uygunsuz karışıklığa da yol açmayacaktır.',
      'aboutReformCalendarText':
          'Takvim Reformu ve Tüm Hristiyan Takvimi Projesi Hakkında.\n\n'
          'Gregoryen takviminin reformu konusu geçen binyıldan beri sürmekte olup çeşitli nedenler ve koşullar nedeniyle süresiz ertelenmiştir. Fransız yazar ve astronom Amerlin\'in daha sonra «Y2K» (Dünya Takvimi) adını alan takvim projesi de 1956 yılında BM tarafından reddedilmiştir.\n\n'
          'Kilise ile sivil toplum arasında takvim anlaşmazlıklarının ortaya çıkmaması için hem Tüm Hristiyan hem de Uluslararası Tarafsız Takvimin eş zamanlı olarak tanıtılması önerilmektedir. Bilindiği üzere, reformu Pazar günü başlayan ve Pazar günü biten bir yılda gerçekleştirmek en pratik yoldur. Bu tür en yakın yıl 2034 olacaktır.\n\n'
          'Şimdi Tüm Hristiyan Takvimi projesi hakkında biraz. Uluslararası Tarafsız Takvim projesinin iç yapısına klasik sürekli hafta uygulanır ve ay adları aynı tutulursa, daha iyi bir Tüm Hristiyan Takvimi projesi sunulamazdı. Başlıca olarak, bu proje tüm Hristiyan kiliselerinin gereksinimlerini karşılayacak ve dünyanın çeşitli kiliseleri arasındaki ilişkilerin güçlendirilmesine hizmet edecektir.',
    },
    'vi': {
      'appTitle': 'Lịch Trung Lập',
      'calendar': 'Kiểu Trung Lập',
      'normalCalendar': 'Lịch Gregorian',
      'neutralCalendar': 'Lịch Trung Lập',
      'comparison': 'Kiểu Kết Hợp',
      'converter': 'Chuyển Đổi',
      'settings': 'Cài Đặt',
      'lockScreen': 'Kiểu Màn Hình Khóa',
      'lockTextVariant': 'Kiểu màn hình khóa',
      'lockTextBoth': 'Tất cả kiểu',
      'lockTextNeutralOnly': 'Trung Lập',
      'lockTextGregorianOnly': 'Gregorian',
      'lockTextTimer': 'Bộ Hẹn Giờ',
      'lockTextStopwatch': 'Đồng Hồ Bấm Giờ',
      'lockImageLabel': 'Hình ảnh cho màn hình khóa',
      'lockFontStyle': 'Phông chữ màn hình khóa',
      'lockFontDefault': 'Mặc Định',
      'lockFontSerif': 'Serif',
      'lockFontMono': 'Mono',
      'lockColorLabel': 'Màu màn hình khóa',
      'lockScreenChanged': 'Màn hình khóa đã cập nhật — nhấn để xem trước',
      'preview': 'Xem Trước',
      'language': 'Ngôn Ngữ',
      'january': 'Tháng Một',
      'february': 'Tháng Hai',
      'march': 'Tháng Ba',
      'april': 'Tháng Tư',
      'may': 'Tháng Năm',
      'june': 'Tháng Sáu',
      'july': 'Tháng Bảy',
      'august': 'Tháng Tám',
      'september': 'Tháng Chín',
      'october': 'Tháng Mười',
      'november': 'Tháng Mười Một',
      'december': 'Tháng Mười Hai',
      'adam': 'Adam',
      'eve': 'Eva',
      'noah': 'Nô-ê',
      'abraham': 'Abraham',
      'moses': 'Môi-se',
      'icon': 'Biểu Tượng',
      'ilham': 'Ilham',
      'avesta': 'Avesta',
      'shinto': 'Thần Đạo',
      'aqdas': 'Aqdas',
      'nirvana': 'Niết Bàn',
      'dharma': 'Dharma',
      'monday': 'T2',
      'tuesday': 'T3',
      'wednesday': 'T4',
      'thursday': 'T5',
      'friday': 'T6',
      'saturday': 'T7',
      'sunday': 'CN',
      'convertDate': 'Chuyển Đổi Ngày',
      'selectDate': 'Chọn Ngày',
      'today': 'Hôm Nay',
      'leapYear': 'Tháng nhuận',
      'leapDay': 'Ngày nhuận ✦',
      'leapDayShort': 'Nhuận ✦',
      'specialDay': 'Ngày đặc biệt',
      'from': 'Từ',
      'aboutCalendar': 'Về Lịch Trung Lập',
      'howToUse': 'Cách sử dụng',
      'aboutReformCalendar': 'Về Cải Cách Lịch',
      'monthNames': 'Tên tháng',
      'gregorianMonths': 'Gregorian',
      'neutralMonths': 'Trung Lập',
      'gregorianStyle': 'Kiểu Gregorian',
      'darkMode': 'Chế độ tối',
      'darkModeOn': 'Tối',
      'lightModeOn': 'Sáng',
      'lockGallery': 'Thư Viện',
      'combinationOfStyles': 'Kết hợp phong cách',
      'allChristian': 'Toàn Cơ Đốc Giáo',
      'website': 'Trang web',
      'contactEmail': 'Email',
      'aboutCalendarText':
          'Về Lịch Trung Lập Quốc Tế (Dự Án)\n\n'
          'Lịch được phân thành lịch âm, lịch âm dương và lịch dương. Lịch dương phổ biến nhất là lịch Gregorian (phong cách mới), nhưng nó cũng có những nhược điểm. Chủ yếu là sự phân bổ không cân đối các ngày trong tháng, quý và nửa năm. Dự án Lịch Trung Lập loại bỏ tối đa những nhược điểm này và nhờ bổ sung vào hệ thống năm nhuận Gregorian, làm cho hệ thống lịch chính xác hơn trong nhiều thiên niên kỷ. Để làm điều này, mỗi thiên niên kỷ thứ tư trong kỷ nguyên của chúng ta (năm 4000) phải được tính là năm không nhuận.\n\n'
          'Việc sử dụng tuần cố định trong Lịch Trung Lập sẽ tạo thuận lợi cho hoạt động của xã hội dân sự trên toàn thế giới. Bằng cách này, 27 ngày làm việc sẽ ổn định rơi vào mỗi tháng hàng năm, và mỗi ngày trong lịch được gắn với một ngày cụ thể trong tuần.\n\n'
          'Việc đặt tên riêng cho các tháng sẽ phục vụ cho việc tăng cường mối quan hệ văn hóa của các dân tộc trên toàn thế giới, và cũng sẽ không gây ra sự nhầm lẫn không phù hợp giữa các dự án lịch được đề xuất.',
      'aboutReformCalendarText':
          'Về Cải Cách Lịch và Dự Án Lịch Toàn Cơ Đốc Giáo.\n\n'
          'Chủ đề cải cách lịch Gregorian đã được thảo luận từ thiên niên kỷ trước và vì nhiều lý do và hoàn cảnh khác nhau đã bị hoãn lại vô thời hạn. Dự án lịch của nhà văn và nhà thiên văn người Pháp Amerlin, sau này được gọi là «Y2K» (Lịch Thế giới), cũng đã bị Liên Hợp Quốc bác bỏ vào năm 1956.\n\n'
          'Để tránh những bất đồng về lịch giữa nhà thờ và xã hội dân sự, người ta đề xuất đồng thời giới thiệu cả Lịch Toàn Cơ Đốc Giáo lẫn Lịch Trung Lập Quốc Tế. Như đã biết, thực tế nhất là tiến hành cải cách vào năm bắt đầu vào Chủ nhật và kết thúc vào Chủ nhật. Năm gần nhất như vậy sẽ là năm 2034.\n\n'
          'Bây giờ một chút về dự án Lịch Toàn Cơ Đốc Giáo. Nếu tuần liên tục truyền thống được áp dụng cho cấu trúc nội bộ của dự án Lịch Trung Lập Quốc Tế, trong khi giữ nguyên tên các tháng, thì không có dự án Lịch Toàn Cơ Đốc Giáo nào tốt hơn có thể được trình bày. Chủ yếu, dự án này sẽ đáp ứng các yêu cầu của tất cả các nhà thờ Cơ Đốc Giáo và sẽ phục vụ cho việc tăng cường mối quan hệ giữa các nhà thờ khác nhau trên thế giới.',
    },
    'id': {
      'appTitle': 'Kalender Netral',
      'calendar': 'Gaya Netral',
      'normalCalendar': 'Kalender Gregorian',
      'neutralCalendar': 'Kalender Netral',
      'comparison': 'Gaya Gabungan',
      'converter': 'Konverter',
      'settings': 'Pengaturan',
      'lockScreen': 'Gaya Layar Kunci',
      'lockTextVariant': 'Gaya layar kunci',
      'lockTextBoth': 'Semua gaya',
      'lockTextNeutralOnly': 'Netral',
      'lockTextGregorianOnly': 'Gregorian',
      'lockTextTimer': 'Timer',
      'lockTextStopwatch': 'Stopwatch',
      'lockImageLabel': 'Gambar untuk layar kunci',
      'lockFontStyle': 'Font layar kunci',
      'lockFontDefault': 'Bawaan',
      'lockFontSerif': 'Serif',
      'lockFontMono': 'Mono',
      'lockColorLabel': 'Warna layar kunci',
      'lockScreenChanged': 'Layar kunci diperbarui — ketuk untuk pratinjau',
      'preview': 'Pratinjau',
      'language': 'Bahasa',
      'january': 'Januari',
      'february': 'Februari',
      'march': 'Maret',
      'april': 'April',
      'may': 'Mei',
      'june': 'Juni',
      'july': 'Juli',
      'august': 'Agustus',
      'september': 'September',
      'october': 'Oktober',
      'november': 'November',
      'december': 'Desember',
      'adam': 'Adam',
      'eve': 'Hawa',
      'noah': 'Nuh',
      'abraham': 'Ibrahim',
      'moses': 'Musa',
      'icon': 'Ikon',
      'ilham': 'Ilham',
      'avesta': 'Avesta',
      'shinto': 'Shinto',
      'aqdas': 'Aqdas',
      'nirvana': 'Nirwana',
      'dharma': 'Dharma',
      'monday': 'Sen',
      'tuesday': 'Sel',
      'wednesday': 'Rab',
      'thursday': 'Kam',
      'friday': 'Jum',
      'saturday': 'Sab',
      'sunday': 'Min',
      'convertDate': 'Konversi Tanggal',
      'selectDate': 'Pilih Tanggal',
      'today': 'Hari Ini',
      'leapYear': 'Bulan kabisat',
      'leapDay': 'Hari kabisat ✦',
      'leapDayShort': 'Kab. ✦',
      'specialDay': 'Hari spesial',
      'from': 'Dari',
      'aboutCalendar': 'Tentang Kalender Netral',
      'howToUse': 'Cara penggunaan',
      'aboutReformCalendar': 'Tentang Reformasi Kalender',
      'monthNames': 'Nama bulan',
      'gregorianMonths': 'Gregorian',
      'neutralMonths': 'Netral',
      'gregorianStyle': 'Gaya Gregorian',
      'darkMode': 'Mode gelap',
      'darkModeOn': 'Gelap',
      'lightModeOn': 'Terang',
      'lockGallery': 'Galeri',
      'combinationOfStyles': 'Gabungan gaya',
      'allChristian': 'Semua Kristen',
      'website': 'Situs web',
      'contactEmail': 'Email',
      'aboutCalendarText':
          'Tentang Kalender Netral Internasional (Proyek)\n\n'
          'Kalender dibagi menjadi kalender lunar, luni-solar, dan solar. Kalender solar yang paling umum adalah kalender Gregorian (gaya baru), tetapi ia juga memiliki kekurangannya. Terutama, ini adalah distribusi hari yang tidak proporsional dalam bulan, kuartal, dan semester. Proyek Kalender Netral memaksimalkan penghapusan kekurangan-kekurangan ini dan berkat penambahan pada sistem tahun kabisat Gregorian, membuat sistem kalender lebih akurat selama banyak milenium. Untuk ini, setiap milenium keempat era kita (tahun 4000) harus dihitung sebagai tahun non-kabisat.\n\n'
          'Penggunaan minggu tetap dalam Kalender Netral akan memudahkan pekerjaan masyarakat sipil di seluruh dunia. Dengan cara ini, 27 hari kerja akan secara stabil jatuh pada setiap bulan setiap tahun, dan setiap tanggal kalender ditetapkan pada hari tertentu dalam seminggu.\n\n'
          'Penamaan bulan yang berbeda akan berfungsi untuk memperkuat persaudaraan budaya masyarakat di seluruh dunia, dan juga tidak akan menimbulkan kebingungan yang tidak tepat di antara proyek-proyek kalender yang diusulkan.',
      'aboutReformCalendarText':
          'Tentang Reformasi Kalender dan Proyek Kalender Pan-Kristen.\n\n'
          'Topik reformasi kalender Gregorian telah berlangsung sejak milenium lalu dan karena berbagai alasan dan keadaan telah ditunda tanpa batas waktu. Proyek kalender penulis dan astronom Prancis Amerlin, yang kemudian dikenal sebagai «Y2K» (Kalender Dunia), juga ditolak oleh PBB pada tahun 1956.\n\n'
          'Agar tidak terjadi perselisihan kalender antara gereja dan masyarakat sipil, diusulkan pengenalan secara bersamaan baik Kalender Pan-Kristen maupun Kalender Netral Internasional. Seperti diketahui, cara paling praktis untuk melaksanakan reformasi adalah pada tahun yang dimulai pada hari Minggu dan diakhiri pada hari Minggu. Tahun terdekat seperti itu adalah tahun 2034.\n\n'
          'Sekarang sedikit tentang proyek Kalender Pan-Kristen. Jika minggu berkesinambungan klasik diterapkan pada struktur internal proyek Kalender Netral Internasional, sementara nama-nama bulan tetap sama, maka proyek Kalender Pan-Kristen yang lebih baik tidak bisa disajikan. Terutama, proyek ini akan memenuhi persyaratan semua gereja Kristen dan akan berfungsi untuk memperkuat hubungan antara berbagai gereja di dunia.',
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ru', 'tk', 'es', 'fr', 'pt', 'de', 'it', 'tr', 'vi', 'id']
        .contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
