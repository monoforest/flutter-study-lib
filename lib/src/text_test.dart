import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lib/src/ext.state.dart';
import 'package:lib/src/itext_test.dart';

class TextTest extends StatefulWidget {
  final String title;
  final List<ITextTest> tests;

  const TextTest({
    super.key,
    required this.tests,
    required this.title,
  });

  @override
  State<TextTest> createState() => _TextTestState();
}

class _TextTestState extends State<TextTest> with TickerProviderStateMixin {
  late TabController tabCon;
  int tabIndex = 0;

  ITextTest get curTest => widget.tests[tabIndex];

  @override
  void initState() {
    super.initState();

    tabCon = TabController(
      length: widget.tests.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          controller: tabCon,
          tabs: widget.tests.map((e) => Tab(text: e.authorName)).toList(),
          onTap: (newIndex) {
            safeSetState(() {
              tabIndex = newIndex;
            });
          },
        ),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Expanded(
          child: TabBarView(
            controller: tabCon,
            children: widget.tests
                .map((e) => TestScreen(
                      test: e,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class TestScreen extends StatefulWidget {
  final ITextTest test;

  const TestScreen({
    super.key,
    required this.test,
  });

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen>
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
    outputNoti.value += 1;
  }
}
