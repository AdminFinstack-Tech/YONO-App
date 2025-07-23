import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  @JsonKey(name: 'notification_id')
  final String notificationId;
  
  final String title;
  
  final String message;
  
  @JsonKey(name: 'notification_type')
  final String notificationType;
  
  final String? category;
  
  @JsonKey(name: 'is_read')
  final bool isRead;
  
  @JsonKey(name: 'is_important')
  final bool isImportant;
  
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  
  @JsonKey(name: 'read_at')
  final DateTime? readAt;
  
  @JsonKey(name: 'action_type')
  final String? actionType;
  
  @JsonKey(name: 'action_data')
  final Map<String, dynamic>? actionData;
  
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;

  NotificationModel({
    required this.notificationId,
    required this.title,
    required this.message,
    required this.notificationType,
    this.category,
    this.isRead = false,
    this.isImportant = false,
    required this.createdAt,
    this.readAt,
    this.actionType,
    this.actionData,
    this.imageUrl,
    this.expiresAt,
  });

  bool get isExpired => expiresAt != null && expiresAt!.isBefore(DateTime.now());
  
  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  NotificationModel copyWith({
    String? notificationId,
    String? title,
    String? message,
    String? notificationType,
    String? category,
    bool? isRead,
    bool? isImportant,
    DateTime? createdAt,
    DateTime? readAt,
    String? actionType,
    Map<String, dynamic>? actionData,
    String? imageUrl,
    DateTime? expiresAt,
  }) {
    return NotificationModel(
      notificationId: notificationId ?? this.notificationId,
      title: title ?? this.title,
      message: message ?? this.message,
      notificationType: notificationType ?? this.notificationType,
      category: category ?? this.category,
      isRead: isRead ?? this.isRead,
      isImportant: isImportant ?? this.isImportant,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      actionType: actionType ?? this.actionType,
      actionData: actionData ?? this.actionData,
      imageUrl: imageUrl ?? this.imageUrl,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}