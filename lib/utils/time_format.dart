import 'package:intl/intl.dart';

final Function pluralize = (int count, String singular) {
  return count == 1 ? '$count $singular' : '$count ${singular}s';
};

class DateTimeUtils {
  static final _timeFormat = DateFormat('HH:mm');
  static final _weekdayFormat = DateFormat('EEE');
  static final _longDateFormat = DateFormat('EEEE d MMMM · HH:mm');

  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();

    // Normalize to calendar days
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final difference = now.difference(dateTime);
    final time = _timeFormat.format(dateTime);

    if (difference.inMinutes < 15) {
      if (difference.inSeconds < 60) {
        return 'Just now';
      }
      return "${pluralize(difference.inMinutes, 'minute')} ago";
    }

    // Calendar-relative labels
    if (date == today) {
      return 'Today · $time';
    }

    if (date == yesterday) {
      return 'Yesterday · $time';
    }

    if (today.difference(date).inDays < 7) {
      return '${_weekdayFormat.format(dateTime)} · $time';
    }

    // Long date fallback (your requirement)
    return _longDateFormat.format(dateTime);
  }
}
