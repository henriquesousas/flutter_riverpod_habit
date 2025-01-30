import 'package:habit/habit/domain/repository/habit_repository.dart';

class WatchDailySummaryUseCase {
  final HabitRepository _repository;

  WatchDailySummaryUseCase({required HabitRepository repository})
      : _repository = repository;

  Stream<(int, int)> execute(DateTime date) {
    return _repository.watchDailySummary(date);
  }
}
