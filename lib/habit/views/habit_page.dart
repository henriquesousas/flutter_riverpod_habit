import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit/core/extensions/date_extension.dart';
import 'package:habit/habit/views/components/daily_summary_card.dart';
import 'package:habit/habit/views/components/habit_card_list.dart';
import 'package:habit/habit/views/create_habit_page.dart';
import 'package:habit/habit/views/components/timeline_view.dart';
import 'package:habit/habit/views/providers/daily_summary_provider.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

class HabitPage extends ConsumerStatefulWidget {
  const HabitPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<HabitPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedDate = ref.watch(selectedDateProvider);

    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Hábito"))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TimelineView(
                seletedDate: selectedDate,
                onSelectedDateChanged: (date) =>
                    ref.read(selectedDateProvider.notifier).state = date,
              ),
              ref.watch(dailySummaryStreamProvider(selectedDate)).when(
                    data: (state) {
                      return DailySummaryCard(
                        completedTasks: state.$1,
                        totalTasks: state.$2,
                        date: selectedDate.toFormattedString('dd/MM/yyyy'),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Text(err.toString()),
                  ),
              const Text("Habitos"),
              HabitCardList(selectedDate: selectedDate),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.2),
              blurRadius: 16,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CreateHabitPage(),
              ));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: const Text("Create habit"),
            ),
          ),
        ),
      ),
    );
  }
}
