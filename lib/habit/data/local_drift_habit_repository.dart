import 'package:drift/drift.dart';
import 'package:habit/database/database.dart' as db;
import 'package:habit/habit/data/habit_repository.dart';
import 'package:habit/habit/domain/create_habit_dto.dart';
import 'package:result_dart/result_dart.dart';

class LocalDriftHabitRepository implements HabitRepository {
  final db.AppDatabase database;
  LocalDriftHabitRepository(this.database);

  @override
  AsyncResult<Unit> create(CreateHabitDto dto) async {
    final habitCompanion = db.HabitsCompanion.insert(
      title: dto.title,
      description: dto.description,
      isDaily: Value(dto.isDaily),
      createdAt: Value(DateTime.now()),
      reminderTime: Value(dto.reminderTime),
    );

    await database.createHabit(habitCompanion);
    return const Success(unit);
  }

  @override
  Stream<List<db.HabitWithCompletion>> watchHabitsForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    final query = database.select(database.habits).join(
      [
        leftOuterJoin(
          database.habitsCompletions,
          database.habitsCompletions.habitId.equalsExp(database.habits.id) &
              database.habitsCompletions.completedAt.isBetweenValues(
                startOfDay,
                endOfDay,
              ),
        )
      ],
    );

    return query.watch().map((rows) {
      return rows.map((row) {
        final habit = row.readTable(database.habits);
        final completion = row.readTableOrNull(database.habitsCompletions);
        return db.HabitWithCompletion(
          habit: habit,
          isCompleted: completion != null,
        );
      }).toList();
    });
  }
}
