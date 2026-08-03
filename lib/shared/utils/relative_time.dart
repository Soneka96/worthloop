/// Formats [dateTime] relative to [now] (defaults to [DateTime.now]) as
/// "Today", "Yesterday", "N days ago", "Last week", or "N weeks ago".
///
/// Caps at weeks-ago granularity — callers only ever show this for
/// a handful of recently-opened items, so a multi-month-old entry never
/// reaches the screens that call this in practice.
String formatRelativeTime(DateTime dateTime, {DateTime? now}) {
  final DateTime today = now ?? DateTime.now();
  final int days = DateTime(
    today.year,
    today.month,
    today.day,
  ).difference(DateTime(dateTime.year, dateTime.month, dateTime.day)).inDays;

  if (days <= 0) {
    return 'Today';
  }
  if (days == 1) {
    return 'Yesterday';
  }
  if (days < 7) {
    return '$days days ago';
  }

  final int weeks = days ~/ 7;
  return weeks == 1 ? 'Last week' : '$weeks weeks ago';
}
