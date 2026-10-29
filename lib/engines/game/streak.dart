/// The streak (docs/02-data-model.md, "XP and streaks"): consecutive
/// calendar days with at least one review, counted back from [today]. A
/// day with no review yet today does not break it until the day is over,
/// so the count runs through yesterday. Rest tokens and planned breaks
/// arrive in 1.1.
///
/// [reviewDays] and [today] are local calendar days (time of day ignored).
int streakDays(Iterable<DateTime> reviewDays, DateTime today) {
  DateTime day(DateTime t) => DateTime.utc(t.year, t.month, t.day);
  final days = {for (final d in reviewDays) day(d)};
  var cursor = day(today);
  if (!days.contains(cursor)) {
    cursor = cursor.subtract(const Duration(days: 1));
  }
  var count = 0;
  while (days.contains(cursor)) {
    count++;
    cursor = cursor.subtract(const Duration(days: 1));
  }
  return count;
}
