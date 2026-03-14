import 'package:flutter/material.dart';
import '../l10n/app_localizations_manual.dart';
import '../models/calendar_type.dart';
import '../services/calendar_converter.dart';

class CalendarMonthWidget extends StatelessWidget {
  final int year;
  final int month;
  final CalendarType calendarType;
  final int? selectedDay;
  final Function(int day)? onDaySelected;
  final Function(int year, int month, int day)? onPreviousMonthDaySelected;
  final Function(int year, int month, int day)? onNextMonthDaySelected;

  const CalendarMonthWidget({
    super.key,
    required this.year,
    required this.month,
    required this.calendarType,
    this.selectedDay,
    this.onDaySelected,
    this.onPreviousMonthDaySelected,
    this.onNextMonthDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Get days in month (calculation value — unchanged by leap years on Neutral)
    final daysInMonth = calendarType == CalendarType.normal
        ? CalendarConverter.getDaysInMonthNormal(year, month)
        : CalendarConverter.getDaysInMonthNeutral(year, month);

    // On the Neutral calendar, Feb 31 is shown as a visual-only leap day in leap years.
    // It is NOT included in any date calculations.

    final isNeutralLeapFeb = calendarType == CalendarType.neutral &&
        month == 2 &&
        CalendarConverter.isLeapYearNormal(year);

    // Get first day of week (0 = Monday, 6 = Sunday)
    int firstWeekday;
    if (calendarType == CalendarType.normal) {
      final firstDayOfMonth = DateTime(year, month, 1);
      firstWeekday =
          firstDayOfMonth.weekday - 1; // Convert to 0-based (Mon = 0)
    } else {
      // For Neutral calendar, use its own calculation
      firstWeekday = CalendarConverter.getFirstWeekdayNeutral(year, month);
    }

    return Column(
      children: [
        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildWeekdayHeader(localizations.monday, calendarType,
                isSunday: false),
            _buildWeekdayHeader(localizations.tuesday, calendarType,
                isSunday: false),
            _buildWeekdayHeader(localizations.wednesday, calendarType,
                isSunday: false),
            _buildWeekdayHeader(localizations.thursday, calendarType,
                isSunday: false),
            _buildWeekdayHeader(localizations.friday, calendarType,
                isSunday: false),
            _buildWeekdayHeader(localizations.saturday, calendarType,
                isSunday: false),
            _buildWeekdayHeader(localizations.sunday, calendarType,
                isSunday: calendarType == CalendarType.neutral),
          ],
        ),
        const SizedBox(height: 4),
        // Calendar grid
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Calculate number of weeks needed (rows) using display count
              final totalCells = firstWeekday + daysInMonth;
              final weeksNeeded = (totalCells / 7).ceil();

              // Cell size for positioning the leap day
              final cellW = (constraints.maxWidth - 2 * 6) / 7;
              final cellH = constraints.maxHeight /
                  (weeksNeeded + (isNeutralLeapFeb ? 0.55 : 0));

              return Stack(
                children: [
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: constraints.maxWidth /
                          (constraints.maxHeight /
                              (weeksNeeded + (isNeutralLeapFeb ? 0.55 : 0))) /
                          7,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemCount: weeksNeeded * 7,
                    itemBuilder: (context, index) {
                      // Previous month days
                      if (index < firstWeekday) {
                        final prevMonth = month == 1 ? 12 : month - 1;
                        final prevYear = month == 1 ? year - 1 : year;
                        final daysInPrevMonth =
                            calendarType == CalendarType.normal
                                ? CalendarConverter.getDaysInMonthNormal(
                                    prevYear, prevMonth)
                                : CalendarConverter.getDaysInMonthNeutral(
                                    prevYear, prevMonth);
                        final day =
                            daysInPrevMonth - (firstWeekday - index - 1);
                        return _buildDayCell(
                          day,
                          false,
                          false,
                          calendarType,
                          isDisabled: true,
                          onTap: onPreviousMonthDaySelected != null
                              ? () => onPreviousMonthDaySelected!(
                                  prevYear, prevMonth, day)
                              : null,
                        );
                      }

                      // Next month days
                      if (index >= firstWeekday + daysInMonth) {
                        final nextMonth = month == 12 ? 1 : month + 1;
                        final nextYear = month == 12 ? year + 1 : year;
                        final day = index - firstWeekday - daysInMonth + 1;
                        return _buildDayCell(
                          day,
                          false,
                          false,
                          calendarType,
                          isDisabled: true,
                          onTap: onNextMonthDaySelected != null
                              ? () => onNextMonthDaySelected!(
                                  nextYear, nextMonth, day)
                              : null,
                        );
                      }

                      // Current month days (1..daysInMonth)
                      final day = index - firstWeekday + 1;
                      final isToday = DateTime.now().year == year &&
                          DateTime.now().month == month &&
                          DateTime.now().day == day;
                      final isSelected = selectedDay != null &&
                          selectedDay! <= daysInMonth &&
                          selectedDay == day;

                      // Sunday column (index % 7 == 6) — dark red on Neutral calendar
                      final isSundayCell =
                          calendarType == CalendarType.neutral &&
                              index % 7 == 6;

                      // Gregorian Feb 29 — actual leap day (amber highlight)
                      final isGregorianLeapDay =
                          calendarType == CalendarType.normal &&
                              month == 2 &&
                              day == 29 &&
                              CalendarConverter.isLeapYearNormal(year);

                      return _buildDayCell(
                        day,
                        isToday,
                        isSelected,
                        calendarType,
                        isLeapDay: isGregorianLeapDay,
                        isSundayHighlight: isSundayCell,
                      );
                    },
                  ),
                  // Neutral Feb 31 — visual-only leap day, placed between Thu (col 3) and Fri (col 4)
                  if (isNeutralLeapFeb)
                    Positioned(
                      // sits below the last real row, shifted to around col 3.4 (between Thu & Fri)
                      top: weeksNeeded * (cellH + 2) + 2,
                      left: 3.4 * (cellW + 2),
                      width: cellW,
                      height: cellH * 0.9,
                      child: _buildNeutralLeapDay31Cell(context, calendarType),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeekdayHeader(String text, CalendarType calendarType,
      {bool isSunday = false}) {
    Color color;
    if (isSunday) {
      color = const Color(0xFF8B0000); // dark red for Sunday on Neutral
    } else {
      switch (calendarType) {
        case CalendarType.normal:
          color = Colors.blue.shade700;
          break;
        case CalendarType.neutral:
          color = Colors.green.shade700;
          break;
      }
    }

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  Widget _buildNeutralLeapDay31Cell(
    BuildContext context,
    CalendarType calendarType,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        border: Border.all(color: Colors.amber.shade600, width: 1.5),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              '31',
              style: TextStyle(
                color: Colors.orange.shade900,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          Positioned(
            bottom: 1,
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
    bool isSelected,
    CalendarType calendarType, {
    bool isDisabled = false,
    bool isLeapDay = false,
    bool isSundayHighlight = false, // dark red for Sunday on Neutral
    VoidCallback? onTap,
  }) {
    Color? backgroundColor;
    Color? textColor;
    Color borderColor;

    if (isDisabled) {
      backgroundColor = null;
      textColor = Colors.grey.shade400;
      borderColor = Colors.grey.shade200;
    } else if (isSelected) {
      backgroundColor = calendarType == CalendarType.normal
          ? Colors.blue.shade700
          : Colors.green.shade700;
      textColor = Colors.white;
      borderColor = backgroundColor;
    } else if (isLeapDay) {
      backgroundColor = Colors.amber.shade100;
      textColor = Colors.orange.shade900;
      borderColor = Colors.amber.shade600;
    } else if (isToday) {
      backgroundColor = calendarType == CalendarType.normal
          ? Colors.blue.shade100
          : Colors.green.shade100;
      textColor = calendarType == CalendarType.normal
          ? Colors.blue.shade900
          : Colors.green.shade900;
      borderColor = calendarType == CalendarType.normal
          ? Colors.blue.shade300
          : Colors.green.shade300;
    } else {
      backgroundColor = null;
      // Sunday on Neutral calendar: dark red text
      textColor = isSundayHighlight ? const Color(0xFF8B0000) : null;
      borderColor = isSundayHighlight
          ? const Color(0xFF8B0000).withValues(alpha: 0.4)
          : Colors.grey.shade300;
    }

    Widget dayText = Center(
      child: Text(
        day.toString(),
        style: TextStyle(
          color: textColor,
          fontWeight:
              isToday || isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
      ),
    );

    Widget content;
    if (isLeapDay) {
      content = Stack(
        children: [
          dayText,
          Positioned(
            top: 1,
            right: 2,
            child: Text(
              '✦',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade800,
              ),
            ),
          ),
        ],
      );
    } else {
      content = dayText;
    }

    return InkWell(
      onTap: isDisabled
          ? onTap
          : (onDaySelected != null ? () => onDaySelected!(day) : null),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: isSelected || isLeapDay ? 1.5 : 0.8,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
        child: content,
      ),
    );
  }
}
