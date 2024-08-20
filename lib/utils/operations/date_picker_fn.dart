
  import 'package:flutter/material.dart';

Future<DateTime?> datePicker(BuildContext context, int thisYear, int thisMonth, int todayDate) {
    return showDatePicker(
        context: context,
        initialDate: DateTime(thisYear, thisMonth, todayDate),
        firstDate: DateTime.now(),
        lastDate: DateTime(2033));
  }