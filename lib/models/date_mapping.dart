import 'calendar_date.dart';

class DateMapping {
  final CalendarDate normalDate;
  final CalendarDate neutralDate;

  DateMapping({required this.normalDate, required this.neutralDate});

  @override
  String toString() {
    return 'Normal: $normalDate <-> Neutral: $neutralDate';
  }
}
