import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  Debouncer({required this.delay});
  final Duration delay;
  Timer? _timer;

  void call(VoidCallback callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }
}
