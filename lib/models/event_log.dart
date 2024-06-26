import 'package:intl/intl.dart';

class EventLog {
  int eventId;
  DateTime eventDateTime;
  String situation;
  String userId;

  EventLog({
    required this.eventId,
    required this.eventDateTime,
    required this.situation,
    required this.userId,
  });

  EventLog.fromJson(dynamic json)
      : eventId = json['event_id'],
        eventDateTime =
            DateFormat('yyyy.MM.DD HH:mm:ss').parse(json['event_date']),
        situation = json['situation'],
        userId = json['user_id'];
}
