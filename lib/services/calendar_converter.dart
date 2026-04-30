import '../models/calendar_date.dart';
import '../models/calendar_type.dart';
import '../models/date_mapping.dart';

class CalendarConverter {
  // Neutral calendar structure:
  // - 12 months total
  // - Pattern for each season: 31, 30, 30 days
  // - February always has 30 days (no leap years; Gregorian Feb 29 is absorbed)
  // - Exception: December (last month) has 31 days
  // - Year starts on Sunday, ends on Sunday

  static const int neutralMonthsPerYear = 12;

  // Get days in month for Neutral calendar
  static int getDaysInMonthNeutral(int year, int month) {
    if (month < 1 || month > 12) return 30;

    // Season pattern: 31, 30, 30
    // The Neutral calendar has NO leap years — February is always 30 days.
    // The Gregorian leap day (Feb 29) is absorbed at the conversion layer.
    switch (month) {
      case 1: // January - 1st month of season
        return 31;
      case 2: // February - always 30 days (leap day handled in conversion)
        return 30;
      case 3: // March - 3rd month
        return 30;
      case 4: // April - 1st month of season
        return 31;
      case 5: // May - 2nd month
        return 30;
      case 6: // June - 3rd month
        return 30;
      case 7: // July - 1st month of season
        return 31;
      case 8: // August - 2nd month
        return 30;
      case 9: // September - 3rd month
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

    // Get day of year in Gregorian calendar
    final startOfYear = DateTime(normalDate.year, 1, 1);
    final targetDate = DateTime(
      normalDate.year,
      normalDate.month,
      normalDate.day,
    );
    int dayOfYear = targetDate.difference(startOfYear).inDays + 1;

    // The Neutral calendar has no leap years.
    // In a Gregorian leap year, absorb the extra day at Gregorian Mar 2 (day 62):
    //   • Gregorian Feb 29 (day 60) → neutral Feb 29 (day 60). Same day-of-year.
    //   • Gregorian Mar 1 (day 61) → neutral Feb 30 (day 61). Same day-of-year.
    //   • Gregorian Mar 2 (day 62) → neutral day 61 = neutral Feb 30 (absorbed).
    //   • All days from Mar 3 onward are decremented by 1.
    if (isLeapYearNormal(normalDate.year) && dayOfYear > 61) {
      dayOfYear -= 1;
    }

    // Convert to Neutral calendar month and day
    int month = 1;
    int day = dayOfYear;

    while (month <= 12) {
      final daysInMonth = getDaysInMonthNeutral(normalDate.year, month);
      if (day <= daysInMonth) {
        break;
      }
      day -= daysInMonth;
      month++;
    }

    return CalendarDate(
      year: normalDate.year,
      month: month,
      day: day,
      calendarType: CalendarType.neutral,
    );
  }

  // Convert from Neutral to Normal (Gregorian) calendar
  static CalendarDate neutralToNormal(CalendarDate neutralDate) {
    if (neutralDate.calendarType != CalendarType.neutral) {
      throw ArgumentError('Input must be a Neutral calendar date');
    }

    // Convert Neutral date to day of year
    int dayOfYear = 0;
    for (int m = 1; m < neutralDate.month; m++) {
      dayOfYear += getDaysInMonthNeutral(neutralDate.year, m);
    }
    dayOfYear += neutralDate.day;

    // In a Gregorian leap year, re-insert the leap day for neutral Mar 1 onward.
    // Neutral Feb 29 (day 60) → Gregorian day 60 = Feb 29 (no shift).
    // Neutral Feb 30 (day 61) → Gregorian day 61 = Mar 1 (no shift).
    // Neutral Mar 1 (day 62) onward: +1 to skip over Gregorian Feb 29.
    if (isLeapYearNormal(neutralDate.year) && dayOfYear > 61) {
      dayOfYear += 1;
    }

    // Convert day of year to Gregorian date
    final startOfYear = DateTime(neutralDate.year, 1, 1);
    final targetDate = startOfYear.add(Duration(days: dayOfYear - 1));

    return CalendarDate(
      year: targetDate.year,
      month: targetDate.month,
      day: targetDate.day,
      calendarType: CalendarType.normal,
    );
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
    // Calculate from epoch (Jan 1, 2000) using Neutral calendar structure
    final normalDate = DateTime(2000, 1, 1).add(Duration(days: days));

    // For now, use the same year as Gregorian
    int year = normalDate.year;

    // Calculate day of year in Gregorian calendar
    final startOfYear = DateTime(year, 1, 1);
    int dayOfYear = normalDate.difference(startOfYear).inDays + 1;

    // Absorb Gregorian leap day at Mar 2 (day 62).
    if (isLeapYearNormal(year) && dayOfYear > 61) {
      dayOfYear -= 1;
    }

    // Convert to Neutral calendar month and day
    // Neutral calendar pattern: 31, 30, 30, 31, 30, 30, 31, 30, 30, 31, 30, 31
    int month = 1;
    int day = dayOfYear;

    while (month <= 12) {
      final daysInMonth = getDaysInMonthNeutral(year, month);
      if (day <= daysInMonth) {
        break;
      }
      day -= daysInMonth;
      month++;
    }

    return CalendarDate(
      year: year,
      month: month,
      day: day,
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

  // Check if a year is a leap year in the Neutral calendar.
  // The Neutral calendar has NO leap years — it always has 365 days.
  // The Gregorian leap day is absorbed transparently in conversions.
  static bool isLeapYearNeutral(int year) {
    return false;
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

  // Convert Gregorian → All Christian for the comparison screen.
  // The Gregorian leap day is NOT absorbed: Gregorian day-of-year maps
  // directly to All Christian day-of-year using neutral month lengths
  // (with Feb = 31 days in leap years instead of neutral's 30).
  // Result: Gregorian Feb 29 → All Christian Feb 29,
  //         Gregorian Mar 1  → All Christian Feb 30, etc.
  static CalendarDate normalToAllChristian(CalendarDate normalDate) {
    final startOfYear = DateTime(normalDate.year, 1, 1);
    final targetDate =
        DateTime(normalDate.year, normalDate.month, normalDate.day);
    int dayOfYear = targetDate.difference(startOfYear).inDays + 1;

    int month = 1;
    int day = dayOfYear;
    while (month <= 12) {
      final dim = (month == 2 && isLeapYearNormal(normalDate.year))
          ? 31
          : getDaysInMonthNeutral(normalDate.year, month);
      if (day <= dim) break;
      day -= dim;
      month++;
    }
    return CalendarDate(
      year: normalDate.year,
      month: month,
      day: day,
      calendarType: CalendarType.neutral,
    );
  }

  // Convert All Christian → Gregorian for the comparison screen.
  // Computes All Christian day-of-year (Feb = 31 in leap years) and maps it
  // straight to the Gregorian date with the same day-of-year number.
  // Result: All Christian Feb 29 → Gregorian Feb 29,
  //         All Christian Feb 30 → Gregorian Mar 1, etc.
  static CalendarDate allChristianToNormal(CalendarDate allChristianDate) {
    int dayOfYear = 0;
    for (int m = 1; m < allChristianDate.month; m++) {
      dayOfYear += (m == 2 && isLeapYearNormal(allChristianDate.year))
          ? 31
          : getDaysInMonthNeutral(allChristianDate.year, m);
    }
    dayOfYear += allChristianDate.day;

    final startOfYear = DateTime(allChristianDate.year, 1, 1);
    final targetDate = startOfYear.add(Duration(days: dayOfYear - 1));
    return CalendarDate(
      year: targetDate.year,
      month: targetDate.month,
      day: targetDate.day,
      calendarType: CalendarType.normal,
    );
  }

  // Get first day of week for a month in All Christian calendar.
  // Like getFirstWeekdayNeutral but the year starts on the real Gregorian
  // weekday of Jan 1, and Feb counts as 31 days in leap years so that the
  // week flows correctly for March and beyond.
  static int getFirstWeekdayAllChristian(int year, int month) {
    int totalDays = 0;
    for (int m = 1; m < month; m++) {
      totalDays += (m == 2 && isLeapYearNormal(year))
          ? 31
          : getDaysInMonthNeutral(year, m);
    }
    final jan1Weekday = DateTime(year, 1, 1).weekday - 1; // 0=Mon..6=Sun
    return (jan1Weekday + totalDays) % 7;
  }
}
