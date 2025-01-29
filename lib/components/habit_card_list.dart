import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit/components/habit_card.dart';
import 'package:habit/providers/habits_for_date_provider.dart';

class HabitCardList extends ConsumerWidget {
  final DateTime selectedDate;
  const HabitCardList({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsyncValue = ref.watch(habitsForDateProvider(selectedDate));

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
                    date: selectedDate,
                  );
                },
              ),
            ),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}
