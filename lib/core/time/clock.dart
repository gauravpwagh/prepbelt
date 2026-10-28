/// The only place in the app that reads the wall clock.
///
/// Everything else takes a [Clock] (or a `now` parameter) so tests can
/// control time. Times are UTC; storage uses UTC milliseconds.
abstract interface class Clock {
  /// Current time in UTC.
  DateTime now();
}

extension ClockMillis on Clock {
  /// Current time as UTC milliseconds since the epoch.
  int nowMs() => now().millisecondsSinceEpoch;
}

/// The real wall clock.
final class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now().toUtc();
}

/// A clock that only moves when told to. For tests and debug tools.
final class FakeClock implements Clock {
  FakeClock(DateTime start) : _now = start.toUtc();

  DateTime _now;

  @override
  DateTime now() => _now;

  void set(DateTime value) => _now = value.toUtc();

  void advance(Duration by) => _now = _now.add(by);
}

/// Converts stored UTC milliseconds to a UTC [DateTime].
DateTime fromUtcMs(int ms) =>
    DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
