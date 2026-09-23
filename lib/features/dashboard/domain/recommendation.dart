class Recommendation {
  final String id;
  final String title;
  final String description;
  final String? actionLabel;
  final String? actionUrl;
  final int priority;

  Recommendation({
    required this.id,
    required this.title,
    required this.description,
    this.actionLabel,
    this.actionUrl,
    required this.priority,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      actionLabel: json['action_label'],
      actionUrl: json['action_url'],
      priority: json['priority'],
    );
  }
}
