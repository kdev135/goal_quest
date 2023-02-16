import 'package:intl/intl.dart';

// Get the number of days since the goal creation date
String getAchievementTime({required String dateToFormat}) {
  DateFormat inputFormat = DateFormat('dd-MM-yyyy');
  DateTime date = inputFormat.parse(dateToFormat);
  DateFormat outputFormat = DateFormat('yyyy-MM-dd');
  String formattedDate = outputFormat.format(date);
  var timeDifference = DateTime.now().difference(DateTime.parse(formattedDate)).inDays;
  return timeDifference.toString();
}
