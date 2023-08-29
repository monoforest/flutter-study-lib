import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lib/src/ext.state.dart';
import 'package:lib/src/itext_test.dart';

class TextTest extends StatefulWidget {
  final List<ITextTest> tests;

  const TextTest({
    super.key,
    required this.tests,
  });

  @override
  State<TextTest> createState() => _TextTestState();
}

class _TextTestState extends State<TextTest> with TickerProviderStateMixin {
  Ticker? ticker;
  List<String> output = [];
  ValueNotifier<int> outputNoti = ValueNotifier(0);
  late TabController tabCon;
  int tabIndex = 0;

  ITextTest get curTest => widget.tests[tabIndex];

  @override
  void initState() {
    super.initState();
    ticker = createTicker(_onTick);
    ticker?.start();

    tabCon = TabController(
      length: widget.tests.length,
      vsync: this,
    );
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
    return Column(
      children: [
        TabBar(
          tabs: widget.tests.map((e) => Tab(text: e.authorName)).toList(),
          onTap: (newIndex) {
            safeSetState(() {
              tabIndex = newIndex;
              lastElapsed = null;
              ticker?.stop();
              ticker?.start();
            });
          },
        ),
        Expanded(
          child: TabBarView(
            controller: tabCon,
            children: widget.tests
                .map((e) => Center(
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
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Duration? lastElapsed;
  void _onTick(Duration elapsed) {
    final delta = lastElapsed == null ? Duration.zero : elapsed - lastElapsed!;
    lastElapsed = elapsed;

    output = curTest.getOutput(elapsed, delta);
    outputNoti.value += 1;
  }
}
