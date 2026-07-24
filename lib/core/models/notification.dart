import 'dart:convert';

AppNotification notificationFromJson(String str) =>
    AppNotification.fromJson(json.decode(str) as Map<String, dynamic>);

String notificationToJson(AppNotification data) => json.encode(data.toJson());

class AppNotification {
  AppNotification({
    this.id,
    this.type,
    this.read,
    this.title,
    this.content,
    this.link,
    this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as int?,
      type: json['type'] as String?,
      read: json['read'] as int?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      link: json['link'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );
  }

  int? id;
  String? type;
  int? read;
  String? title;
  String? content;
  String? link;
  DateTime? createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'read': read,
        'title': title,
        'content': content,
        'link': link,
        'created_at': createdAt?.toIso8601String(),
      };
}
