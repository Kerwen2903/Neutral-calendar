import 'package:flutter/material.dart';
import '../l10n/app_localizations_manual.dart';
import '../utils/click_sound.dart';
import '../models/calendar_date.dart';
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
  final int? fixedVisualRows;

  const CalendarMonthWidget({
    super.key,
    required this.year,
    required this.month,
    required this.calendarType,
    this.selectedDay,
    this.onDaySelected,
    this.onPreviousMonthDaySelected,
    this.onNextMonthDaySelected,
    this.fixedVisualRows,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // For neutral/allChristian calendar, convert today's Gregorian date to neutral for "today" highlight
    final now = DateTime.now();
    int todayYear, todayMonth, todayDay;
    if (calendarType == CalendarType.neutral || calendarType == CalendarType.allChristian) {
      final todayNeutral = CalendarConverter.normalToNeutral(
        CalendarDate(
            year: now.year,
            month: now.month,
            day: now.day,
            calendarType: CalendarType.normal),
      );
      todayYear = todayNeutral.year;
      todayMonth = todayNeutral.month;
      todayDay = todayNeutral.day;
    } else {
      todayYear = now.year;
      todayMonth = now.month;
      todayDay = now.day;
    }

    // All Christian Feb in a leap year has 31 days (day 29 = leap day inside the grid).
    final daysInMonth = calendarType == CalendarType.normal
        ? CalendarConverter.getDaysInMonthNormal(year, month)
        : (calendarType == CalendarType.allChristian &&
                month == 2 &&
                CalendarConverter.isLeapYearNormal(year))
            ? 31
            : CalendarConverter.getDaysInMonthNeutral(year, month);

    // On the Neutral calendar, Feb 31 is shown as a visual-only leap day in leap years.
    // It is NOT included in any date calculations.

    // Neutral: Feb 31 is a visual-only leap day shown BELOW the grid.
    // All Christian: Feb 31 is included inside the grid normally.
    final isNeutralLeapFeb = calendarType == CalendarType.neutral &&
        month == 2 &&
        CalendarConverter.isLeapYearNormal(year);

    // Get first day of week (0 = Monday, 6 = Sunday)
    int firstWeekday;
    if (calendarType == CalendarType.normal) {
      final firstDayOfMonth = DateTime(year, month, 1);
      firstWeekday = firstDayOfMonth.weekday - 1; // Convert to 0-based (Mon = 0)
    } else if (calendarType == CalendarType.allChristian) {
      firstWeekday = CalendarConverter.getFirstWeekdayAllChristian(year, month);
    } else {
      firstWeekday = CalendarConverter.getFirstWeekdayNeutral(year, month);
    }

    return Column(
      children: [
        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildWeekdayHeader(localizations.monday, calendarType),
            _buildWeekdayHeader(localizations.tuesday, calendarType),
            _buildWeekdayHeader(localizations.wednesday, calendarType),
            _buildWeekdayHeader(localizations.thursday, calendarType),
            _buildWeekdayHeader(localizations.friday, calendarType),
            _buildWeekdayHeader(localizations.saturday, calendarType),
            _buildWeekdayHeader(localizations.sunday, calendarType,
                isSunday: true),
          ],
        ),
        const SizedBox(height: 4),
        // Calendar grid
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // 6 grid rows + 1 extra when leap day needs positioning below
              const gridRows = 6;
              final totalVisualRows = fixedVisualRows ?? (isNeutralLeapFeb ? gridRows + 1 : gridRows);

              // Cell size — account for 2px mainAxisSpacing between rows
              final cellW = (constraints.maxWidth - 2 * 6) / 7;
              final totalSpacing = (totalVisualRows - 1) * 2.0;
              final cellH =
                  (constraints.maxHeight - totalSpacing) / totalVisualRows;

              final gridItemCount = gridRows * 7;

              return Stack(
                children: [
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: cellW / cellH,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemCount: gridItemCount,
                    itemBuilder: (context, index) {
                      // Previous month days
                      if (index < firstWeekday) {
                        final prevMonth = month == 1 ? 12 : month - 1;
                        final prevYear = month == 1 ? year - 1 : year;
                        final int daysInPrevMonth;
                        if (calendarType == CalendarType.normal) {
                          daysInPrevMonth = CalendarConverter.getDaysInMonthNormal(prevYear, prevMonth);
                        } else if (calendarType == CalendarType.allChristian &&
                            prevMonth == 2 &&
                            CalendarConverter.isLeapYearNormal(prevYear)) {
                          daysInPrevMonth = 31;
                        } else {
                          daysInPrevMonth = CalendarConverter.getDaysInMonthNeutral(prevYear, prevMonth);
                        }
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
                      final isToday = todayYear == year &&
                          todayMonth == month &&
                          todayDay == day;
                      final isSelected = selectedDay != null &&
                          selectedDay! <= daysInMonth &&
                          selectedDay == day;

                      // Sunday column (index % 7 == 6) — bright red
                      final isSundayCell = index % 7 == 6;

                      // Gregorian Feb 29 — actual leap day (amber highlight)
                      final isGregorianLeapDay =
                          calendarType == CalendarType.normal &&
                              month == 2 &&
                              day == 29 &&
                              CalendarConverter.isLeapYearNormal(year);

                      // All Christian Feb 31 — leap day inside the grid (amber highlight)
                      final isAllChristianLeapDay =
                          calendarType == CalendarType.allChristian &&
                              month == 2 &&
                              day == 31 &&
                              CalendarConverter.isLeapYearNormal(year);

                      return _buildDayCell(
                        day,
                        isToday,
                        isSelected,
                        calendarType,
                        isLeapDay: isGregorianLeapDay || isAllChristianLeapDay,
                        isSundayHighlight: isSundayCell,
                      );
                    },
                  ),
                  // Neutral Feb 31 — positioned below grid, centered (col 3)
                  if (isNeutralLeapFeb)
                    Positioned(
                      top: gridRows * (cellH + 2),
                      left: 3 * (cellW + 2),
                      width: cellW,
                      height: cellH,
                      child: _buildDayCell(
                        31,
                        false,
                        selectedDay == 31,
                        calendarType,
                        isLeapDay: true,
                      ),
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
      color = Colors.red;
    } else {
      switch (calendarType) {
        case CalendarType.normal:
          color = Colors.blue.shade700;
          break;
        case CalendarType.neutral:
        case CalendarType.allChristian:
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

  Widget _buildDayCell(
    int day,
    bool isToday,
    bool isSelected,
    CalendarType calendarType, {
    bool isDisabled = false,
    bool isLeapDay = false,
    bool isSundayHighlight = false, // bright red for Sunday
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
      textColor = isSundayHighlight
          ? Colors.red
          : calendarType == CalendarType.normal
              ? Colors.blue.shade700
              : Colors.green.shade700;
      borderColor = isSundayHighlight
          ? Colors.red.withValues(alpha: 0.4)
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
          ? (onTap != null
              ? () {
                  playClick();
                  onTap();
                }
              : null)
          : (onDaySelected != null
              ? () {
                  playClick();
                  onDaySelected!(day);
                }
              : null),
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
