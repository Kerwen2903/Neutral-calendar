import 'package:flutter/material.dart';
import '../l10n/app_localizations_manual.dart';
import '../services/calendar_converter.dart';
import '../main.dart';

class MainCalendarScreen extends StatefulWidget {
  const MainCalendarScreen({super.key});

  @override
  State<MainCalendarScreen> createState() => _MainCalendarScreenState();
}

class _MainCalendarScreenState extends State<MainCalendarScreen> {
  late int _currentYear;
  late int _currentMonth;
  DateTime _selectedDate = DateTime.now();
  bool _isYearView = false;

  @override
  void initState() {
    super.initState();
    _currentYear = DateTime.now().year;
    _currentMonth = DateTime.now().month;
  }

  void _previousMonth() {
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
    setState(() {
      if (_currentMonth == 12) {
        _currentMonth = 1;
        _currentYear++;
      } else {
        _currentMonth++;
      }
    });
  }

  void _goToToday() {
    setState(() {
      _currentYear = DateTime.now().year;
      _currentMonth = DateTime.now().month;
      _selectedDate = DateTime.now();
    });
  }

  void _previousYear() {
    setState(() {
      _currentYear--;
    });
  }

  void _nextYear() {
    setState(() {
      _currentYear++;
    });
  }

  void _toggleView() {
    setState(() {
      _isYearView = !_isYearView;
    });
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final appState = NeutralCalendarApp.of(context);
    final useNeutral = appState?.useNeutralMonthNames ?? true;

    // Get days in month for Neutral calendar (calculation value, stays 30 for Feb)
    final daysInMonth = CalendarConverter.getDaysInMonthNeutral(
      _currentYear,
      _currentMonth,
    );

    // In a leap year, Feb displays a visual-only Feb 31 leap day cell (Positioned below grid).
    final isNeutralLeapFeb =
        _currentMonth == 2 && CalendarConverter.isLeapYearNormal(_currentYear);

    // Get first weekday for this month in Neutral calendar
    // Neutral calendar year starts on Sunday
    int firstWeekday = CalendarConverter.getFirstWeekdayNeutral(
      _currentYear,
      _currentMonth,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.calendar),
        actions: [
          IconButton(
            icon: Icon(
              _isYearView ? Icons.calendar_view_month : Icons.calendar_view_day,
            ),
            onPressed: _toggleView,
            tooltip: _isYearView ? 'Month View' : 'Year View',
          ),
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: _goToToday,
            tooltip: localizations.today,
          ),
        ],
      ),
      body: _isYearView
          ? _buildYearView(localizations, useNeutral)
          : Column(
              children: [
                // Month navigation header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
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
                      IconButton(
                        icon: const Icon(Icons.chevron_left, size: 32),
                        onPressed: _previousMonth,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${_getMonthName(localizations, _currentMonth, useNeutral)} $_currentYear',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                          ),
                          if (_currentMonth == 2 && CalendarConverter.isLeapYearNormal(_currentYear))
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
                      IconButton(
                        icon: const Icon(Icons.chevron_right, size: 32),
                        onPressed: _nextMonth,
                      ),
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

                // Calendar grid
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final cellSize = (constraints.maxWidth - 16 - 4 * 6) / 7;
                      final gridRows =
                          ((firstWeekday + daysInMonth) / 7).ceil();

                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Stack(
                          children: [
                            GridView.builder(
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
                            // Neutral Feb 31 — visual-only, placed between Thu & Fri below last row
                            if (isNeutralLeapFeb)
                              Positioned(
                                top: gridRows * (cellSize + 4),
                                left: 3.4 * (cellSize + 4),
                                width: cellSize,
                                height: cellSize * 0.9,
                                child: _buildLeapDay31Cell(),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
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
                ? const Color(0xFF8B0000)
                : Theme.of(context).colorScheme.primary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildLeapDay31Cell() {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.amber.shade600, width: 1.5),
      ),
      child: Stack(
        children: [
          const Center(
            child: Text(
              '31',
              style: TextStyle(
                color: Color(0xFF7A3E00),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Positioned(
            bottom: 3,
            left: 0,
            right: 0,
            child: Text(
              '✦',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 7,
                color: Colors.amber.shade700,
              ),
            ),
          ),
        ],
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
          ? const Color(0xFF8B0000)
          : Theme.of(context).colorScheme.onSurface;
      decoration = BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      );
    }

    return InkWell(
      onTap: () {
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

  Widget _buildYearView(AppLocalizations localizations, bool useNeutral) {
    return Column(
      children: [
        // Year navigation header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 32),
                onPressed: _previousYear,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$_currentYear',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
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
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 32),
                onPressed: _nextYear,
              ),
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
                return _buildMonthCard(month, localizations, useNeutral);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthCard(
    int month,
    AppLocalizations localizations,
    bool useNeutral,
  ) {
    final daysInMonth = CalendarConverter.getDaysInMonthNeutral(
      _currentYear,
      month,
    );
    final firstWeekday = CalendarConverter.getFirstWeekdayNeutral(
      _currentYear,
      month,
    );

    // Visual-only Feb 31 leap day in leap years
    final isLeapFeb =
        month == 2 && CalendarConverter.isLeapYearNormal(_currentYear);
    final displayDaysInMonth = daysInMonth + (isLeapFeb ? 1 : 0);

    final isCurrentMonth =
        DateTime.now().year == _currentYear && DateTime.now().month == month;

    return InkWell(
      onTap: () {
        setState(() {
          _currentMonth = month;
          _isYearView = false;
        });
      },
      child: Card(
        elevation: 2,
        color: isCurrentMonth
            ? Theme.of(
                context,
              ).colorScheme.primaryContainer.withValues(alpha: 0.3)
            : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Month name
              Text(
                _getMonthName(localizations, month, useNeutral),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isCurrentMonth
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
              ),
              const SizedBox(height: 4),
              // Mini calendar grid
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1,
                  ),
                  itemCount: firstWeekday + displayDaysInMonth,
                  itemBuilder: (context, index) {
                    if (index < firstWeekday) {
                      return const SizedBox();
                    }

                    // Neutral Feb 31 — visual-only leap day mini cell
                    if (isLeapFeb && index == firstWeekday + daysInMonth) {
                      return Container(
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade200,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.amber.shade600,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '31',
                            style: TextStyle(
                              fontSize: 7,
                              color: Colors.orange.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }

                    final day = index - firstWeekday + 1;
                    final isToday = DateTime.now().year == _currentYear &&
                        DateTime.now().month == month &&
                        DateTime.now().day == day;

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
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.7),
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
