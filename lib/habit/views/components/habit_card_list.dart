import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit/habit/providers/view_model_providers.dart';
import 'package:habit/habit/views/components/habit_card.dart';

class HabitCardList extends ConsumerStatefulWidget {
  final DateTime selectedDate;
  const HabitCardList({super.key, required this.selectedDate});

  @override
  ConsumerState<HabitCardList> createState() => _HabitCardListState();
}

class _HabitCardListState extends ConsumerState<HabitCardList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _watchHabitsForDate();
    });
  }

  @override
  void didUpdateWidget(HabitCardList oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (oldWidget.selectedDate != widget.selectedDate) {
        _watchHabitsForDate();
      }
    });
  }

  void _watchHabitsForDate() {
    ref
        .read(habitViewModelProvider.notifier)
        .watchHabitsForDate(widget.selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final habitsAsyncValue = ref.watch(habitViewModelProvider);

    return habitsAsyncValue.when(
        data: (habits) => Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemCount: habits.length,
                itemBuilder: (context, index) {
                  final habitWithCompletion = habits[index];
                  return HabitCard(
                    habitId: habitWithCompletion.habit.id,
                    title: habitWithCompletion.habit.title,
                    streak: habitWithCompletion.habit.streak,
                    progress: habitWithCompletion.isCompleted ? 1 : 0,
                    isCompleted: habitWithCompletion.isCompleted,
                    date: widget.selectedDate,
                  );
                },
              ),
            ),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}
