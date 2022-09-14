extension DateTimeExtension on DateTime {
  String get asDayMonthYear => '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';

  String get timeAs24Hours => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  String get asWeekDay {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      default:
        return 'Sunday';
    }
  }
}
