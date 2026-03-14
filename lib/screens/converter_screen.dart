import 'package:flutter/material.dart';
import '../l10n/app_localizations_manual.dart';
import '../utils/click_sound.dart';
import '../models/calendar_date.dart';
import '../models/calendar_type.dart';
import '../services/calendar_converter.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  DateTime _selectedDate = DateTime.now();
  CalendarType _sourceCalendar = CalendarType.normal;
  CalendarDate? _convertedDate;

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

  void _convertDate() {
    playClick();
    final sourceDate = _getDisplayDate();

    setState(() {
      if (_sourceCalendar == CalendarType.normal) {
        _convertedDate = CalendarConverter.normalToNeutral(sourceDate);
      } else {
        _convertedDate = CalendarConverter.neutralToNormal(sourceDate);
      }
    });
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
          _convertedDate = null;
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
          _convertedDate = null;
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
        return _NeutralDatePickerDialog(initialDate: initialDate);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.converter)),
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
                    Text(
                      localizations.from,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
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
                          _convertedDate = null;
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

            // Convert Button
            FilledButton.icon(
              onPressed: _convertDate,
              icon: const Icon(Icons.sync_alt),
              label: Text(localizations.convertDate),
              style: FilledButton.styleFrom(padding: const EdgeInsets.all(20)),
            ),
            const SizedBox(height: 24),

            // Result
            if (_convertedDate != null)
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 48,
                        color: Colors.green.shade700,
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
                        _formatDate(localizations, _convertedDate!),
                        style: Theme.of(context).textTheme.titleLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
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

  const _NeutralDatePickerDialog({required this.initialDate});

  @override
  State<_NeutralDatePickerDialog> createState() =>
      _NeutralDatePickerDialogState();
}

class _NeutralDatePickerDialogState extends State<_NeutralDatePickerDialog> {
  late int _currentYear;
  late int _currentMonth;
  late int _selectedDay;

  @override
  void initState() {
    super.initState();
    _currentYear = widget.initialDate.year;
    _currentMonth = widget.initialDate.month;
    _selectedDay = widget.initialDate.day;
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

  String _getMonthName(AppLocalizations localizations, int month) {
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
  }

  String _getWeekdayName(AppLocalizations localizations, int weekday) {
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

  int _getWeekdayForDay(int year, int month, int day) {
    // Calculate day of year for Neutral calendar
    int dayOfYear = 0;
    for (int m = 1; m < month; m++) {
      dayOfYear += CalendarConverter.getDaysInMonthNeutral(year, m);
    }
    dayOfYear += day;

    // Neutral year starts on Sunday (day 1 = Sunday)
    return (dayOfYear - 1) % 7;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final daysInMonth = CalendarConverter.getDaysInMonthNeutral(
      _currentYear,
      _currentMonth,
    );

    // Get the weekday of the first day of the month
    final firstDayWeekday = _getWeekdayForDay(_currentYear, _currentMonth, 1);

    return Dialog(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Month/Year navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.chevron_left, size: 22),
                    onPressed: _previousMonth,
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(),
                  ),
                ),
                Text(
                  '${_getMonthName(localizations, _currentMonth)} $_currentYear',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.chevron_right, size: 22),
                    onPressed: _nextMonth,
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Weekday headers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                return Expanded(
                  child: Center(
                    child: Text(
                      _getWeekdayName(localizations, index)[0],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: index == 0 ? Colors.red : null, // Sunday
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            // Calendar grid
            SizedBox(
              height: 240,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1,
                ),
                itemCount: 42, // 6 weeks
                itemBuilder: (context, index) {
                  final dayNumber = index - firstDayWeekday + 1;

                  if (dayNumber < 1 || dayNumber > daysInMonth) {
                    return const SizedBox.shrink();
                  }

                  final isSelected =
                      dayNumber == _selectedDay &&
                      _currentMonth == widget.initialDate.month &&
                      _currentYear == widget.initialDate.year;

                  final isSunCol = index % 7 == 0;

                  return InkWell(
                    onTap: () {
                      playClick();
                      setState(() {
                        _selectedDay = dayNumber;
                      });
                      Navigator.of(context).pop(
                        CalendarDate(
                          year: _currentYear,
                          month: _currentMonth,
                          day: dayNumber,
                          calendarType: CalendarType.neutral,
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : null,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$dayNumber',
                          style: TextStyle(
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : (isSunCol
                                    ? Colors.red
                                    : Theme.of(context).colorScheme.onSurface),
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () { playClick(); Navigator.of(context).pop(); },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
