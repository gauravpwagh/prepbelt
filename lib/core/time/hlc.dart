import 'clock.dart';

/// Hybrid logical clock stamps for the `hlc` column.
///
/// Format: `<13-digit ms>-<4-digit counter>-<deviceId>`, which sorts
/// lexicographically in causal order. Phase 1 only fills the column;
/// sync (phase 2) will also merge remote stamps through [receive].
final class Hlc {
  Hlc({required Clock clock, required this.deviceId}) : _clock = clock;

  final Clock _clock;
  final String deviceId;
  int _lastMs = 0;
  int _counter = 0;

  /// A new stamp for a local event.
  String next() {
    final wall = _clock.nowMs();
    if (wall > _lastMs) {
      _lastMs = wall;
      _counter = 0;
    } else {
      _counter++;
    }
    return format(_lastMs, _counter, deviceId);
  }

  /// Advances past a stamp seen from another device.
  void receive(String stamp) {
    final parts = stamp.split('-');
    final ms = int.parse(parts[0]);
    final counter = int.parse(parts[1]);
    final wall = _clock.nowMs();
    if (wall > _lastMs && wall > ms) {
      _lastMs = wall;
      _counter = 0;
    } else if (ms > _lastMs) {
      _lastMs = ms;
      _counter = counter + 1;
    } else if (ms == _lastMs) {
      _counter = (counter > _counter ? counter : _counter) + 1;
    } else {
      _counter++;
    }
  }

  static String format(int ms, int counter, String deviceId) =>
      '${ms.toString().padLeft(13, '0')}-'
      '${counter.toString().padLeft(4, '0')}-$deviceId';
}
