import 'package:habit/core/database/database.dart';
import 'package:habit/habit/domain/repository/habit_repository.dart';

class WatchHabitForDateUseCase {
  final HabitRepository _repository;

  WatchHabitForDateUseCase({required HabitRepository repository})
      : _repository = repository;

  Stream<List<HabitWithCompletion>> execute(DateTime date) {
    return _repository.watchHabitsForDate(date);
  }
}
