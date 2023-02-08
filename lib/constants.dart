import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

const primaryColor = Color(0xFFCF6F19);
var interactiveFieldGrey = Colors.grey[300]!.withOpacity(0.2);

final achievedGoalBox = Hive.box('achievedGoalBox');
final goalBox = Hive.box('myGoalBox');