import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/config/defaults.dart';
import 'package:prepbelt/core/config/review_config.dart';
import 'package:prepbelt/core/ids/ids.dart';
import 'package:prepbelt/core/time/clock.dart';
import 'package:prepbelt/core/time/hlc.dart';

void main() {
  final start = DateTime.utc(2026, 10, 28, 9);

  group('FakeClock', () {
    test('only moves when advanced', () {
      final clock = FakeClock(start);
      expect(clock.now(), start);
      clock.advance(const Duration(days: 1));
      expect(clock.now(), start.add(const Duration(days: 1)));
      expect(
        clock.nowMs(),
        start.add(const Duration(days: 1)).millisecondsSinceEpoch,
      );
    });
  });

  group('IdGenerator', () {
    test('makes UUIDv7 ids that embed the injected time and sort by it', () {
      final clock = FakeClock(start);
      final ids = IdGenerator(clock);
      final a = ids.next();
      clock.advance(const Duration(milliseconds: 5));
      final b = ids.next();
      expect(
        a,
        matches(
          RegExp(
            r'^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
          ),
        ),
      );
      final ms = int.parse(a.replaceAll('-', '').substring(0, 12), radix: 16);
      expect(ms, start.millisecondsSinceEpoch);
      expect(a.compareTo(b), lessThan(0));
    });
  });

  group('Hlc', () {
    test('stamps are monotonic even when the wall clock stalls', () {
      final clock = FakeClock(start);
      final hlc = Hlc(clock: clock, deviceId: 'dev1');
      final s1 = hlc.next();
      final s2 = hlc.next();
      clock.advance(const Duration(milliseconds: 1));
      final s3 = hlc.next();
      expect(s1.compareTo(s2), lessThan(0));
      expect(s2.compareTo(s3), lessThan(0));
      expect(s1, endsWith('-0000-dev1'));
      expect(s2, endsWith('-0001-dev1'));
    });

    test('receive moves past a remote stamp from the future', () {
      final clock = FakeClock(start);
      final hlc = Hlc(clock: clock, deviceId: 'a');
      final remote = Hlc.format(start.millisecondsSinceEpoch + 1000, 3, 'b');
      hlc.receive(remote);
      expect(hlc.next().compareTo(remote), greaterThan(0));
    });
  });

  group('ReviewConfig', () {
    test('defaults come from Defaults', () {
      const c = ReviewConfig();
      expect(c.scheduledReviews, Defaults.scheduledReviews);
      expect(c.gapWeights, [1, 2, 3, 5, 8]);
    });

    test('settings override defaults and bad values fall back', () {
      final c = ReviewConfig.fromSettings({
        SettingKeys.reviewGapWeights: [1, 1, 2, 3, 5],
        SettingKeys.scheduledReviews: 'oops',
      });
      expect(c.gapWeights, [1, 1, 2, 3, 5]);
      expect(c.scheduledReviews, Defaults.scheduledReviews);
    });
  });
}
