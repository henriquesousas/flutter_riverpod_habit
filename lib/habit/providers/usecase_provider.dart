import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit/habit/domain/create_habit_usecase.dart';
import 'package:habit/habit/domain/get_habit_for_date_usecase.dart';
import 'package:habit/habit/providers/repository_provider.dart';

final createHabitUseCaseProvider = Provider<CreateHabitUseCase>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return CreateHabitUseCase(repository: repository);
});

final getHabitForDateUseCaseProvider = Provider<GetHabitForDateUseCase>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return GetHabitForDateUseCase(repository: repository);
});
