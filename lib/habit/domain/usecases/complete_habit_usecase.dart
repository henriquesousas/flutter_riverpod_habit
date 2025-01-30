import 'package:habit/habit/domain/repository/habit_repository.dart';
import 'package:result_dart/result_dart.dart';

class CompleteHabitUseCase {
  final HabitRepository _repository;

  CompleteHabitUseCase({required HabitRepository repository})
      : _repository = repository;

  AsyncResult<Unit> execute(int habitId, DateTime date) async {
    return _repository.completedHabit(habitId, date);
  }
}
