import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit/database/database.dart';
import 'package:habit/habit/domain/create_habit_dto.dart';
import 'package:habit/habit/domain/create_habit_usecase.dart';
import 'package:habit/habit/domain/get_habit_for_date_usecase.dart';

class HabitViewModel
    extends StateNotifier<AsyncValue<List<HabitWithCompletion>>> {
  final CreateHabitUseCase _createHabitUseCase;
  final GetHabitForDateUseCase _getHabitForDateUeCase;
  StreamSubscription<List<HabitWithCompletion>>? _streamSubscription;

  HabitViewModel({
    required CreateHabitUseCase createHabitUseCase,
    required GetHabitForDateUseCase getHabitForDateUecase,
  })  : _createHabitUseCase = createHabitUseCase,
        _getHabitForDateUeCase = getHabitForDateUecase,
        super(const AsyncValue.loading());

  Future<void> createHabit(CreateHabitDto dto) async {
    await _createHabitUseCase.execute(dto);
  }

  void watchHabitsForDate(DateTime date) {
    _streamSubscription?.cancel();
    state = const AsyncValue.loading();

    _streamSubscription = _getHabitForDateUeCase.execute(date).listen(
      (habits) {
        state = AsyncValue.data(habits);
      },
      onError: (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      },
    );
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}
