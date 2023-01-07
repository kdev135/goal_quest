class Goal {
  Goal({required this.title, required this.description, required this.actionPlan, this.reports, required this.creationDate, required this.dueDate});

  String title;
  String description;
  String actionPlan;
  List<Map<String, String>>? reports;
  DateTime creationDate;
  DateTime dueDate;
}
