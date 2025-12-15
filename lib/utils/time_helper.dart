import 'package:timeago/timeago.dart' as timeago;

String timeAgo(DateTime createdAt) {
  return timeago.format(createdAt, locale: 'id');
}
