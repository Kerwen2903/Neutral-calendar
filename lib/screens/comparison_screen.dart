import 'package:flutter/material.dart';
import '../l10n/app_localizations_manual.dart';
import '../utils/click_sound.dart';
import '../widgets/calendar_month_widget.dart';
import '../models/calendar_type.dart';
import '../models/calendar_date.dart';
import '../services/calendar_converter.dart';
import '../main.dart';

class ComparisonScreen extends StatefulWidget {
  const ComparisonScreen({super.key});

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  int _normalYear = DateTime.now().year;
  int _normalMonth = DateTime.now().month;
  int _neutralYear = DateTime.now().year;
  int _neutralMonth = DateTime.now().month;
  CalendarDate? _selectedNormalDate;
  CalendarDate? _selectedNeutralDate;

  void _previousMonth() {
    playClick();
    setState(() {
      // Navigate both calendars to previous month
      if (_normalMonth == 1) {
        _normalMonth = 12;
        _normalYear--;
      } else {
        _normalMonth--;
      }
      if (_neutralMonth == 1) {
        _neutralMonth = 12;
        _neutralYear--;
      } else {
        _neutralMonth--;
      }
      _selectedNormalDate = null;
      _selectedNeutralDate = null;
    });
  }

  void _nextMonth() {
    playClick();
    setState(() {
      // Navigate both calendars to next month
      if (_normalMonth == 12) {
        _normalMonth = 1;
        _normalYear++;
      } else {
        _normalMonth++;
      }
      if (_neutralMonth == 12) {
        _neutralMonth = 1;
        _neutralYear++;
      } else {
        _neutralMonth++;
      }
      _selectedNormalDate = null;
      _selectedNeutralDate = null;
    });
  }

  void _onNormalDaySelected(int day) {
    setState(() {
      _selectedNormalDate = CalendarDate(
        year: _normalYear,
        month: _normalMonth,
        day: day,
        calendarType: CalendarType.normal,
      );
      _selectedNeutralDate = CalendarConverter.normalToNeutral(
        _selectedNormalDate!,
      );
      // Navigate neutral calendar to the month of the converted date
      _neutralYear = _selectedNeutralDate!.year;
      _neutralMonth = _selectedNeutralDate!.month;
    });
  }

  void _onNeutralDaySelected(int day) {
    setState(() {
      _selectedNeutralDate = CalendarDate(
        year: _neutralYear,
        month: _neutralMonth,
        day: day,
        calendarType: CalendarType.neutral,
      );
      _selectedNormalDate = CalendarConverter.neutralToNormal(
        _selectedNeutralDate!,
      );
      // Navigate normal calendar to the month of the converted date
      _normalYear = _selectedNormalDate!.year;
      _normalMonth = _selectedNormalDate!.month;
    });
  }

  void _onNormalPreviousMonthDaySelected(int year, int month, int day) {
    setState(() {
      _normalYear = year;
      _normalMonth = month;
      _selectedNormalDate = CalendarDate(
        year: year,
        month: month,
        day: day,
        calendarType: CalendarType.normal,
      );
      _selectedNeutralDate = CalendarConverter.normalToNeutral(
        _selectedNormalDate!,
      );
      _neutralYear = _selectedNeutralDate!.year;
      _neutralMonth = _selectedNeutralDate!.month;
    });
  }

  void _onNormalNextMonthDaySelected(int year, int month, int day) {
    setState(() {
      _normalYear = year;
      _normalMonth = month;
      _selectedNormalDate = CalendarDate(
        year: year,
        month: month,
        day: day,
        calendarType: CalendarType.normal,
      );
      _selectedNeutralDate = CalendarConverter.normalToNeutral(
        _selectedNormalDate!,
      );
      _neutralYear = _selectedNeutralDate!.year;
      _neutralMonth = _selectedNeutralDate!.month;
    });
  }

  void _onNeutralPreviousMonthDaySelected(int year, int month, int day) {
    setState(() {
      _neutralYear = year;
      _neutralMonth = month;
      _selectedNeutralDate = CalendarDate(
        year: year,
        month: month,
        day: day,
        calendarType: CalendarType.neutral,
      );
      _selectedNormalDate = CalendarConverter.neutralToNormal(
        _selectedNeutralDate!,
      );
      _normalYear = _selectedNormalDate!.year;
      _normalMonth = _selectedNormalDate!.month;
    });
  }

  void _onNeutralNextMonthDaySelected(int year, int month, int day) {
    setState(() {
      _neutralYear = year;
      _neutralMonth = month;
      _selectedNeutralDate = CalendarDate(
        year: year,
        month: month,
        day: day,
        calendarType: CalendarType.neutral,
      );
      _selectedNormalDate = CalendarConverter.neutralToNormal(
        _selectedNeutralDate!,
      );
      _normalYear = _selectedNormalDate!.year;
      _normalMonth = _selectedNormalDate!.month;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final appState = NeutralCalendarApp.of(context);
    final useNeutral = appState?.useNeutralMonthNames ?? true;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.comparison),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              playClick();
              setState(() {
                _normalYear = DateTime.now().year;
                _normalMonth = DateTime.now().month;
                _neutralYear = DateTime.now().year;
                _neutralMonth = DateTime.now().month;
                _onNormalDaySelected(DateTime.now().day);
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Month navigation
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _previousMonth,
                ),
                Text(
                  '${_getMonthName(localizations, _normalMonth, false)} $_normalYear / ${_getMonthName(localizations, _neutralMonth, useNeutral)} $_neutralYear',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _nextMonth,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 4.0,
              ),
              child: Column(
                children: [
                  // Normal Calendar
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              '${localizations.normalCalendar} - ${_getMonthName(localizations, _normalMonth, false)}',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Expanded(
                              child: CalendarMonthWidget(
                                year: _normalYear,
                                month: _normalMonth,
                                calendarType: CalendarType.normal,
                                selectedDay:
                                    _selectedNormalDate?.year == _normalYear &&
                                        _selectedNormalDate?.month ==
                                            _normalMonth
                                    ? _selectedNormalDate?.day
                                    : null,
                                onDaySelected: _onNormalDaySelected,
                                onPreviousMonthDaySelected:
                                    _onNormalPreviousMonthDaySelected,
                                onNextMonthDaySelected:
                                    _onNormalNextMonthDaySelected,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Neutral Calendar
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              '${localizations.neutralCalendar} - ${_getMonthName(localizations, _neutralMonth, true)}',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Expanded(
                              child: CalendarMonthWidget(
                                year: _neutralYear,
                                month: _neutralMonth,
                                calendarType: CalendarType.neutral,
                                selectedDay:
                                    _selectedNeutralDate?.year ==
                                            _neutralYear &&
                                        _selectedNeutralDate?.month ==
                                            _neutralMonth
                                    ? _selectedNeutralDate?.day
                                    : null,
                                onDaySelected: _onNeutralDaySelected,
                                onPreviousMonthDaySelected:
                                    _onNeutralPreviousMonthDaySelected,
                                onNextMonthDaySelected:
                                    _onNeutralNextMonthDaySelected,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
}
