import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

const kCAccentOrange = Color(0xFFCF6F19);
const kCPrimaryCTAColor = Color.fromARGB(255, 33, 136, 150);
const kCLightGrey = Color.fromARGB(255, 160, 160, 160);
const kCDarkGrey = Color.fromARGB(255, 103, 103, 103);
final interactiveFieldGrey = const Color.fromARGB(255, 111, 111, 111).withOpacity(0.2);

final achievedGoalBox = Hive.box('achievedGoalBox');
final goalBox = Hive.box('myGoalBox');
const defaultQuote = 'The most effective way to do it, is to do it.\n\n- Ameilia Earhart';
const logoIconPath = 'assets/icon/round_logo.png';
const notificationKey = 'key1';
