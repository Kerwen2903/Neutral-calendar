import '../models/calendar_date.dart';
import '../models/calendar_type.dart';
import '../models/date_mapping.dart';

class CalendarConverter {
  // Neutral calendar structure:
  // - 12 months total
  // - Pattern for each season: 31, 30, 30 days
  // - Exception: February has 30 days (31 in leap years)
  // - Exception: December (last month) has 31 days
  // - Year starts on Sunday, ends on Sunday
  
  static const int neutralMonthsPerYear = 12;
  
  // Get days in month for Neutral calendar
  static int getDaysInMonthNeutral(int year, int month) {
    if (month < 1 || month > 12) return 30;
    
    // Season pattern: 31, 30, 30
    switch (month) {
      case 1:  // January - 1st month of season
        return 31;
      case 2:  // February - 2nd month (30 normally, 31 in leap year)
        return isLeapYearNeutral(year) ? 31 : 30;
      case 3:  // March - 3rd month
        return 30;
      case 4:  // April - 1st month of season
        return 31;
      case 5:  // May - 2nd month
        return 30;
      case 6:  // June - 3rd month
        return 30;
      case 7:  // July - 1st month of season
        return 31;
      case 8:  // August - 2nd month
        return 30;
      case 9:  // September - 3rd month
        return 30;
      case 10: // October - 1st month of season
        return 31;
      case 11: // November - 2nd month
        return 30;
      case 12: // December - last month (special)
        return 31;
      default:
        return 30;
    }
  }

  // Convert from Normal (Gregorian) to Neutral calendar
  static CalendarDate normalToNeutral(CalendarDate normalDate) {
    if (normalDate.calendarType != CalendarType.normal) {
      throw ArgumentError('Input must be a Normal calendar date');
    }

    int totalDays = _getTotalDaysFromEpoch(
      normalDate.year,
      normalDate.month,
      normalDate.day,
    );

    int adjustedDays = totalDays - 28;
    return _daysToNeutralDate(adjustedDays);
  }

  // Convert from Neutral to Normal (Gregorian) calendar
  static CalendarDate neutralToNormal(CalendarDate neutralDate) {
    if (neutralDate.calendarType != CalendarType.neutral) {
      throw ArgumentError('Input must be a Neutral calendar date');
    }

    int totalDays = _getTotalDaysFromEpoch(
      neutralDate.year,
      neutralDate.month,
      neutralDate.day,
    );

    int adjustedDays = totalDays + 28;
    return _daysToNormalDate(adjustedDays);
  }

  // Create a date mapping between both systems
  static DateMapping createMapping(CalendarDate date) {
    if (date.calendarType == CalendarType.normal) {
      return DateMapping(normalDate: date, neutralDate: normalToNeutral(date));
    } else {
      return DateMapping(normalDate: neutralToNormal(date), neutralDate: date);
    }
  }

  // Helper: Get total days from epoch (January 1, 2000)
  static int _getTotalDaysFromEpoch(int year, int month, int day) {
    final baseDate = DateTime(2000, 1, 1);
    final targetDate = DateTime(year, month, day);
    return targetDate.difference(baseDate).inDays;
  }

  // Helper: Convert days to Neutral calendar date
  static CalendarDate _daysToNeutralDate(int days) {
    // Implement the Neutral calendar logic based on your friend's system
    // This is a placeholder implementation
    final baseDate = DateTime(2000, 1, 1).add(Duration(days: days));

    return CalendarDate(
      year: baseDate.year,
      month: baseDate.month,
      day: baseDate.day,
      calendarType: CalendarType.neutral,
    );
  }

  // Helper: Convert days to Normal calendar date
  static CalendarDate _daysToNormalDate(int days) {
    final baseDate = DateTime(2000, 1, 1).add(Duration(days: days));

    return CalendarDate(
      year: baseDate.year,
      month: baseDate.month,
      day: baseDate.day,
      calendarType: CalendarType.normal,
    );
  }

  // Check if a year is a leap year in the Normal calendar
  static bool isLeapYearNormal(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  // Check if a year is a leap year in the Neutral calendar
  static bool isLeapYearNeutral(int year) {
    // Use same logic as Gregorian for now
    return isLeapYearNormal(year);
  }

  // Get number of days in a month for Normal calendar
  static int getDaysInMonthNormal(int year, int month) {
    if (month == 2) {
      return isLeapYearNormal(year) ? 29 : 28;
    }
    if ([4, 6, 9, 11].contains(month)) {
      return 30;
    }
    return 31;
  }
  
  // Get first day of week for a month in Neutral calendar
  // Neutral calendar always starts the year on Sunday (index 6)
  static int getFirstWeekdayNeutral(int year, int month) {
    // Calculate total days from start of year to this month
    int totalDays = 0;
    for (int m = 1; m < month; m++) {
      totalDays += getDaysInMonthNeutral(year, m);
    }
    
    // Year starts on Sunday (index 6)
    // Add total days and mod 7 to get current month's starting weekday
    return (6 + totalDays) % 7;
  }
}
