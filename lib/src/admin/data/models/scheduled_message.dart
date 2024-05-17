// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ScheduledEmail {
  final int id;
  final String senderName;
  final String receiverName;
  final String receiverEmail;
  final String senderEmail;
  final String message;
  final DateTime scheduledTime;
  final bool isSent;

  ScheduledEmail({
    required this.id,
    required this.senderName,
    required this.receiverName,
    required this.receiverEmail,
    required this.senderEmail,
    required this.message,
    required this.scheduledTime,
    this.isSent = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'senderName': senderName,
      'receiverName': receiverName,
      'receiverEmail': receiverEmail,
      'senderEmail': senderEmail,
      'message': message,
      'scheduledTime': scheduledTime.millisecondsSinceEpoch,
      'isSent': isSent,
    };
  }

  static ScheduledEmail fromMap(Map<String, dynamic> map) {
    return ScheduledEmail(
      id: map['id'],
      senderName: map['senderName'],
      receiverName: map['receiverName'],
      receiverEmail: map['receiverEmail'],
      senderEmail: map['senderEmail'],
      message: map['message'],
      scheduledTime: DateTime.parse(map['scheduledTime']),
      isSent: map['isSent'] == 1,
    );
  }

  ScheduledEmail copyWith({
    int? id,
    String? senderName,
    String? receiverName,
    String? receiverEmail,
    String? senderEmail,
    String? message,
    DateTime? scheduledTime,
    bool? isSent,
  }) {
    return ScheduledEmail(
      id: id ?? this.id,
      senderName: senderName ?? this.senderName,
      receiverName: receiverName ?? this.receiverName,
      receiverEmail: receiverEmail ?? this.receiverEmail,
      senderEmail: senderEmail ?? this.senderEmail,
      message: message ?? this.message,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      isSent: isSent ?? this.isSent,
    );
  }

  

  String toJson() => json.encode(toMap());

  factory ScheduledEmail.fromJson(String source) => ScheduledEmail.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ScheduledEmail(id: $id, senderName: $senderName, receiverName: $receiverName, receiverEmail: $receiverEmail, senderEmail: $senderEmail, message: $message, scheduledTime: $scheduledTime, isSent: $isSent)';
  }

  @override
  bool operator ==(covariant ScheduledEmail other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.senderName == senderName &&
      other.receiverName == receiverName &&
      other.receiverEmail == receiverEmail &&
      other.senderEmail == senderEmail &&
      other.message == message &&
      other.scheduledTime == scheduledTime &&
      other.isSent == isSent;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      senderName.hashCode ^
      receiverName.hashCode ^
      receiverEmail.hashCode ^
      senderEmail.hashCode ^
      message.hashCode ^
      scheduledTime.hashCode ^
      isSent.hashCode;
  }
}
