import 'package:flutter/material.dart';
import '../l10n/app_localizations_manual.dart';
import '../services/calendar_converter.dart';
import '../utils/click_sound.dart';
import 'comparison_screen.dart';

class GregorianCalendarScreen extends StatefulWidget {
  const GregorianCalendarScreen({super.key});

  @override
  State<GregorianCalendarScreen> createState() =>
      _GregorianCalendarScreenState();
}

class _GregorianCalendarScreenState extends State<GregorianCalendarScreen> {
  late int _currentYear;
  late int _currentMonth;
  DateTime _selectedDate = DateTime.now();
  bool _isYearView = false;
  bool _slideForward = true;

  @override
  void initState() {
    super.initState();
    _currentYear = DateTime.now().year;
    _currentMonth = DateTime.now().month;
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
    });
  }

  void _goToToday() {
    playClick();
    setState(() {
      _currentYear = DateTime.now().year;
      _currentMonth = DateTime.now().month;
      _selectedDate = DateTime.now();
    });
  }

  void _previousYear() {
    playClick();
    setState(() {
      _currentYear--;
    });
  }

  void _nextYear() {
    playClick();
    setState(() {
      _currentYear++;
    });
  }

  void _toggleView() {
    playClick();
    setState(() {
      _isYearView = !_isYearView;
    });
  }

  String _getMonthName(AppLocalizations localizations, int month) {
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

  /// First weekday offset for Mon–Sun layout.
  /// Returns 0 for Monday, 6 for Sunday.
  int _firstWeekdayOffset(int year, int month) {
    final wd = DateTime(year, month, 1).weekday; // 1=Mon … 7=Sun
    return wd - 1;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final daysInMonth =
        CalendarConverter.getDaysInMonthNormal(_currentYear, _currentMonth);
    final firstWeekday = _firstWeekdayOffset(_currentYear, _currentMonth);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.normalCalendar),
        actions: [
          IconButton(
            icon: Icon(
              _isYearView
                  ? Icons.calendar_view_month
                  : Icons.calendar_view_day,
            ),
            onPressed: _toggleView,
            tooltip: _isYearView ? 'Month View' : 'Year View',
          ),
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: _goToToday,
            tooltip: localizations.today,
          ),
          IconButton(
            icon: const Icon(Icons.compare_arrows),
            onPressed: () {
              playClick();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ComparisonScreen(),
                ),
              );
            },
            tooltip: localizations.comparison,
          ),
        ],
      ),
      body: _isYearView
          ? _buildYearView(localizations)
          : GestureDetector(
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
                  // Month navigation header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
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
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              transitionBuilder: (child, animation) {
                                final offsetTween = Tween<Offset>(
                                  begin:
                                      Offset(_slideForward ? 1.0 : -1.0, 0),
                                  end: Offset.zero,
                                );
                                return SlideTransition(
                                  position: offsetTween.animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeInOut,
                                    ),
                                  ),
                                  child: child,
                                );
                              },
                              child: Text(
                                '${_getMonthName(localizations, _currentMonth)} $_currentYear',
                                key: ValueKey('$_currentYear-$_currentMonth'),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                              ),
                            ),
                            if (_currentMonth == 2 &&
                                CalendarConverter.isLeapYearNormal(
                                    _currentYear))
                              Container(
                                margin: const EdgeInsets.only(top: 3),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade400,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '✦ Leap Year',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange.shade900,
                                  ),
                                ),
                              ),
                          ],
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
                        _buildWeekdayHeader(localizations.sunday,
                            isSunday: true),
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
                              parent: animation,
                              curve: Curves.easeInOut,
                            ),
                          ),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: Padding(
                        key: ValueKey(
                            'greg-$_currentYear-$_currentMonth'),
                        padding: const EdgeInsets.all(8),
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
                            final isToday =
                                DateTime.now().year == _currentYear &&
                                    DateTime.now().month == _currentMonth &&
                                    DateTime.now().day == day;

                            final isSelected =
                                _selectedDate.year == _currentYear &&
                                    _selectedDate.month == _currentMonth &&
                                    _selectedDate.day == day;

                            final isSundayCell = index % 7 == 6;

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

    if (isToday) {
      backgroundColor = Theme.of(context).colorScheme.primary;
      textColor = Theme.of(context).colorScheme.onPrimary;
      decoration = BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      );
    } else if (isSelected) {
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
      onTap: () {
        playClick();
        setState(() {
          _selectedDate = DateTime(_currentYear, _currentMonth, day);
        });
      },
      borderRadius: BorderRadius.circular(50),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: decoration,
        child: Center(
          child: Text(
            day.toString(),
            style: TextStyle(
              color: textColor,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildYearView(AppLocalizations localizations) {
    return Column(
      children: [
        // Year navigation header
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
              _circleArrow(Icons.chevron_left, _previousYear),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$_currentYear',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer,
                        ),
                  ),
                  if (CalendarConverter.isLeapYearNormal(_currentYear)) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '✦ Leap',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              _circleArrow(Icons.chevron_right, _nextYear),
            ],
          ),
        ),
        // Months grid
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.85,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                final month = index + 1;
                return _buildMonthCard(month, localizations);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthCard(int month, AppLocalizations localizations) {
    final daysInMonth =
        CalendarConverter.getDaysInMonthNormal(_currentYear, month);
    final firstWeekday = _firstWeekdayOffset(_currentYear, month);

    final isCurrentMonth =
        DateTime.now().year == _currentYear && DateTime.now().month == month;

    return InkWell(
      onTap: () {
        playClick();
        setState(() {
          _currentMonth = month;
          _isYearView = false;
        });
      },
      child: Card(
        elevation: 2,
        color: isCurrentMonth
            ? Theme.of(context)
                .colorScheme
                .primaryContainer
                .withValues(alpha: 0.3)
            : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _getMonthName(localizations, month),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isCurrentMonth
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
              ),
              const SizedBox(height: 2),
              // Weekday headers
              Row(
                children: [
                  for (final entry in [
                    (localizations.monday, false),
                    (localizations.tuesday, false),
                    (localizations.wednesday, false),
                    (localizations.thursday, false),
                    (localizations.friday, false),
                    (localizations.saturday, false),
                    (localizations.sunday, true),
                  ])
                    Expanded(
                      child: Text(
                        entry.$1.substring(0, 1),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 6,
                          fontWeight: FontWeight.bold,
                          color: entry.$2
                              ? Colors.red
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 1),
              // Mini calendar grid
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1,
                  ),
                  itemCount: firstWeekday + daysInMonth,
                  itemBuilder: (context, index) {
                    if (index < firstWeekday) {
                      return const SizedBox();
                    }

                    final day = index - firstWeekday + 1;
                    final isToday = DateTime.now().year == _currentYear &&
                        DateTime.now().month == month &&
                        DateTime.now().day == day;
                    final isSun = index % 7 == 6;

                    return Container(
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: isToday
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          day.toString(),
                          style: TextStyle(
                            fontSize: 8,
                            color: isToday
                                ? Theme.of(context).colorScheme.onPrimary
                                : (isSun
                                    ? Colors.red.withValues(alpha: 0.8)
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.7)),
                            fontWeight:
                                isToday ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
