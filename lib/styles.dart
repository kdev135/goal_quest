import 'package:flutter/material.dart';

class AppTextStyles {

  static const TextStyle headline1 = TextStyle(
    fontSize: 20,

    fontWeight: FontWeight.w600,
  ); // For primary page titles

  static const TextStyle headline2 = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w600, ); // For secondary page titles or section headers

  static const TextStyle headline3 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  ); // For tertiary page titles or content blocks

  static const TextStyle bodyText1 =
      TextStyle(fontSize: 14, letterSpacing: 1, fontWeight: FontWeight.w400); // For main body text

  static const TextStyle bodyText2 = TextStyle(
    fontSize: 12,
  ); // For secondary body text or supporting information

  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  ); // For button text

  static const TextStyle captionText =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w300); // For small details or captions

  static const TextStyle labelText = TextStyle(
    fontSize: 14,
    letterSpacing: 1,
    fontWeight: FontWeight.w500,
  ); // For form labels or other descriptive text
}
