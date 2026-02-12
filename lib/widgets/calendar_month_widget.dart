import 'package:flutter/material.dart';
import '../l10n/app_localizations_manual.dart';
import '../models/calendar_type.dart';
import '../services/calendar_converter.dart';
import '../models/calendar_date.dart';

class CalendarMonthWidget extends StatelessWidget {
  final int year;
  final int month;
  final CalendarType calendarType;

  const CalendarMonthWidget({
    super.key,
    required this.year,
    required this.month,
    required this.calendarType,
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
      // For Neutral calendar, apply the offset
      final normalDate = CalendarDate(
        year: year,
        month: month,
        day: 1,
        calendarType: CalendarType.normal,
      );
      final neutralDate = CalendarConverter.normalToNeutral(normalDate);
      final firstDayOfMonth = DateTime(
        neutralDate.year,
        neutralDate.month,
        neutralDate.day,
      );
      firstWeekday = firstDayOfMonth.weekday - 1;
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
        const SizedBox(height: 8),
        // Calendar grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
            final isToday =
                DateTime.now().year == year &&
                DateTime.now().month == month &&
                DateTime.now().day == day;

            return _buildDayCell(day, isToday, calendarType);
          },
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
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildDayCell(int day, bool isToday, CalendarType calendarType) {
    Color backgroundColor;
    Color textColor = Colors.black87;

    if (isToday) {
      backgroundColor = calendarType == CalendarType.normal
          ? Colors.blue.shade100
          : Colors.green.shade100;
      textColor = calendarType == CalendarType.normal
          ? Colors.blue.shade900
          : Colors.green.shade900;
    } else {
      backgroundColor = Colors.grey.shade50;
    }

    // TODO: Apply color coding based on special days from the image
    // This would check the CalendarDate and apply yellow, green, pink, etc.

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          day.toString(),
          style: TextStyle(
            color: textColor,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
