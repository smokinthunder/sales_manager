import 'package:sales_manager/domain/models/notification/notification_type.dart';

class AppNotification {
  final String id;
  final String senderId;
  final String receiverId;
  final String subject;
  final NotificationType notificationType;
  final Map<String, dynamic> relatedData;
  final bool isConfirmed;
  final String tenantId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String updatedBy;
  final String senderName;
  final String receiverName;

  const AppNotification({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.subject,
    required this.notificationType,
    required this.relatedData,
    required this.isConfirmed,
    required this.tenantId,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.senderName,
    required this.receiverName,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'].toString(),
      senderId: json['sender_id'].toString(),
      receiverId: json['receiver_id'].toString(),
      subject: json['subject'] ?? '',
      notificationType: NotificationType.fromString(json['notification_type']),
      relatedData: json['related_data'] ?? {},
      isConfirmed: json['is_confirmed'] ?? false,
      tenantId: json['tenant_id'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      createdBy: json['created_by'].toString(),
      updatedBy: json['updated_by'].toString(),
      senderName: json['sender_name'] ?? '',
      receiverName: json['receiver_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'subject': subject,
      'notification_type': notificationType.value,
      'related_data': relatedData,
      'is_confirmed': isConfirmed,
      'tenant_id': tenantId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'created_by': createdBy,
      'updated_by': updatedBy,
      'sender_name': senderName,
      'receiver_name': receiverName,
    };
  }

  AppNotification copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? subject,
    NotificationType? notificationType,
    Map<String, dynamic>? relatedData,
    bool? isConfirmed,
    String? tenantId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
    String? senderName,
    String? receiverName,
  }) {
    return AppNotification(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      subject: subject ?? this.subject,
      notificationType: notificationType ?? this.notificationType,
      relatedData: relatedData ?? this.relatedData,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      tenantId: tenantId ?? this.tenantId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      senderName: senderName ?? this.senderName,
      receiverName: receiverName ?? this.receiverName,
    );
  }

  /// Get formatted time for display (e.g., "02:06 PM")
  String get formattedTime {
    final hour = createdAt.hour;
    final minute = createdAt.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  /// Get a user-friendly subject line
  String get displaySubject {
    switch (notificationType) {
      case NotificationType.profileUpdate:
        return 'Profile Update Request';
      case NotificationType.customerCreation:
        return 'New Customer Request';
    }
  }

  /// Get profile image URL (placeholder for now)
  String get profileImageUrl {
    return "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZSUyMHBob3RvfGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60";
  }
}