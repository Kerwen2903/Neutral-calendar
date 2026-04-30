import 'package:flutter/material.dart';
import '../l10n/app_localizations_manual.dart';
import '../utils/click_sound.dart';
import '../widgets/calendar_month_widget.dart';
import '../models/calendar_type.dart';
import '../models/calendar_date.dart';
import '../services/calendar_converter.dart';
import '../main.dart';
import 'lock_screen.dart';

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
  bool _slideForward = true;

  void _previousMonth() {
    playClick();
    setState(() {
      _slideForward = false;
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
      _slideForward = true;
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

  bool get _useAllChristian =>
      NeutralCalendarApp.of(context)?.useAllChristianCombo ?? false;

  CalendarDate _toNeutral(CalendarDate normalDate) => _useAllChristian
      ? CalendarConverter.normalToAllChristian(normalDate)
      : CalendarConverter.normalToNeutral(normalDate);

  CalendarDate _toNormal(CalendarDate neutralDate) => _useAllChristian
      ? CalendarConverter.allChristianToNormal(neutralDate)
      : CalendarConverter.neutralToNormal(neutralDate);

  void _onNormalDaySelected(int day) {
    setState(() {
      _selectedNormalDate = CalendarDate(
        year: _normalYear,
        month: _normalMonth,
        day: day,
        calendarType: CalendarType.normal,
      );
      _selectedNeutralDate = _toNeutral(_selectedNormalDate!);
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
      _selectedNormalDate = _toNormal(_selectedNeutralDate!);
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
      _selectedNeutralDate = _toNeutral(_selectedNormalDate!);
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
      _selectedNeutralDate = _toNeutral(_selectedNormalDate!);
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
      _selectedNormalDate = _toNormal(_selectedNeutralDate!);
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
      _selectedNormalDate = _toNormal(_selectedNeutralDate!);
      _normalYear = _selectedNormalDate!.year;
      _normalMonth = _selectedNormalDate!.month;
    });
  }

  void _previousYear() {
    playClick();
    setState(() {
      _normalYear--;
      _neutralYear--;
      _selectedNormalDate = null;
      _selectedNeutralDate = null;
    });
  }

  void _nextYear() {
    playClick();
    setState(() {
      _normalYear++;
      _neutralYear++;
      _selectedNormalDate = null;
      _selectedNeutralDate = null;
    });
  }

  void _showYearPicker(BuildContext context) {
    playClick();
    final currentYear = DateTime.now().year;
    final controller = ScrollController(
      initialScrollOffset: (_normalYear - (currentYear - 50)) * 48.0,
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.comparison),
        content: SizedBox(
          width: 280,
          height: 300,
          child: ListView.builder(
            controller: controller,
            itemCount: 101,
            itemBuilder: (_, i) {
              final year = currentYear - 50 + i;
              final isSelected = year == _normalYear;
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
                  final diff = year - _normalYear;
                  setState(() {
                    _normalYear = year;
                    _neutralYear += diff;
                    _selectedNormalDate = null;
                    _selectedNeutralDate = null;
                  });
                  Navigator.pop(ctx);
                },
              );
            },
          ),
        ),
      ),
    );
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
      body: SafeArea(
        child: GestureDetector(
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
          // Month navigation
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _circleArrow(Icons.chevron_left, _previousMonth),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    layoutBuilder: (currentChild, previousChildren) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          ...previousChildren,
                          if (currentChild != null) currentChild,
                        ],
                      );
                    },
                    transitionBuilder: (child, animation) {
                      final isIncoming = animation.status == AnimationStatus.forward ||
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
                    child: Row(
                      key: ValueKey('$_normalYear'),
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => _showYearPicker(context),
                          child: Text(
                            '$_normalYear',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
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
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            GestureDetector(
                              onTap: _previousYear,
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                size: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                _todayButton(),
                _circleArrow(Icons.chevron_right, _nextMonth),
              ],
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
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
                key: ValueKey('comp-$_normalYear-$_normalMonth-$_neutralYear-$_neutralMonth'),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 2.0,
                ),
                child: _buildCalendarPair(localizations, useNeutral),
              ),
            ),
          ),
        ],
      ),
      ),
      ),
    );
  }

  Widget _buildCalendarPair(AppLocalizations localizations, bool useNeutral) {
    final appState = NeutralCalendarApp.of(context);
    final useAllChristian = appState?.useAllChristianCombo ?? false;
    final neutralDisplayType =
        useAllChristian ? CalendarType.allChristian : CalendarType.neutral;

    return Column(
      children: [
        // Normal Calendar
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    _getMonthName(localizations, _normalMonth, false),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.blue.shade300
                          : Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: CalendarMonthWidget(
                      year: _normalYear,
                      month: _normalMonth,
                      calendarType: CalendarType.normal,
                      fixedVisualRows: 7,
                      selectedDay:
                          _selectedNormalDate?.year == _normalYear &&
                              _selectedNormalDate?.month == _normalMonth
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
        // Neutral / All Christian Calendar
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getMonthName(localizations, _neutralMonth, useNeutral),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.green.shade300
                              : Colors.green.shade700,
                        ),
                      ),
                      if (useAllChristian) ...[
                        const SizedBox(width: 6),
                        Text(
                          '(${localizations.allChristian})',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.green.shade300
                                : Colors.green.shade700,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: CalendarMonthWidget(
                      year: _neutralYear,
                      month: _neutralMonth,
                      calendarType: neutralDisplayType,
                      fixedVisualRows: 7,
                      selectedDay:
                          _selectedNeutralDate?.year == _neutralYear &&
                              _selectedNeutralDate?.month == _neutralMonth
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
    );
  }

  Widget _todayButton() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
      ),
      child: IconButton(
        icon: const Icon(Icons.today, size: 18),
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
        padding: const EdgeInsets.all(6),
        constraints: const BoxConstraints(),
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
        icon: Icon(icon, size: 22),
        onPressed: onPressed,
        padding: const EdgeInsets.all(6),
        constraints: const BoxConstraints(),
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
