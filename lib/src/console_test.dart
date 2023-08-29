import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stack_trace/stack_trace.dart';

abstract class IConsoleTest {
  List<String> getOutput(Duration elapsed, Duration delta);
}

extension TestConsoleStringEx on String? {
  void ilog() {
    dev.log('\x1B[36m[${Trace.current().frames[1].member}] $this\x1B[0m');
  }
}
