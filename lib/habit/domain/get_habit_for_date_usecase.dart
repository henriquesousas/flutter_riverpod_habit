import 'package:habit/database/database.dart';
import 'package:habit/habit/data/habit_repository.dart';

class GetHabitForDateUseCase {
  final HabitRepository _repository;

  GetHabitForDateUseCase({required HabitRepository repository})
      : _repository = repository;

  Stream<List<HabitWithCompletion>> execute(DateTime date) {
    return _repository.watchHabitsForDate(date);
  }
}
