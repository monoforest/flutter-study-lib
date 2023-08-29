import 'dart:async';

Future<void> waitUntil(bool Function() condition, {int delayMs = 50}) async {
  if (condition() == true) return;

  await Future.doWhile(() async {
    await Future.delayed(Duration(milliseconds: delayMs));
    return !condition();
  });
}

Future<void> waitUntilAsync(Future<bool> Function() condition,
    {int delayMs = 50}) async {
  if (await condition() == true) return;

  await Future.doWhile(() async {
    await Future.delayed(Duration(milliseconds: delayMs));
    return !(await condition());
  });
}

Future<T> delayZero<T>([FutureOr<T> Function()? computation]) async {
  return await Future.delayed(Duration.zero, computation);
}

Future<T> delayMsec<T>(
    {int msec = 100, FutureOr<T> Function()? computation}) async {
  return await Future.delayed(
    Duration(milliseconds: msec),
    computation,
  );
}

Future<T> delay<T>(
    [Duration duration = const Duration(milliseconds: 50),
    FutureOr<T> Function()? computation]) async {
  return await Future.delayed(duration, computation);
}
