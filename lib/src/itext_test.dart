import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stack_trace/stack_trace.dart';

abstract class ITextTest {
  String get authorName;
  List<String> getOutput(Duration elapsed, Duration delta);
  void setInput(List<String> args);
}

extension StringEx on String? {
  void ilog() {
    dev.log('\x1B[36m[${Trace.current().frames[1].member}] $this\x1B[0m');
  }
}
