enum CalendarType {
  normal, // Gregorian/Normal calendar
  neutral, // Neutral calendar system
}

extension CalendarTypeExtension on CalendarType {
  String get name {
    switch (this) {
      case CalendarType.normal:
        return 'Normal';
      case CalendarType.neutral:
        return 'Neutral';
    }
  }
}
