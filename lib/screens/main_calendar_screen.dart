import 'package:flutter/material.dart';
import '../l10n/app_localizations_manual.dart';
import '../models/calendar_type.dart';
import '../services/calendar_converter.dart';
import '../models/calendar_date.dart';

class MainCalendarScreen extends StatefulWidget {
  const MainCalendarScreen({super.key});

  @override
  State<MainCalendarScreen> createState() => _MainCalendarScreenState();
}

class _MainCalendarScreenState extends State<MainCalendarScreen> {
  late int _currentYear;
  late int _currentMonth;
  DateTime _selectedDate = DateTime.now();

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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    // Get days in month for Neutral calendar
    final daysInMonth = CalendarConverter.getDaysInMonthNeutral(_currentYear, _currentMonth);
    
    // Get first weekday for this month in Neutral calendar
    // Neutral calendar year starts on Sunday
    int firstWeekday = CalendarConverter.getFirstWeekdayNeutral(_currentYear, _currentMonth);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(localizations.calendar),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: _goToToday,
            tooltip: localizations.today,
          ),
        ],
      ),
      body: Column(
        children: [
          // Month navigation header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
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
                Text(
                  '${_getMonthName(localizations, _currentMonth)} $_currentYear',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
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
                _buildWeekdayHeader(localizations.sunday),
              ],
            ),
          ),

          // Calendar grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                  final isToday = DateTime.now().year == _currentYear &&
                      DateTime.now().month == _currentMonth &&
                      DateTime.now().day == day;
                  
                  final isSelected = _selectedDate.year == _currentYear &&
                      _selectedDate.month == _currentMonth &&
                      _selectedDate.day == day;

                  return _buildDayCell(day, isToday, isSelected);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeader(String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildDayCell(int day, bool isToday, bool isSelected) {
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
      textColor = Colors.black87;
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
}
