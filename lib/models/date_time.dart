import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FormattedDate {
  final Timestamp timestamp;

  FormattedDate({required this.timestamp});

  String getFormattedDate() {
    DateTime date = timestamp.toDate();
    String formattedDate = DateFormat('d MMMM yyyy').format(date); // Format date

    String amPm = DateFormat('a').format(date); // AM or PM
    String hours = DateFormat('h').format(date); // Hours in 12 hours format
    String minutes = DateFormat('mm').format(date); // Minutes

    return '$formattedDate at $hours:$minutes $amPm';
  }
}