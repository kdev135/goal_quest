
  import 'package:flutter/material.dart';

Future<DateTime?> datePicker(BuildContext context, int thisYear, int thisMonth, int todayDate) {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(thisYear, thisMonth, todayDate),
        lastDate: DateTime(2033));
  }