class NotificationException implements Exception {
  final String message;

  NotificationException(this.message);

  @override
  String toString() => "NotificationException: $message";
}


class NotificationPluginException extends NotificationException {
  NotificationPluginException(super.message);

  @override
  String toString() => "NotificationPluginException: $message";
}

class NotificationPermissionException extends NotificationException {
  NotificationPermissionException(super.message);

  @override
  String toString() => "NotificationPermissionException: $message";
}

class NotificationNotFoundException extends NotificationException {
  NotificationNotFoundException(super.message);

  @override
  String toString() => "NotificationNotFoundException: $message";
}
