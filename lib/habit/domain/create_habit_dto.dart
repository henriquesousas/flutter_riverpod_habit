class CreateHabitDto {
  final String title;
  final String description;
  final String? reminderTime;
  final bool isDaily;

  CreateHabitDto(
      {required this.title,
      required this.description,
      required this.reminderTime,
      required this.isDaily});
}
