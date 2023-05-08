import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

const primaryColor = Color(0xFFCF6F19);
const interactiveColor = Color.fromARGB(255, 33, 136, 150);
final interactiveFieldGrey = Colors.grey[300]!.withOpacity(0.2);

final achievedGoalBox = Hive.box('achievedGoalBox');
final goalBox = Hive.box('myGoalBox');
const defaultQuote = 'The most effective way to do it, is to do it.\n\n- Ameilia Earhart';
const logoIconPath = 'assets/icon/round_logo.png';
const notificationKey = 'key1';
