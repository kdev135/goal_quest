import 'package:intl/intl.dart';

/// Format the date to dd-MM-yyyy format and return a string
String customDateFormat(DateTime date) {
  DateFormat outputFormat = DateFormat("dd-MM-yyyy");
  String formattedDate = outputFormat.format(date);

  return formattedDate;
}


/// Convert custom date string to DateTime object
DateTime dateToDateTimeObject(String date) {
  DateFormat outputFormat = DateFormat("dd-MM-yyyy");
  DateTime dateTimeObject = outputFormat.parse(date);

  return dateTimeObject;
}