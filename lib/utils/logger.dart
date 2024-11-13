import 'package:flutter/foundation.dart';

class Log {
  Log._();

  static void v({dynamic msg, String tag = "Debug Log"}) {
    if (kDebugMode) {
      print('[$tag]: $msg');
    }
  }
}
