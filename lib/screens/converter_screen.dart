import 'package:flutter/material.dart';
import '../l10n/app_localizations_manual.dart';
import '../utils/click_sound.dart';
import '../models/calendar_date.dart';
import '../models/calendar_type.dart';
import '../services/calendar_converter.dart';
import 'lock_screen.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  DateTime _selectedDate = DateTime.now();
  CalendarType _sourceCalendar = CalendarType.normal;
  late CalendarDate _convertedDate;

  @override
  void initState() {
    super.initState();
    _convert();
  }

  void _convert() {
    final sourceDate = _getDisplayDate();
    if (_sourceCalendar == CalendarType.normal) {
      _convertedDate = CalendarConverter.normalToNeutral(sourceDate);
    } else {
      _convertedDate = CalendarConverter.neutralToNormal(sourceDate);
    }
  }

  String _getMonthName(
    AppLocalizations localizations,
    int month,
    bool useNeutral,
  ) {
    if (useNeutral) {
      switch (month) {
        case 1:
          return localizations.adam;
        case 2:
          return localizations.eve;
        case 3:
          return localizations.noah;
        case 4:
          return localizations.abraham;
        case 5:
          return localizations.moses;
        case 6:
          return localizations.icon;
        case 7:
          return localizations.ilham;
        case 8:
          return localizations.avesta;
        case 9:
          return localizations.shinto;
        case 10:
          return localizations.aqdas;
        case 11:
          return localizations.nirvana;
        case 12:
          return localizations.dharma;
        default:
          return '';
      }
    } else {
      switch (month) {
        case 1:
          return localizations.january;
        case 2:
          return localizations.february;
        case 3:
          return localizations.march;
        case 4:
          return localizations.april;
        case 5:
          return localizations.may;
        case 6:
          return localizations.june;
        case 7:
          return localizations.july;
        case 8:
          return localizations.august;
        case 9:
          return localizations.september;
        case 10:
          return localizations.october;
        case 11:
          return localizations.november;
        case 12:
          return localizations.december;
        default:
          return '';
      }
    }
  }

  String _getWeekdayName(AppLocalizations localizations, int weekday) {
    // weekday: 0=Sunday, 1=Monday, ..., 6=Saturday
    switch (weekday) {
      case 0:
        return localizations.sunday;
      case 1:
        return localizations.monday;
      case 2:
        return localizations.tuesday;
      case 3:
        return localizations.wednesday;
      case 4:
        return localizations.thursday;
      case 5:
        return localizations.friday;
      case 6:
        return localizations.saturday;
      default:
        return '';
    }
  }

  int _getNeutralWeekday(CalendarDate neutralDate) {
    // Neutral year starts on Sunday
    // Calculate day of year first
    int dayOfYear = 0;
    for (int m = 1; m < neutralDate.month; m++) {
      dayOfYear += CalendarConverter.getDaysInMonthNeutral(neutralDate.year, m);
    }
    dayOfYear += neutralDate.day;

    // Day 1 is Sunday, so weekday = (dayOfYear - 1) % 7
    // 0=Sunday, 1=Monday, ..., 6=Saturday
    return (dayOfYear - 1) % 7;
  }

  int _getNormalWeekday(CalendarDate normalDate) {
    // Use DateTime to get weekday
    final dt = DateTime(normalDate.year, normalDate.month, normalDate.day);
    // DateTime.weekday: 1=Monday, ..., 7=Sunday
    // Convert to: 0=Sunday, 1=Monday, ..., 6=Saturday
    return dt.weekday % 7;
  }

  String _formatDate(AppLocalizations localizations, CalendarDate date) {
    final monthName = _getMonthName(
      localizations,
      date.month,
      date.calendarType == CalendarType.neutral,
    );
    final weekday = date.calendarType == CalendarType.neutral
        ? _getNeutralWeekday(date)
        : _getNormalWeekday(date);
    final weekdayName = _getWeekdayName(localizations, weekday);

    return '$weekdayName, ${date.day} $monthName ${date.year}';
  }

  CalendarDate _getDisplayDate() {
    // Convert the selected DateTime to the appropriate calendar format for display
    if (_sourceCalendar == CalendarType.neutral) {
      // Convert Gregorian date to Neutral for display
      final normalDate = CalendarDate(
        year: _selectedDate.year,
        month: _selectedDate.month,
        day: _selectedDate.day,
        calendarType: CalendarType.normal,
      );
      return CalendarConverter.normalToNeutral(normalDate);
    } else {
      // Display as Gregorian (Normal)
      return CalendarDate(
        year: _selectedDate.year,
        month: _selectedDate.month,
        day: _selectedDate.day,
        calendarType: CalendarType.normal,
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    if (_sourceCalendar == CalendarType.normal) {
      // Use built-in date picker for Gregorian calendar
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null && picked != _selectedDate) {
        setState(() {
          _selectedDate = picked;
          _convert();
        });
      }
    } else {
      // Use custom date picker for Neutral calendar
      final neutralDate = _getDisplayDate();
      final CalendarDate? picked = await _showNeutralDatePicker(
        context,
        neutralDate,
      );
      if (picked != null) {
        // Convert back to Gregorian to store in _selectedDate
        final normalDate = CalendarConverter.neutralToNormal(picked);
        setState(() {
          _selectedDate = DateTime(
            normalDate.year,
            normalDate.month,
            normalDate.day,
          );
          _convert();
        });
      }
    }
  }

  Future<CalendarDate?> _showNeutralDatePicker(
    BuildContext context,
    CalendarDate initialDate,
  ) async {
    return showDialog<CalendarDate>(
      context: context,
      builder: (BuildContext context) {
        return _NeutralDatePickerDialog(
          initialDate: initialDate,
          localizations: AppLocalizations.of(context)!,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.converter),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_android),
            onPressed: () {
              playClick();
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (_, __, ___) => LockScreen(
                    standaloneRoute: true,
                    child: const SizedBox.shrink(),
                  ),
                  transitionDuration: Duration.zero,
                ),
              );
            },
            tooltip: localizations.lockScreen,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Source Calendar Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SegmentedButton<CalendarType>(
                      segments: [
                        ButtonSegment(
                          value: CalendarType.normal,
                          label: Text(localizations.normalCalendar),
                          icon: const Icon(Icons.calendar_today),
                        ),
                        ButtonSegment(
                          value: CalendarType.neutral,
                          label: Text(localizations.neutralCalendar),
                          icon: const Icon(Icons.calendar_month),
                        ),
                      ],
                      selected: {_sourceCalendar},
                      onSelectionChanged: (Set<CalendarType> newSelection) {
                        playClick();
                        setState(() {
                          _sourceCalendar = newSelection.first;
                          _convert();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Date Selection
            Card(
              child: InkWell(
                onTap: () { playClick(); _selectDate(context); },
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.event,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        localizations.selectDate,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatDate(localizations, _getDisplayDate()),
                        style: Theme.of(context).textTheme.titleLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Result (auto-converted)
            Card(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.green.shade900.withValues(alpha: 0.4)
                  : Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.sync_alt,
                      size: 48,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.green.shade300
                          : Colors.green.shade700,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _sourceCalendar == CalendarType.normal
                          ? localizations.neutralCalendar
                          : localizations.normalCalendar,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDate(localizations, _convertedDate),
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.green.shade300
                                : Colors.green.shade700,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NeutralDatePickerDialog extends StatefulWidget {
  final CalendarDate initialDate;
  final AppLocalizations localizations;

  const _NeutralDatePickerDialog({
    required this.initialDate,
    required this.localizations,
  });

  @override
  State<_NeutralDatePickerDialog> createState() =>
      _NeutralDatePickerDialogState();
}

class _NeutralDatePickerDialogState extends State<_NeutralDatePickerDialog> {
  late int _currentYear;
  late int _currentMonth;
  late int _selectedDay;
  late int _selectedMonth;
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _currentYear = widget.initialDate.year;
    _currentMonth = widget.initialDate.month;
    _selectedDay = widget.initialDate.day;
    _selectedMonth = widget.initialDate.month;
    _selectedYear = widget.initialDate.year;
  }

  void _previousMonth() {
    playClick();
    setState(() {
      if (_currentMonth == 1) {
        _currentMonth = 12;
        _currentYear--;
      } else {
        _currentMonth--;
      }
    });
  }

  void _nextMonth() {
    playClick();
    setState(() {
      if (_currentMonth == 12) {
        _currentMonth = 1;
        _currentYear++;
      } else {
        _currentMonth++;
      }
    });
  }

  String _getMonthName(int month) {
    final l = widget.localizations;
    switch (month) {
      case 1: return l.adam;
      case 2: return l.eve;
      case 3: return l.noah;
      case 4: return l.abraham;
      case 5: return l.moses;
      case 6: return l.icon;
      case 7: return l.ilham;
      case 8: return l.avesta;
      case 9: return l.shinto;
      case 10: return l.aqdas;
      case 11: return l.nirvana;
      case 12: return l.dharma;
      default: return '';
    }
  }

  String _getWeekdayShort(int weekday) {
    final l = widget.localizations;
    switch (weekday) {
      case 0: return l.sunday;
      case 1: return l.monday;
      case 2: return l.tuesday;
      case 3: return l.wednesday;
      case 4: return l.thursday;
      case 5: return l.friday;
      case 6: return l.saturday;
      default: return '';
    }
  }

  int _getWeekdayForDay(int year, int month, int day) {
    int dayOfYear = 0;
    for (int m = 1; m < month; m++) {
      dayOfYear += CalendarConverter.getDaysInMonthNeutral(year, m);
    }
    dayOfYear += day;
    return (dayOfYear - 1) % 7;
  }

  String _getFullWeekdayName(int weekday) {
    final l = widget.localizations;
    switch (weekday) {
      case 0: return l.sunday;
      case 1: return l.monday;
      case 2: return l.tuesday;
      case 3: return l.wednesday;
      case 4: return l.thursday;
      case 5: return l.friday;
      case 6: return l.saturday;
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = CalendarConverter.getDaysInMonthNeutral(
      _currentYear,
      _currentMonth,
    );

    final isLeapFeb =
        _currentMonth == 2 && CalendarConverter.isLeapYearNormal(_currentYear);

    final firstDayWeekday = _getWeekdayForDay(_currentYear, _currentMonth, 1);
    final gridRows = ((firstDayWeekday + daysInMonth) / 7).ceil();

    final colorScheme = Theme.of(context).colorScheme;
    final selectedWeekday = _getWeekdayForDay(_selectedYear, _selectedMonth, _selectedDay);

    return Dialog(
      clipBehavior: Clip.antiAlias,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 328),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header - matches Material DatePicker header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
              color: colorScheme.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.localizations.selectDate.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.onPrimary.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_getFullWeekdayName(selectedWeekday)}, ${_getMonthName(_selectedMonth)} $_selectedDay',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Calendar body
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Column(
                children: [
                  // Month/Year navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: _previousMonth,
                      ),
                      Text(
                        '${_getMonthName(_currentMonth)} $_currentYear',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: _nextMonth,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Weekday headers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(7, (index) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            _getWeekdayShort(index).substring(0, 1),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 4),
                  // Calendar grid
                  SizedBox(
                    height: isLeapFeb ? (gridRows + 1) * 40.0 : gridRows * 40.0,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final cellSize = constraints.maxWidth / 7;
                        return Stack(
                          children: [
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                mainAxisExtent: 40,
                              ),
                              itemCount: gridRows * 7,
                              itemBuilder: (context, index) {
                                final dayNumber = index - firstDayWeekday + 1;

                                if (dayNumber < 1 || dayNumber > daysInMonth) {
                                  return const SizedBox.shrink();
                                }

                                final isSelected =
                                    dayNumber == _selectedDay &&
                                    _currentMonth == _selectedMonth &&
                                    _currentYear == _selectedYear;

                                final now = DateTime.now();
                                final todayNeutral = CalendarConverter.normalToNeutral(
                                  CalendarDate(
                                    year: now.year,
                                    month: now.month,
                                    day: now.day,
                                    calendarType: CalendarType.normal,
                                  ),
                                );
                                final isToday = dayNumber == todayNeutral.day &&
                                    _currentMonth == todayNeutral.month &&
                                    _currentYear == todayNeutral.year;

                                return InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: () {
                                    playClick();
                                    setState(() {
                                      _selectedDay = dayNumber;
                                      _selectedMonth = _currentMonth;
                                      _selectedYear = _currentYear;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? colorScheme.primary
                                          : null,
                                      border: isToday && !isSelected
                                          ? Border.all(color: colorScheme.primary, width: 1.5)
                                          : null,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$dayNumber',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: isSelected
                                              ? colorScheme.onPrimary
                                              : colorScheme.onSurface,
                                          fontWeight: isSelected || isToday
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            // Leap day 31 for Neutral Feb in leap years
                            if (isLeapFeb)
                              Positioned(
                                top: gridRows * 40.0,
                                left: 3 * cellSize,
                                width: cellSize,
                                height: 40,
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: () {
                                    playClick();
                                    setState(() {
                                      _selectedDay = 31;
                                      _selectedMonth = _currentMonth;
                                      _selectedYear = _currentYear;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: (_selectedDay == 31 &&
                                              _selectedMonth == _currentMonth &&
                                              _selectedYear == _currentYear)
                                          ? colorScheme.primary
                                          : Colors.amber.shade100,
                                      shape: BoxShape.circle,
                                      border: (_selectedDay == 31 &&
                                              _selectedMonth == _currentMonth &&
                                              _selectedYear == _currentYear)
                                          ? null
                                          : Border.all(color: Colors.amber.shade600, width: 1.5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '31',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: (_selectedDay == 31 &&
                                                  _selectedMonth == _currentMonth &&
                                                  _selectedYear == _currentYear)
                                              ? colorScheme.onPrimary
                                              : Colors.orange.shade900,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Action buttons - matches Material DatePicker
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      playClick();
                      Navigator.of(context).pop();
                    },
                    child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      playClick();
                      Navigator.of(context).pop(
                        CalendarDate(
                          year: _selectedYear,
                          month: _selectedMonth,
                          day: _selectedDay,
                          calendarType: CalendarType.neutral,
                        ),
                      );
                    },
                    child: Text(MaterialLocalizations.of(context).okButtonLabel),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
