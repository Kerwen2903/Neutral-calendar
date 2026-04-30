import 'package:flutter/material.dart';
import '../l10n/app_localizations_manual.dart';
import '../services/calendar_converter.dart';
import '../utils/click_sound.dart';
import 'lock_screen.dart';

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

  bool _isDarkMode(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  Color _gregorianTextColor(BuildContext context) =>
      _isDarkMode(context) ? Colors.blue.shade300 : Colors.blue.shade700;

  Color _gregorianMutedTextColor(BuildContext context) => _isDarkMode(context)
      ? Colors.blue.shade200.withValues(alpha: 0.75)
      : Colors.blue.shade700.withValues(alpha: 0.5);

  Color _gregorianSelectedBgColor(BuildContext context) =>
      _isDarkMode(context) ? Colors.blue.shade500 : Colors.blue.shade700;

  Color _gregorianTodayBgColor(BuildContext context) => _isDarkMode(context)
      ? Colors.blue.shade900.withValues(alpha: 0.55)
      : Colors.blue.shade100;

  Color _gregorianTodayTextColor(BuildContext context) =>
      _isDarkMode(context) ? Colors.blue.shade100 : Colors.blue.shade900;

  void _showMonthPicker(BuildContext context) {
    playClick();
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(localizations.gregorianStyle),
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
                  _getMonthName(localizations, month),
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
        title: Text(AppLocalizations.of(context)!.gregorianStyle),
        content: SizedBox(
          width: 280,
          height: 300,
          child: ListView.builder(
            controller: controller,
            itemCount: 101,
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
    final isGregorianLeapFeb =
        _currentMonth == 2 && CalendarConverter.isLeapYearNormal(_currentYear);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.gregorianStyle),
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
                                    _getMonthName(localizations, _currentMonth),
                                    key: ValueKey('month-$_currentMonth'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: _gregorianTextColor(context),
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
                                          color: _gregorianTextColor(context),
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
                                          color: _gregorianTextColor(context),
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
                                        color: _gregorianTextColor(context),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: _previousYear,
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 18,
                                        color: _gregorianTextColor(context),
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
                      child: Padding(
                        key: ValueKey('greg-$_currentYear-$_currentMonth'),
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
                            final isLeapDay = isGregorianLeapFeb && day == 29;

                            return _buildDayCell(
                              day,
                              isToday,
                              isSelected,
                              isSundayCell: isSundayCell,
                              isLeapDay: isLeapDay,
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
            color: isSunday ? Colors.red : _gregorianTextColor(context),
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
    bool isLeapDay = false,
  }) {
    Color backgroundColor;
    Color textColor;
    BoxDecoration decoration;

    if (isToday) {
      backgroundColor = _gregorianTodayBgColor(context);
      textColor = _gregorianTodayTextColor(context);
      decoration = BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      );
    } else if (isSelected) {
      backgroundColor = _gregorianSelectedBgColor(context);
      textColor = Colors.white;
      decoration = BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      );
    } else if (isLeapDay) {
      backgroundColor = Colors.amber.shade100;
      textColor = Colors.orange.shade900;
      decoration = BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.amber.shade600, width: 1.5),
      );
    } else {
      backgroundColor = Colors.transparent;
      textColor = isSundayCell ? Colors.red : _gregorianTextColor(context);
      decoration = BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      );
    }

    Widget content = Center(
      child: Text(
        day.toString(),
        style: TextStyle(
          color: textColor,
          fontWeight:
              isToday || isLeapDay ? FontWeight.bold : FontWeight.normal,
          fontSize: 16,
        ),
      ),
    );

    if (isLeapDay) {
      content = Stack(
        children: [
          content,
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
        child: content,
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
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _gregorianTextColor(context),
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
                      color: _gregorianTextColor(context),
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
                              : _gregorianMutedTextColor(context),
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
                            ? _gregorianSelectedBgColor(context)
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
                                    : _gregorianTextColor(context)
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
