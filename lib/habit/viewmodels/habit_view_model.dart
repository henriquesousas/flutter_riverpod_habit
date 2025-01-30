import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit/core/database/database.dart';
import 'package:habit/habit/domain/usecases/complete_habit_usecase.dart';
import 'package:habit/habit/domain/dtos/create_habit_dto.dart';
import 'package:habit/habit/domain/usecases/create_habit_usecase.dart';
import 'package:habit/habit/domain/usecases/watch_habit_for_date_usecase.dart';

// sealed class HabitState {}
// class HabitData extends HabitState {
//   final List<HabitWithCompletion> habits;
//   HabitData(this.habits);
// }

class HabitState {
  final List<HabitWithCompletion>? habits;
  final (int, int)? summary;

  HabitState({this.habits, this.summary});

  bool get isLoading => habits == null && summary == null;
  bool get hasHabits => habits != null;
  bool get hasSummary => summary != null;
}

class HabitViewModel extends StateNotifier<AsyncValue<HabitState>> {
  final CreateHabitUseCase _createHabitUseCase;
  final WatchHabitForDateUseCase _getHabitForDateUeCase;
  final CompleteHabitUseCase _completeHabitUseCase;
  StreamSubscription<List<HabitWithCompletion>>? _streamSubscription;

  HabitViewModel({
    required CreateHabitUseCase createHabitUseCase,
    required WatchHabitForDateUseCase getHabitForDateUecase,
    required CompleteHabitUseCase completeHabitUseCase,
  })  : _createHabitUseCase = createHabitUseCase,
        _getHabitForDateUeCase = getHabitForDateUecase,
        _completeHabitUseCase = completeHabitUseCase,
        super(const AsyncValue.loading());

  Future<void> createHabit(CreateHabitDto dto) async {
    await _createHabitUseCase.execute(dto);
  }

  void watchHabitsForDate(DateTime date) {
    _streamSubscription?.cancel();
    state = const AsyncValue.loading();
    _streamSubscription = _getHabitForDateUeCase.execute(date).listen(
      (habits) {
        state = AsyncValue.data(HabitState(
          summary: state.value?.summary,
          habits: habits,
        ));
      },
      onError: (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      },
    );
  }

  void completedHabit(int habitId, DateTime selectedDate) async {
    await _completeHabitUseCase.execute(habitId, selectedDate);
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}
