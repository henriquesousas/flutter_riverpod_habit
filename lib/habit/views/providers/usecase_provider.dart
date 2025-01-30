import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit/habit/domain/usecases/complete_habit_usecase.dart';
import 'package:habit/habit/domain/usecases/create_habit_usecase.dart';
import 'package:habit/habit/domain/usecases/watch_habit_for_date_usecase.dart';
import 'package:habit/habit/domain/usecases/watch_daily_summary_usecase.dart';
import 'package:habit/habit/views/providers/repository_provider.dart';

final createHabitUseCaseProvider = Provider<CreateHabitUseCase>((ref) {
  final repository = ref.watch(drifthabitRepositoryProvider);
  return CreateHabitUseCase(repository: repository);
});

final getHabitForDateUseCaseProvider =
    Provider<WatchHabitForDateUseCase>((ref) {
  final repository = ref.watch(drifthabitRepositoryProvider);
  return WatchHabitForDateUseCase(repository: repository);
});

final watchDailySummaryUseCaseProvider =
    Provider<WatchDailySummaryUseCase>((ref) {
  final repository = ref.watch(drifthabitRepositoryProvider);
  return WatchDailySummaryUseCase(repository: repository);
});

final completeHabitUseCaseProvider = Provider<CompleteHabitUseCase>((ref) {
  final repository = ref.watch(drifthabitRepositoryProvider);
  return CompleteHabitUseCase(repository: repository);
});
