import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lib/src/console_test.dart';
import 'package:stack_trace/stack_trace.dart';

class TextTest extends StatefulWidget {
  final ITextTest test;

  const TextTest({
    super.key,
    required this.test,
  });

  @override
  State<TextTest> createState() => _TextTestState();
}

class _TextTestState extends State<TextTest> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (c) => TextTestScreen(test: widget.test),
      },
    );
  }
}

class TextTestScreen extends StatefulWidget {
  final ITextTest test;

  const TextTestScreen({
    super.key,
    required this.test,
  });

  @override
  State<TextTestScreen> createState() => _TextTestScreenState();
}

class _TextTestScreenState extends State<TextTestScreen>
    with SingleTickerProviderStateMixin {
  Ticker? ticker;
  List<String> output = [];
  ValueNotifier<int> outputNoti = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    ticker = createTicker(_onTick);
    ticker?.start();
  }

  @override
  void dispose() {
    outputNoti.dispose();
    ticker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Center(
      child: AnimatedBuilder(
        animation: outputNoti,
        builder: (context, _) {
          return Text(
            output.join('\n'),
            style: TextStyle(
              fontFeatures: [
                FontFeature.tabularFigures(),
              ],
            ),
          );
        },
      ),
    );
  }

  Duration? lastElapsed;
  void _onTick(Duration elapsed) {
    final delta = lastElapsed == null ? Duration.zero : elapsed - lastElapsed!;
    lastElapsed = elapsed;

    output = widget.test.getOutput(elapsed, delta);
  }
}
