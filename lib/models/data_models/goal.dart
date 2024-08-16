class Goal {
  final String title;
  final String description;
  final String actionPlan;
  final String creationDate;
  final String dueDate;
  final int timeSpan;
  final List<Map<String, String>> reports;

  Goal({
    required this.title,
    required this.description,
    required this.actionPlan,
    required this.creationDate,
    required this.dueDate,
    required this.timeSpan,
    required this.reports,
  });

  // Convert Goal object to a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'actionPlan': actionPlan,
      'creationDate': creationDate,
      'dueDate': dueDate,
      'timeSpan': timeSpan,
      'reports': reports,
    };
  }

  // Create a Goal object from a Map
  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      title: map['title'],
      description: map['description'],
      actionPlan: map['actionPlan'],
      creationDate: map['creationDate'],
      dueDate: map['dueDate'],
      timeSpan: map['timeSpan'],
      reports: List<Map<String, String>>.from(map['reports']),
    );
  }
}