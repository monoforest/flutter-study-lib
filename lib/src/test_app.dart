import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

GlobalKey rootKey = GlobalKey<NavigatorState>();

class TestApp extends StatefulWidget {
  final FlexScheme scheme;
  final Widget Function(BuildContext context) testBuilder;

  const TestApp({
    super.key,
    required this.testBuilder,
    required this.scheme,
  });

  @override
  State<TestApp> createState() => _AppState();
}

class _AppState extends State<TestApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: rootKey as GlobalKey<NavigatorState>,
      theme: FlexColorScheme.light(scheme: widget.scheme).toTheme,
      routes: {
        '/': widget.testBuilder,
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
