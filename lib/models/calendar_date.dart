import 'calendar_type.dart';

class CalendarDate {
  final int year;
  final int month;
  final int day;
  final CalendarType calendarType;
  final DayColor? color;
  final bool isSpecialDay;
  final String? specialDayNote;

  CalendarDate({
    required this.year,
    required this.month,
    required this.day,
    required this.calendarType,
    this.color,
    this.isSpecialDay = false,
    this.specialDayNote,
  });

  @override
  String toString() {
    return '$day/${month.toString().padLeft(2, '0')}/$year (${calendarType.name})';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarDate &&
          runtimeType == other.runtimeType &&
          year == other.year &&
          month == other.month &&
          day == other.day &&
          calendarType == other.calendarType;

  @override
  int get hashCode =>
      year.hashCode ^ month.hashCode ^ day.hashCode ^ calendarType.hashCode;

  CalendarDate copyWith({
    int? year,
    int? month,
    int? day,
    CalendarType? calendarType,
    DayColor? color,
    bool? isSpecialDay,
    String? specialDayNote,
  }) {
    return CalendarDate(
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
      calendarType: calendarType ?? this.calendarType,
      color: color ?? this.color,
      isSpecialDay: isSpecialDay ?? this.isSpecialDay,
      specialDayNote: specialDayNote ?? this.specialDayNote,
    );
  }
}

enum DayColor {
  yellow, // Yellow marked days
  green, // Green marked days
  pink, // Pink marked days
  blue, // Blue marked days
  normal, // Regular days
}
