class NotificationPreferences {
  final bool emailEnabled;
  final bool pushEnabled;

  NotificationPreferences({
    required this.emailEnabled,
    required this.pushEnabled,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      emailEnabled: json['email_enabled'],
      pushEnabled: json['push_enabled'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email_enabled': emailEnabled,
      'push_enabled': pushEnabled,
    };
  }

  NotificationPreferences copyWith({
    bool? emailEnabled,
    bool? pushEnabled,
  }) {
    return NotificationPreferences(
      emailEnabled: emailEnabled ?? this.emailEnabled,
      pushEnabled: pushEnabled ?? this.pushEnabled,
    );
  }
}
