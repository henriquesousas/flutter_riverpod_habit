class Habit {
  final int id;
  final String title;
  final String description;
  final String? reminderTime;
  final DateTime createdAt;
  final int streak;
  final int totalCompletions;
  final bool isDaily;

  Habit(
      {required this.id,
      required this.title,
      required this.description,
      required this.reminderTime,
      required this.createdAt,
      required this.streak,
      required this.totalCompletions,
      required this.isDaily});
}
