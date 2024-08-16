import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

enum RunningPlatform { web, android, other }

/// Check if app is running on web , Android or other
RunningPlatform checkPlatform() {
  if (kIsWeb) {
    return RunningPlatform.web;
  } else if (Platform.isAndroid) {
    return RunningPlatform.android;
  } else {
    return RunningPlatform.other;
  }
}