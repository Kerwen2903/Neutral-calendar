import 'package:flutter/material.dart';
import '../l10n/app_localizations_manual.dart';
import '../models/calendar_date.dart';
import '../models/calendar_type.dart';
import '../services/calendar_converter.dart';
import '../main.dart';
import '../utils/click_sound.dart';
import 'lock_screen.dart';

class MainCalendarScreen extends StatefulWidget {
  const MainCalendarScreen({super.key});

  @override
  State<MainCalendarScreen> createState() => _MainCalendarScreenState();
}

class _MainCalendarScreenState extends State<MainCalendarScreen> {
  late int _currentYear;
  late int _currentMonth;
  late DateTime _selectedDate;
  bool _isYearView = false;
  bool _slideForward = true; // animation direction

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
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
    _selectedDate =
        DateTime(todayNeutral.year, todayNeutral.month, todayNeutral.day);
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
    final now = DateTime.now();
    final todayNeutral = CalendarConverter.normalToNeutral(
      CalendarDate(
        year: now.year,
        month: now.month,
        day: now.day,
        calendarType: CalendarType.normal,
      ),
    );
    setState(() {
      _currentYear = todayNeutral.year;
      _currentMonth = todayNeutral.month;
      _selectedDate =
          DateTime(todayNeutral.year, todayNeutral.month, todayNeutral.day);
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

  bool _isDarkMode(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  Color _neutralTextColor(BuildContext context) =>
      _isDarkMode(context) ? Colors.green.shade300 : Colors.green.shade700;

  Color _neutralMutedTextColor(BuildContext context) => _isDarkMode(context)
      ? Colors.green.shade200.withValues(alpha: 0.75)
      : Colors.green.shade700.withValues(alpha: 0.5);

  Color _neutralSelectedBgColor(BuildContext context) =>
      _isDarkMode(context) ? Colors.green.shade500 : Colors.green.shade700;

  Color _neutralTodayBgColor(BuildContext context) => _isDarkMode(context)
      ? Colors.green.shade900.withValues(alpha: 0.55)
      : Colors.green.shade100;

  Color _neutralTodayTextColor(BuildContext context) =>
      _isDarkMode(context) ? Colors.green.shade100 : Colors.green.shade900;

  void _showMonthPicker(BuildContext context) {
    playClick();
    final localizations = AppLocalizations.of(context)!;
    final appState = NeutralCalendarApp.of(context);
    final useNeutral = appState?.useNeutralMonthNames ?? true;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(localizations.calendar),
        content: SizedBox(
          width: 280,
          height: 300,
          child: ListView.builder(
            itemCount: 12,
            itemBuilder: (_, i) {
              final month = i + 1;
              final isSelected = month == _currentMonth;
              return ListTile(
                dense: true,
                selected: isSelected,
                selectedTileColor:
                    Theme.of(context).colorScheme.primaryContainer,
                title: Text(
                  _getMonthName(localizations, month, useNeutral),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  playClick();
                  setState(() => _currentMonth = month);
                  Navigator.pop(ctx);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showYearPicker(BuildContext context) {
    playClick();
    final currentYear = DateTime.now().year;
    final controller = ScrollController(
      initialScrollOffset: (_currentYear - (currentYear - 50)) * 48.0,
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.calendar),
        content: SizedBox(
          width: 280,
          height: 300,
          child: ListView.builder(
            controller: controller,
            itemCount: 101, // 50 years before/after current year
            itemBuilder: (_, i) {
              final year = currentYear - 50 + i;
              final isSelected = year == _currentYear;
              return ListTile(
                dense: true,
                selected: isSelected,
                selectedTileColor:
                    Theme.of(context).colorScheme.primaryContainer,
                title: Text(
                  '$year',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  playClick();
                  setState(() => _currentYear = year);
                  Navigator.pop(ctx);
                },
              );
            },
          ),
        ),
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final appState = NeutralCalendarApp.of(context);
    final useNeutral = appState?.useNeutralMonthNames ?? true;

    // Convert today's Gregorian date to Neutral calendar for correct "today" highlighting
    final now = DateTime.now();
    final todayNeutral = CalendarConverter.normalToNeutral(
      CalendarDate(
        year: now.year,
        month: now.month,
        day: now.day,
        calendarType: CalendarType.normal,
      ),
    );

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
      body: _isYearView
          ? _buildYearView(localizations, useNeutral, todayNeutral)
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
                        _circleArrow(Icons.keyboard_arrow_up, _previousMonth),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () => _showMonthPicker(context),
                                  child: Text(
                                    _getMonthName(localizations, _currentMonth, useNeutral),
                                    key: ValueKey('month-$_currentMonth'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: _neutralTextColor(context),
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    '/',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: _neutralTextColor(context),
                                        ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _showYearPicker(context),
                                  child: Text(
                                    '$_currentYear',
                                    key: ValueKey('year-$_currentYear'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: _neutralTextColor(context),
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: _nextYear,
                                      child: Icon(
                                        Icons.keyboard_arrow_up,
                                        size: 18,
                                        color: _neutralTextColor(context),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: _previousYear,
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 18,
                                        color: _neutralTextColor(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
                                  localizations.leapDay,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange.shade900,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        _circleArrow(Icons.keyboard_arrow_down, _nextMonth),
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
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      layoutBuilder: (currentChild, previousChildren) {
                        return Stack(
                          children: [
                            ...previousChildren,
                            if (currentChild != null) currentChild,
                          ],
                        );
                      },
                      transitionBuilder: (child, animation) {
                        final isIncoming =
                            animation.status == AnimationStatus.forward ||
                                animation.status == AnimationStatus.completed;
                        final offsetTween = Tween<Offset>(
                          begin: Offset(
                              isIncoming
                                  ? (_slideForward ? 1.0 : -1.0)
                                  : (_slideForward ? -1.0 : 1.0),
                              0),
                          end: Offset.zero,
                        );
                        return SlideTransition(
                          position: offsetTween.animate(animation),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: LayoutBuilder(
                        key: ValueKey('grid-$_currentYear-$_currentMonth'),
                        builder: (context, constraints) {
                          final cellSize =
                              (constraints.maxWidth - 16 - 4 * 6) / 7;
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
                                    final isToday = todayNeutral.year ==
                                            _currentYear &&
                                        todayNeutral.month == _currentMonth &&
                                        todayNeutral.day == day;

                                    final isSelected = _selectedDate.year ==
                                            _currentYear &&
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
                                    left: 3 * (cellSize + 4),
                                    width: cellSize,
                                    height: cellSize,
                                    child: _buildLeapDay31Cell(),
                                  ),
                              ],
                            ),
                          );
                        },
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
            color: isSunday ? Colors.red : _neutralTextColor(context),
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
      backgroundColor = _neutralTodayBgColor(context);
      textColor = _neutralTodayTextColor(context);
      decoration = BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      );
    } else if (isSelected) {
      backgroundColor = _neutralSelectedBgColor(context);
      textColor = Colors.white;
      decoration = BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      );
    } else {
      backgroundColor = Colors.transparent;
      textColor = isSundayCell ? Colors.red : _neutralTextColor(context);
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

  Widget _buildYearView(AppLocalizations localizations, bool useNeutral,
      CalendarDate todayNeutral) {
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
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _neutralTextColor(context),
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
                        localizations.leapDayShort,
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
                return _buildMonthCard(
                    month, localizations, useNeutral, todayNeutral);
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
    CalendarDate todayNeutral,
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
        todayNeutral.year == _currentYear && todayNeutral.month == month;

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
                          ? _neutralTextColor(context)
                          : _neutralTextColor(context),
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
                              : _neutralMutedTextColor(context),
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
                    final isToday = todayNeutral.year == _currentYear &&
                        todayNeutral.month == month &&
                        todayNeutral.day == day;
                    final isSun = index % 7 == 6;

                    return Container(
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: isToday
                            ? _neutralSelectedBgColor(context)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          day.toString(),
                          style: TextStyle(
                            fontSize: 8,
                            color: isToday
                                ? Colors.white
                                : (isSun
                                    ? Colors.red.withValues(alpha: 0.8)
                                    : _neutralTextColor(context)
                                        .withValues(alpha: 0.75)),
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
