enum NotificationType { success, warning, error }

class NotificationItemModel {
  final String title;
  final String message;
  final NotificationType type;

  NotificationItemModel({
    required this.title,
    required this.message,
    required this.type,
  });
}
