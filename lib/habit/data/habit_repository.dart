import 'package:habit/database/database.dart';
import 'package:habit/habit/domain/create_habit_dto.dart';
import 'package:result_dart/result_dart.dart';

abstract class HabitRepository {
  AsyncResult<Unit> create(CreateHabitDto dto);
  Stream<List<HabitWithCompletion>> watchHabitsForDate(DateTime date);
}
