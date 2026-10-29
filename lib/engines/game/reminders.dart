/// When to send the daily reminder: at [minuteOfDay] (local) on each of
/// the next [days] days, starting today unless today's reminder time has
/// passed or the student already reviewed today. Times are local wall-clock
/// [DateTime]s; the platform layer turns them into zoned times.
List<DateTime> reminderTimes({
  required DateTime nowLocal,
  required int minuteOfDay,
  required bool reviewedToday,
  required int days,
}) {
  final out = <DateTime>[];
  for (var d = 0; out.length < days; d++) {
    final at = DateTime(
      nowLocal.year,
      nowLocal.month,
      nowLocal.day + d,
      minuteOfDay ~/ 60,
      minuteOfDay % 60,
    );
    if (d == 0 && (reviewedToday || !at.isAfter(nowLocal))) continue;
    out.add(at);
  }
  return out;
}
