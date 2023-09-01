import 'dart:ui';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lib/src/ext.state.dart';
import 'package:lib/src/itext_test.dart';
import 'package:lib/src/test_app.dart';
import 'package:lib/study_lib.dart';

void runTextTest(ITextTest test,
    {FlexScheme scheme = FlexScheme.blueM3, String title = 'Text Test'}) {
  runApp(
    TestApp(
      scheme: scheme,
      testBuilder: (context) => TextTest(
        title: title,
        tests: [test],
      ),
    ),
  );
}

Widget buildTextTest(ITextTest test,
    {FlexScheme scheme = FlexScheme.blueM3, String title = 'Text Test'}) {
  return TestApp(
    scheme: scheme,
    testBuilder: (context) => TextTest(
      title: title,
      tests: [test],
    ),
  );
}

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
  GlobalKey testKey = GlobalKey();

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
              testKey = GlobalKey();
            });
          },
        ),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Center(
      child: TestScreen(
        key: testKey,
        test: curTest,
      ),
    );
    // return Column(
    //   children: [
    //     Expanded(
    //       child: TabBarView(
    //         controller: tabCon,
    //         children: widget.tests
    //             .map((e) => TestScreen(
    //                   test: e,
    //                 ))
    //             .toList(),
    //       ),
    //     ),
    //   ],
    // );
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
  TextEditingController inputCon = TextEditingController();

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
    return AnimatedBuilder(
      animation: outputNoti,
      builder: (context, _) {
        final outputMsec = outputDuration?.inMilliseconds ?? 0.0;
        final outputFps = outputMsec <= 0.0 ? 0.0 : 1000.0 / outputMsec;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (outputDuration != null)
              Text(
                'frame time: ${outputDuration!.inMilliseconds} msec, '
                '${outputFps.toStringAsFixed(2)} fps',
                style: kRubikMediumMono.copyWith(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextFormField(
                    controller: inputCon,
                    decoration: InputDecoration(
                      labelText: 'Input...',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    widget.test.setInput(inputCon.text.split(' '));
                    inputCon.clear();
                  },
                  child: Text('전달'),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Text(
                  output.join('\n'),
                  style: TextStyle(
                    fontFeatures: [
                      FontFeature.tabularFigures(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Duration? outputDuration;
  Duration? lastElapsed;
  void _onTick(Duration elapsed) {
    final delta = lastElapsed == null ? Duration.zero : elapsed - lastElapsed!;
    lastElapsed = elapsed;

    final watch = Stopwatch();
    try {
      watch.start();
      output = widget.test.getOutput(elapsed, delta);
    } catch (e, s) {
      'FAIED $e, $s'.ilog();
      output = ['FAILED $e', '$s'];
    } finally {
      watch.stop();
      outputDuration = watch.elapsed;
    }

    outputNoti.value += 1;
  }
}
