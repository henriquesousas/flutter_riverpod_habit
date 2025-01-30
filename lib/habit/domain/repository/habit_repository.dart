import 'package:habit/core/database/database.dart';
import 'package:habit/habit/domain/dtos/create_habit_dto.dart';
import 'package:result_dart/result_dart.dart';

abstract class HabitRepository {
  AsyncResult<Unit> create(CreateHabitDto dto);
  AsyncResult<Unit> completedHabit(int habitId, DateTime selectedDate);
  Stream<List<HabitWithCompletion>> watchHabitsForDate(DateTime date);
  Stream<(int, int)> watchDailySummary(DateTime date);
}
