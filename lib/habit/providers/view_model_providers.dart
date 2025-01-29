import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit/database/database.dart';
import 'package:habit/habit/providers/usecase_provider.dart';
import 'package:habit/habit/viewmodels/habit_view_model.dart';

final habitViewModelProvider = StateNotifierProvider.autoDispose<HabitViewModel,
    AsyncValue<List<HabitWithCompletion>>>((ref) {
  final createHabitUseCase = ref.watch(createHabitUseCaseProvider);
  final getHabitForDateUseCase = ref.watch(getHabitForDateUseCaseProvider);
  return HabitViewModel(
    createHabitUseCase: createHabitUseCase,
    getHabitForDateUecase: getHabitForDateUseCase,
  );
});
