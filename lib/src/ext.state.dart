import 'package:flutter/material.dart';
import 'package:lib/src/util.future.dart';

extension FoomumuStateExtension on State {
  void safeSetState(void Function() fn) {
    if (mounted) {
      try {
        // ignore: invalid_use_of_protected_member
        setState(fn);
      } catch (e) {}
    }
  }

  Future<void> nextFrame() async {
    if (!mounted) return;

    // 'nextFrame wait'.dlog();
    bool isOk = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isOk = true;
    });
    safeSetState(() {});
    await waitUntil(() => isOk);
    // 'nextFrame wait finished'.dlog();
  }
}
