import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit/habit/views/providers/usecase_provider.dart';
import 'package:habit/habit/viewmodels/habit_view_model.dart';

final habitViewModelProvider =
    StateNotifierProvider.autoDispose<HabitViewModel, AsyncValue<HabitState>>(
        (ref) {
  final createHabitUseCase = ref.watch(createHabitUseCaseProvider);
  final getHabitForDateUseCase = ref.watch(getHabitForDateUseCaseProvider);
  final completeHabitUseCase = ref.watch(completeHabitUseCaseProvider);
  return HabitViewModel(
      createHabitUseCase: createHabitUseCase,
      getHabitForDateUecase: getHabitForDateUseCase,
      completeHabitUseCase: completeHabitUseCase);
});
