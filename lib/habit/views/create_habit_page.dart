import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit/habit/domain/dtos/create_habit_dto.dart';
import 'package:habit/habit/views/providers/view_model_providers.dart';

class CreateHabitPage extends ConsumerStatefulWidget {
  const CreateHabitPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateHabitPageState();
}

class _CreateHabitPageState extends ConsumerState<CreateHabitPage> {
  var isDaily = false;
  var hasReminder = false;
  var reminderTime = const TimeOfDay(hour: 10, minute: 0);
  var habitTitleController = TextEditingController();
  var habitDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final viewModel = ref.watch(habitViewModelProvider.notifier);

    Future<void> onPressed() async {
      final title = habitTitleController.text;
      final description = habitDescriptionController.text;

      if (title.isEmpty) return;
      if (description.isEmpty) return;

      final habit = CreateHabitDto(
          title: title,
          description: description,
          isDaily: isDaily,
          reminderTime: reminderTime.format(context));

      await viewModel.createHabit(habit);
      if (context.mounted) Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.chevron_left),
            ),
            Text(
              "Create Habit",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
        titleSpacing: 0,
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 24,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: habitTitleController,
              decoration: const InputDecoration(labelText: "habit title"),
            ),
            TextFormField(
              controller: habitDescriptionController,
              decoration: const InputDecoration(labelText: "habit description"),
            ),
            const Text("Goals"),
            Row(
              children: [
                const Text("Daily"),
                Switch(
                  value: isDaily,
                  onChanged: (value) {
                    setState(() {
                      isDaily = value;
                    });
                  },
                ),
              ],
            ),
            const Text("Reminder"),
            SwitchListTile(
              value: hasReminder,
              title: const Text("Has reminder"),
              subtitle: hasReminder ? Text(reminderTime.toString()) : null,
              onChanged: (value) {
                setState(
                  () {
                    hasReminder = value;
                    if (value) {
                      showTimePicker(
                        context: context,
                        initialTime: reminderTime,
                      ).then(
                        (time) {
                          if (time != null) {
                            reminderTime = time;
                          }
                        },
                      );
                    }
                  },
                );
              },
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                child: const Text("Create habit"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
//
