import 'calendar_date.dart';

class SpecialDay {
  final CalendarDate date;
  final String title;
  final String description;
  final DayColor color;
  final bool isHoliday;

  SpecialDay({
    required this.date,
    required this.title,
    required this.description,
    required this.color,
    this.isHoliday = false,
  });
}
