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

    // Get days in month
    final daysInMonth = calendarType == CalendarType.normal
        ? CalendarConverter.getDaysInMonthNormal(year, month)
        : CalendarConverter.getDaysInMonthNeutral(year, month);

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
            _buildWeekdayHeader(localizations.monday, calendarType),
            _buildWeekdayHeader(localizations.tuesday, calendarType),
            _buildWeekdayHeader(localizations.wednesday, calendarType),
            _buildWeekdayHeader(localizations.thursday, calendarType),
            _buildWeekdayHeader(localizations.friday, calendarType),
            _buildWeekdayHeader(localizations.saturday, calendarType),
            _buildWeekdayHeader(localizations.sunday, calendarType),
          ],
        ),
        const SizedBox(height: 4),
        // Calendar grid
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Calculate number of weeks needed (rows)
              final totalCells = firstWeekday + daysInMonth;
              final weeksNeeded = (totalCells / 7).ceil();

              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio:
                      constraints.maxWidth /
                      (constraints.maxHeight / weeksNeeded) /
                      7,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                itemCount: weeksNeeded * 7, // Ensure we fill all weeks
                itemBuilder: (context, index) {
                  // Previous month days
                  if (index < firstWeekday) {
                    final prevMonth = month == 1 ? 12 : month - 1;
                    final prevYear = month == 1 ? year - 1 : year;
                    final daysInPrevMonth = calendarType == CalendarType.normal
                        ? CalendarConverter.getDaysInMonthNormal(
                            prevYear,
                            prevMonth,
                          )
                        : CalendarConverter.getDaysInMonthNeutral(
                            prevYear,
                            prevMonth,
                          );
                    final day = daysInPrevMonth - (firstWeekday - index - 1);
                    return _buildDayCell(
                      day,
                      false,
                      false,
                      calendarType,
                      isDisabled: true,
                      onTap: onPreviousMonthDaySelected != null
                          ? () => onPreviousMonthDaySelected!(
                              prevYear,
                              prevMonth,
                              day,
                            )
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
                              nextYear,
                              nextMonth,
                              day,
                            )
                          : null,
                    );
                  }

                  // Current month days
                  final day = index - firstWeekday + 1;
                  final isToday =
                      DateTime.now().year == year &&
                      DateTime.now().month == month &&
                      DateTime.now().day == day;
                  // Only show selection if the selected day is valid for this calendar
                  final isSelected =
                      selectedDay != null &&
                      selectedDay! <= daysInMonth &&
                      selectedDay == day;

                  return _buildDayCell(day, isToday, isSelected, calendarType);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeekdayHeader(String text, CalendarType calendarType) {
    Color color;
    switch (calendarType) {
      case CalendarType.normal:
        color = Colors.blue.shade700;
        break;
      case CalendarType.neutral:
        color = Colors.green.shade700;
        break;
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
      borderColor = backgroundColor!;
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
      textColor = null;
      borderColor = Colors.grey.shade300;
    }

    return InkWell(
      onTap: isDisabled
          ? onTap
          : (onDaySelected != null ? () => onDaySelected!(day) : null),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: isSelected ? 1.5 : 0.8),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Center(
          child: Text(
            day.toString(),
            style: TextStyle(
              color: textColor,
              fontWeight: isToday || isSelected
                  ? FontWeight.bold
                  : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
