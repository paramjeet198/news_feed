import 'package:flutter/foundation.dart';

class Log {
  Log._();

  static void v(dynamic data) {
    if (kDebugMode) {
      print('Log: $data');
    }
  }
}
