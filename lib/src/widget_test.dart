import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lib/src/ext.state.dart';
import 'package:lib/src/test_app.dart';

void runWidgetTest(IWidgetTest test,
    {FlexScheme scheme = FlexScheme.blueM3, String title = 'Text Test'}) {
  runApp(
    TestApp(
      scheme: scheme,
      testBuilder: (context) => WidgetTest(
        title: title,
        tests: [test],
      ),
    ),
  );
}

class WidgetTest extends StatefulWidget {
  final String title;
  final List<IWidgetTest> tests;

  const WidgetTest({
    super.key,
    required this.tests,
    required this.title,
  });

  @override
  State<WidgetTest> createState() => _WidgetTestState();
}

class _WidgetTestState extends State<WidgetTest>
    with SingleTickerProviderStateMixin {
  late TabController tabCon;
  int tabIndex = 0;

  GlobalKey testKey = GlobalKey();
  IWidgetTest get curTest => widget.tests[tabIndex];

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
      child: WidgetTestScreen(
        key: testKey,
        test: curTest,
      ),
    );
  }
}

abstract class IWidgetTest {
  String get authorName;
  StatefulWidget createWidget(BuildContext context, Key key);
}

abstract class ITickerState<T extends State> {
  void onTick(Duration elapsed, Duration delta);
}

class WidgetTestScreen extends StatefulWidget {
  final IWidgetTest test;

  const WidgetTestScreen({
    super.key,
    required this.test,
  });

  @override
  State<WidgetTestScreen> createState() => _WidgetTestScreenState();
}

class _WidgetTestScreenState extends State<WidgetTestScreen>
    with SingleTickerProviderStateMixin {
  Ticker? ticker;
  ValueNotifier<int> changeNoti = ValueNotifier(0);
  GlobalKey widgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    ticker = createTicker(_onTick);
    ticker?.start();
  }

  @override
  void dispose() {
    ticker?.dispose();
    changeNoti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: changeNoti,
      builder: (context, _) {
        return widget.test.createWidget(context, widgetKey);
      },
    );
  }

  Duration? lastElapsed;
  void _onTick(Duration elapsed) {
    final delta = lastElapsed == null ? Duration.zero : elapsed - lastElapsed!;
    lastElapsed = elapsed;

    final tickerState = widgetKey.currentState as ITickerState?;
    tickerState?.onTick(elapsed, delta);
    changeNoti.value += 1;
  }
}
