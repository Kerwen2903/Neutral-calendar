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
  CalendarType _sourceCalendar = CalendarType.normal;
  late int _currentYear;
  late int _currentMonth;
  int? _selectedDay;
  CalendarDate? _convertedDate;
  bool _slideForward = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentYear = now.year;
    _currentMonth = now.month;
    _selectedDay = now.day;
    _autoConvert();
  }

  String _getMonthName(
    AppLocalizations localizations,
    int month,
    bool useNeutral,
  ) {
    if (useNeutral) {
      switch (month) {
        case 1: return localizations.adam;
        case 2: return localizations.eve;
        case 3: return localizations.noah;
        case 4: return localizations.abraham;
        case 5: return localizations.moses;
        case 6: return localizations.icon;
        case 7: return localizations.ilham;
        case 8: return localizations.avesta;
        case 9: return localizations.shinto;
        case 10: return localizations.aqdas;
        case 11: return localizations.nirvana;
        case 12: return localizations.dharma;
        default: return '';
      }
    } else {
      switch (month) {
        case 1: return localizations.january;
        case 2: return localizations.february;
        case 3: return localizations.march;
        case 4: return localizations.april;
        case 5: return localizations.may;
        case 6: return localizations.june;
        case 7: return localizations.july;
        case 8: return localizations.august;
        case 9: return localizations.september;
        case 10: return localizations.october;
        case 11: return localizations.november;
        case 12: return localizations.december;
        default: return '';
      }
    }
  }

  String _getWeekdayName(AppLocalizations localizations, int weekday) {
    // weekday: 0=Sunday, 1=Monday, ..., 6=Saturday
    switch (weekday) {
      case 0: return localizations.sunday;
      case 1: return localizations.monday;
      case 2: return localizations.tuesday;
      case 3: return localizations.wednesday;
      case 4: return localizations.thursday;
      case 5: return localizations.friday;
      case 6: return localizations.saturday;
      default: return '';
    }
  }

  int _getNeutralWeekday(CalendarDate neutralDate) {
    int dayOfYear = 0;
    for (int m = 1; m < neutralDate.month; m++) {
      dayOfYear += CalendarConverter.getDaysInMonthNeutral(neutralDate.year, m);
    }
    dayOfYear += neutralDate.day;
    return (dayOfYear - 1) % 7;
  }

  int _getNormalWeekday(CalendarDate normalDate) {
    final dt = DateTime(normalDate.year, normalDate.month, normalDate.day);
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

  int _daysInCurrentMonth() {
    if (_sourceCalendar == CalendarType.normal) {
      return CalendarConverter.getDaysInMonthNormal(_currentYear, _currentMonth);
    } else {
      return CalendarConverter.getDaysInMonthNeutral(_currentYear, _currentMonth);
    }
  }

  /// First weekday offset for Mon–Sun layout (0=Mon, 6=Sun).
  int _firstWeekdayOffset() {
    if (_sourceCalendar == CalendarType.normal) {
      final wd = DateTime(_currentYear, _currentMonth, 1).weekday; // 1=Mon…7=Sun
      return wd - 1;
    } else {
      // Neutral: year starts on Sunday → day 1 weekday = Sunday
      int totalDays = 0;
      for (int m = 1; m < _currentMonth; m++) {
        totalDays += CalendarConverter.getDaysInMonthNeutral(_currentYear, m);
      }
      // Neutral day 1 = Sunday. In Mon-Sun layout, Sunday = index 6.
      return (6 + totalDays) % 7;
    }
  }

  void _autoConvert() {
    if (_selectedDay == null) {
      _convertedDate = null;
      return;
    }
    if (_sourceCalendar == CalendarType.normal) {
      final source = CalendarDate(
        year: _currentYear,
        month: _currentMonth,
        day: _selectedDay!,
        calendarType: CalendarType.normal,
      );
      _convertedDate = CalendarConverter.normalToNeutral(source);
    } else {
      final source = CalendarDate(
        year: _currentYear,
        month: _currentMonth,
        day: _selectedDay!,
        calendarType: CalendarType.neutral,
      );
      _convertedDate = CalendarConverter.neutralToNormal(source);
    }
  }

  void _onDaySelected(int day) {
    playClick();
    setState(() {
      _selectedDay = day;
      _autoConvert();
    });
  }

  void _previousMonth() {
    playClick();
    setState(() {
      _slideForward = false;
      if (_currentMonth == 1) {
        _currentMonth = 12;
        _currentYear--;
      } else {
        _currentMonth--;
      }
      _selectedDay = null;
      _convertedDate = null;
    });
  }

  void _nextMonth() {
    playClick();
    setState(() {
      _slideForward = true;
      if (_currentMonth == 12) {
        _currentMonth = 1;
        _currentYear++;
      } else {
        _currentMonth++;
      }
      _selectedDay = null;
      _convertedDate = null;
    });
  }

  void _switchCalendar(CalendarType type) {
    if (type == _sourceCalendar) return;
    playClick();

    // If we have a selected date, convert it to the new source calendar
    if (_selectedDay != null && _convertedDate != null) {
      setState(() {
        // The old result becomes the new input
        _currentYear = _convertedDate!.year;
        _currentMonth = _convertedDate!.month;
        _selectedDay = _convertedDate!.day;
        _sourceCalendar = type;
        _autoConvert();
      });
    } else {
      setState(() {
        final now = DateTime.now();
        if (type == CalendarType.neutral) {
          final todayNeutral = CalendarConverter.normalToNeutral(
            CalendarDate(
              year: now.year,
              month: now.month,
              day: now.day,
              calendarType: CalendarType.normal,
            ),
          );
          _currentYear = todayNeutral.year;
          _currentMonth = todayNeutral.month;
          _selectedDay = todayNeutral.day;
        } else {
          _currentYear = now.year;
          _currentMonth = now.month;
          _selectedDay = now.day;
        }
        _sourceCalendar = type;
        _autoConvert();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isNeutral = _sourceCalendar == CalendarType.neutral;
    final daysInMonth = _daysInCurrentMonth();
    final firstWeekday = _firstWeekdayOffset();

    return Scaffold(
      appBar: AppBar(title: Text(localizations.converter)),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity == null) return;
          if (details.primaryVelocity! < -200) {
            _nextMonth();
          } else if (details.primaryVelocity! > 200) {
            _previousMonth();
          }
        },
        child: Column(
          children: [
            // Source Calendar Selection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SegmentedButton<CalendarType>(
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
                  _switchCalendar(newSelection.first);
                },
              ),
            ),

            // Month navigation header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleArrow(Icons.chevron_left, _previousMonth),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) {
                      final offsetTween = Tween<Offset>(
                        begin: Offset(_slideForward ? 1.0 : -1.0, 0),
                        end: Offset.zero,
                      );
                      return SlideTransition(
                        position: offsetTween.animate(
                          CurvedAnimation(
                              parent: animation, curve: Curves.easeInOut),
                        ),
                        child: child,
                      );
                    },
                    child: Text(
                      '${_getMonthName(localizations, _currentMonth, isNeutral)} $_currentYear',
                      key: ValueKey('$_currentYear-$_currentMonth-$isNeutral'),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                    ),
                  ),
                  _circleArrow(Icons.chevron_right, _nextMonth),
                ],
              ),
            ),

            // Weekday headers
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  _buildWeekdayHeader(localizations.monday),
                  _buildWeekdayHeader(localizations.tuesday),
                  _buildWeekdayHeader(localizations.wednesday),
                  _buildWeekdayHeader(localizations.thursday),
                  _buildWeekdayHeader(localizations.friday),
                  _buildWeekdayHeader(localizations.saturday),
                  _buildWeekdayHeader(localizations.sunday, isSunday: true),
                ],
              ),
            ),

            // Calendar grid with animation
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  final offsetTween = Tween<Offset>(
                    begin: Offset(_slideForward ? 1.0 : -1.0, 0),
                    end: Offset.zero,
                  );
                  return SlideTransition(
                    position: offsetTween.animate(
                      CurvedAnimation(
                          parent: animation, curve: Curves.easeInOut),
                    ),
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  key: ValueKey(
                      'conv-$_currentYear-$_currentMonth-$isNeutral'),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: firstWeekday + daysInMonth,
                    itemBuilder: (context, index) {
                      if (index < firstWeekday) {
                        return const SizedBox();
                      }

                      final day = index - firstWeekday + 1;
                      final isSelected = _selectedDay == day;
                      final isSundayCell = index % 7 == 6;

                      // Today detection
                      bool isToday;
                      if (_sourceCalendar == CalendarType.normal) {
                        isToday = DateTime.now().year == _currentYear &&
                            DateTime.now().month == _currentMonth &&
                            DateTime.now().day == day;
                      } else {
                        final todayNeutral =
                            CalendarConverter.normalToNeutral(
                          CalendarDate(
                            year: DateTime.now().year,
                            month: DateTime.now().month,
                            day: DateTime.now().day,
                            calendarType: CalendarType.normal,
                          ),
                        );
                        isToday = todayNeutral.year == _currentYear &&
                            todayNeutral.month == _currentMonth &&
                            todayNeutral.day == day;
                      }

                      return _buildDayCell(
                        day,
                        isToday,
                        isSelected,
                        isSundayCell: isSundayCell,
                      );
                    },
                  ),
                ),
              ),
            ),

            // Result card
            if (_convertedDate != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  children: [
                    Text(
                      _sourceCalendar == CalendarType.normal
                          ? localizations.neutralCalendar
                          : localizations.normalCalendar,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.green.shade700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(localizations, _convertedDate!),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _circleArrow(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
      ),
      child: IconButton(
        icon: Icon(icon, size: 24),
        onPressed: onPressed,
        padding: const EdgeInsets.all(6),
        constraints: const BoxConstraints(),
      ),
    );
  }

  Widget _buildWeekdayHeader(String text, {bool isSunday = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSunday
                ? Colors.red
                : Theme.of(context).colorScheme.primary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildDayCell(
    int day,
    bool isToday,
    bool isSelected, {
    bool isSundayCell = false,
  }) {
    Color backgroundColor;
    Color textColor;
    BoxDecoration decoration;

    if (isSelected) {
      backgroundColor = Theme.of(context).colorScheme.primary;
      textColor = Theme.of(context).colorScheme.onPrimary;
      decoration = BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      );
    } else if (isToday) {
      backgroundColor = Theme.of(context).colorScheme.primaryContainer;
      textColor = Theme.of(context).colorScheme.onPrimaryContainer;
      decoration = BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      );
    } else {
      backgroundColor = Colors.transparent;
      textColor = isSundayCell
          ? Colors.red
          : Theme.of(context).colorScheme.onSurface;
      decoration = BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      );
    }

    return InkWell(
      onTap: () => _onDaySelected(day),
      borderRadius: BorderRadius.circular(50),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: decoration,
        child: Center(
          child: Text(
            day.toString(),
            style: TextStyle(
              color: textColor,
              fontWeight:
                  (isToday || isSelected) ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
