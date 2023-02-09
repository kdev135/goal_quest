import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

const primaryColor = Color(0xFFCF6F19);
var interactiveFieldGrey = Colors.grey[300]!.withOpacity(0.2);

final achievedGoalBox = Hive.box('achievedGoalBox'); // return the hive box with attained goals
final goalBox = Hive.box('myGoalBox'); // return the Hive box with unachieved goals
final quoteBox = Hive.box('quoteBox'); //return the Hive box with quotes
final quoteData = quoteBox.get('newQuote'); // Get the stored quote from hive box
const defaultQuote = 'The most effective way to do it, is to do it.\n\n- Ameilia Earhart';

