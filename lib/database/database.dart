import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:habit/database/tables.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Habits, HabitsCompletions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Habit>> getHabits() => select(habits).get();

  Stream<List<Habit>> watchHabits() => select(habits).watch();

  Future<int> createHabit(HabitsCompanion habit) => into(habits).insert(habit);

  Stream<List<HabitWithCompletion>> watchHabitsForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    final query = select(habits).join(
      [
        leftOuterJoin(
          habitsCompletions,
          habitsCompletions.habitId.equalsExp(habits.id) &
              habitsCompletions.completedAt.isBetweenValues(
                startOfDay,
                endOfDay,
              ),
        )
      ],
    );

    return query.watch().map((rows) {
      return rows.map((row) {
        final habit = row.readTable(habits);
        final completion = row.readTableOrNull(habitsCompletions);
        return HabitWithCompletion(
          habit: habit,
          isCompleted: completion != null,
        );
      }).toList();
    });
  }

  Future<void> completedHabits(int habitId, DateTime selectedDate) async {
    await transaction(
      () async {
        final startOfDay =
            DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

        final endOfDay = DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, 23, 59, 59, 999);

        final existingCompletion = await (select(habitsCompletions)
              ..where((tbl) =>
                  tbl.habitId.equals(habitId) &
                  tbl.completedAt
                      .isBetween(Variable(startOfDay), Variable(endOfDay))))
            .get();

        if (existingCompletion.isEmpty) {
          await into(habitsCompletions).insert(HabitsCompletionsCompanion(
            habitId: Value(habitId),
            completedAt: Value(selectedDate),
          ));

          final habit = await (select(habits)
                ..where((t) => t.id.equals(habitId)))
              .getSingle();

          await update(habits) //
              .replace(habit
                  .copyWith(
                      streak: habit.streak + 1,
                      totalCompletions: habit.totalCompletions + 1)
                  .toCompanion(true));
        }
      },
    );
  }

  Stream<(int, int)> watchDailySummary(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    final completionsStream = (select(habitsCompletions)
          ..where((t) => t.completedAt
              .isBetween(Variable(startOfDay), Variable(endOfDay))))
        .watch();

    final habitsStream = watchHabitsForDate(date);

    return Rx.combineLatest2(
      completionsStream,
      habitsStream,
      (completions, habits) => (completions.length, habits.length),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(
    () async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'habits.db'));
      return NativeDatabase.createInBackground(file);
    },
  );
}

class HabitWithCompletion {
  final Habit habit;
  final bool isCompleted;

  HabitWithCompletion({required this.habit, required this.isCompleted});
}
