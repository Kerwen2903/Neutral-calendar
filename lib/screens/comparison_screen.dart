import 'package:flutter/material.dart';
import '../l10n/app_localizations_manual.dart';
import '../widgets/calendar_month_widget.dart';
import '../models/calendar_type.dart';

class ComparisonScreen extends StatefulWidget {
  const ComparisonScreen({super.key});

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  int _currentYear = DateTime.now().year;
  int _currentMonth = DateTime.now().month;

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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.comparison),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              setState(() {
                _currentYear = DateTime.now().year;
                _currentMonth = DateTime.now().month;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Month navigation
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _previousMonth,
                ),
                Text(
                  _getMonthName(localizations, _currentMonth) +
                      ' $_currentYear',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _nextMonth,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Normal Calendar
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              localizations.normalCalendar,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            CalendarMonthWidget(
                              year: _currentYear,
                              month: _currentMonth,
                              calendarType: CalendarType.normal,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Neutral Calendar
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              localizations.neutralCalendar,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            CalendarMonthWidget(
                              year: _currentYear,
                              month: _currentMonth,
                              calendarType: CalendarType.neutral,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
}
