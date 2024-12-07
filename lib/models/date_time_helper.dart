import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DateTimeHelper {
  static String formatTimestamp(Timestamp timestamp) {
    DateTime now = DateTime.now();
    DateTime date = timestamp.toDate();

    // Check if it's today
    if (isSameDay(date, now)) {
      return 'Today';
    }

    // Check if it's yesterday
    DateTime yesterday = DateTime(now.year, now.month, now.day - 1);
    if (isSameDay(date, yesterday)) {
      return 'Yesterday';
    }

    // Otherwise, format as date and month
    return DateFormat('dd MMM').format(date);
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}
