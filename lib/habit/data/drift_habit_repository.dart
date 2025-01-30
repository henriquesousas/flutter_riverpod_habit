import 'package:drift/drift.dart';
import 'package:habit/core/database/database.dart' as db;
import 'package:habit/habit/domain/repository/habit_repository.dart';
import 'package:habit/habit/domain/dtos/create_habit_dto.dart';
import 'package:result_dart/result_dart.dart';
import 'package:rxdart/rxdart.dart';

class DrifHabitRepository implements HabitRepository {
  final db.AppDatabase database;
  DrifHabitRepository(this.database);

  @override
  AsyncResult<Unit> create(CreateHabitDto dto) async {
    final habitCompanion = db.HabitsCompanion.insert(
      title: dto.title,
      description: dto.description,
      isDaily: Value(dto.isDaily),
      createdAt: Value(DateTime.now()),
      reminderTime: Value(dto.reminderTime),
    );

    await database.into(database.habits).insert(habitCompanion);
    return const Success(unit);
  }

  @override
  AsyncResult<Unit> completedHabit(int habitId, DateTime selectedDate) async {
    await database.transaction(
      () async {
        final startOfDay = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
        );

        final endOfDay = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          23,
          59,
          59,
          999,
        );

        final existingCompletion =
            await (database.select(database.habitsCompletions)
                  ..where((tbl) =>
                      tbl.habitId.equals(habitId) &
                      tbl.completedAt
                          .isBetween(Variable(startOfDay), Variable(endOfDay))))
                .get();

        if (existingCompletion.isEmpty) {
          await database
              .into(database.habitsCompletions)
              .insert(db.HabitsCompletionsCompanion(
                habitId: Value(habitId),
                completedAt: Value(selectedDate),
              ));

          final habit = await (database.select(database.habits)
                ..where((t) => t.id.equals(habitId)))
              .getSingle();

          await database
              .update(database.habits) //
              .replace(habit
                  .copyWith(
                      streak: habit.streak + 1,
                      totalCompletions: habit.totalCompletions + 1)
                  .toCompanion(true));
        }
      },
    );
    await Future.delayed(const Duration(seconds: 2));
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

  @override
  Stream<(int, int)> watchDailySummary(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    final completionsStream = (database.select(database.habitsCompletions)
          ..where((t) => t.completedAt
              .isBetween(Variable(startOfDay), Variable(endOfDay))))
        .watch();

    final habitsStream = watchHabitsForDate(date);

    return Rx.combineLatest2(
      completionsStream,
      habitsStream,
      (completions, habits) => (completions.length, habits.length),
    ).asyncMap((result) async {
      await Future.delayed(const Duration(milliseconds: 500));
      return result;
    });
  }
}
