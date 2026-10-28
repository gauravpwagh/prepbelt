import 'dart:math';

import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';

import '../time/clock.dart';

/// Generates UUIDv7 ids from an injected [Clock].
final class IdGenerator {
  IdGenerator(this._clock, {Random? random})
    : _random = random ?? Random.secure();

  final Clock _clock;
  final Random _random;
  static const _uuid = Uuid();

  String next() => _uuid.v7(
    config: V7Options(
      _clock.nowMs(),
      List<int>.generate(10, (_) => _random.nextInt(256)),
    ),
  );
}
