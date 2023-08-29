import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lib/src/util.future.dart';

extension WidgetExtension on Widget {
  Future<T?> pushNavigate<T>(BuildContext context) async {
    await Future.delayed(Duration.zero);
    return Navigator.of(context).push(CupertinoPageRoute(builder: (c) => this));
  }

  Future<T?> pushNavigateToRoot<T>(BuildContext context) async {
    try {
      Navigator.popUntil(context, ModalRoute.withName('/'));
    } catch (e) {}
    return Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (c) => this,
        settings: RouteSettings(name: '/'),
      ),
    );
  }

  Widget wrapTouch(
      {void Function()? onTap,
      void Function(TapDownDetails)? onTapDown,
      void Function(TapUpDetails)? onTapUp,
      void Function()? onTapCancel,
      void Function()? onLongPress,
      HitTestBehavior? behavior}) {
    return GestureDetector(
      onTap: onTap,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onLongPress: onLongPress,
      behavior: behavior,
      child: this,
    );
  }

  Widget wrapInkWell({
    void Function()? onTap,
    void Function()? onLongPress,
    void Function()? onDoubleTap,
    Color? splashColor,
    double? radius,
    InkWell? ink,
    bool delayCall = true,
    int delayCallMsec = 150,
  }) {
    return InkWell(
      onTap: delayCall
          ? () async {
              await delayMsec(msec: delayCallMsec);
              onTap?.call();
            }
          : onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      splashColor: splashColor,
      borderRadius: radius != null ? BorderRadius.circular(radius) : null,
      child: this,
    );
  }

  Widget wrapMouseRegion({
    void Function(PointerEnterEvent)? onEnter,
    void Function(PointerHoverEvent)? onHover,
    void Function(PointerExitEvent)? onExit,
    bool opaque = true,
    HitTestBehavior? behavior,
    MouseCursor? cursor,
  }) {
    return MouseRegion(
      onEnter: onEnter,
      onHover: onHover,
      onExit: onExit,
      opaque: opaque,
      hitTestBehavior: behavior,
      cursor: cursor ?? MouseCursor.defer,
      child: this,
    );
  }

  Widget pad(EdgeInsetsGeometry padding) {
    return Padding(
      padding: padding,
      child: this,
    );
  }

  Widget padAll([double size = 8]) {
    return Padding(
      padding: EdgeInsets.all(size),
      child: this,
    );
  }

  Widget padOnly(
      {double top = 0, double bottom = 0, double left = 0, double right = 0}) {
    return Padding(
      padding:
          EdgeInsets.only(top: top, bottom: bottom, left: left, right: right),
      child: this,
    );
  }

  Widget padRight([double size = 8]) {
    return Padding(
      padding: EdgeInsets.only(right: size),
      child: this,
    );
  }

  Widget padLeft([double size = 8]) {
    return Padding(
      padding: EdgeInsets.only(left: size),
      child: this,
    );
  }

  Widget padTop([double size = 8]) {
    return Padding(
      padding: EdgeInsets.only(top: size),
      child: this,
    );
  }

  Widget padBottom([double size = 8]) {
    return Padding(
      padding: EdgeInsets.only(bottom: size),
      child: this,
    );
  }

  Widget padSym({double vertical = 0, double horizontal = 0}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
      child: this,
    );
  }

  Widget opacityIf(bool Function() check, {double opacity = 0.5}) {
    if (check()) {
      return Opacity(opacity: opacity, child: this);
    }
    return this;
  }

  Widget wrapContainer({
    EdgeInsetsGeometry? padding,
    Color color = Colors.transparent,
    BoxDecoration? deco,
    BoxDecoration? decoFg,
    BoxConstraints? constraints,
  }) {
    return Container(
      padding: padding,
      color: deco == null ? color : null,
      decoration: deco,
      foregroundDecoration: decoFg,
      child: this,
    );
  }

  Widget wrapCircle({
    Color? bg,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    Clip clip = Clip.none,
    BoxBorder? border,
    BoxBorder? borderFg,
    double? width,
  }) {
    return Container(
      margin: margin,
      padding: padding,
      width: width,
      height: width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bg,
        border: border,
      ),
      foregroundDecoration: borderFg != null
          ? BoxDecoration(
              shape: BoxShape.circle,
              border: borderFg,
            )
          : null,
      clipBehavior: clip,
      child: this,
    );
  }

  Widget wrapExpanded({int flex = 1}) {
    return Expanded(flex: flex, child: this);
  }

  Widget wrapFlexible({int flex = 1}) {
    return Flexible(flex: flex, child: this);
  }

  Widget wrapColumn({
    MainAxisSize mainAxisSize = MainAxisSize.min,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    Iterable<Widget>? children,
  }) {
    return Column(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        this,
        if (children != null) ...children,
      ],
    );
  }

  Widget wrapRow({
    MainAxisSize mainAxisSize = MainAxisSize.min,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    Iterable<Widget>? children,
  }) {
    return Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        this,
        if (children != null) ...children,
      ],
    );
  }

  Widget sizded(double size, [double? height]) {
    return SizedBox(
      width: size,
      height: height ?? size,
      child: this,
    );
  }
}
