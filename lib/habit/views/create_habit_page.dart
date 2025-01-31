import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit/core/extensions/date_extension.dart';
import 'package:habit/core/ui/components/primary_button.dart';
import 'package:habit/core/ui/components/primary_text_field.dart';
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
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;
    final viewModel = ref.watch(habitViewModelProvider.notifier);

    Future<void> onPressed() async {
      final title = titleController.text;
      final description = descriptionController.text;

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
              onPressed: () => Navigator.pop(context),
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Titulo", style: Theme.of(context).textTheme.labelLarge),
              PrimaryTextField(
                controller: titleController,
                hintText: "titulo hábito...",
              ),
              Text("Descricao", style: Theme.of(context).textTheme.labelLarge),
              PrimaryTextField(
                controller: descriptionController,
                hintText: "descrição do hábito...",
                maxLine: 4,
              ),
              SwitchListTile(
                contentPadding: const EdgeInsets.only(left: 5),
                secondary: const Icon(Icons.timer_outlined),
                value: hasReminder,
                title: Text(
                  "Lembrete",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle:
                    hasReminder ? Text(reminderTime.toFormattedString()) : null,
                onChanged: (isSelected) {
                  if (!isSelected) {
                    setState(() {
                      hasReminder = isSelected;
                    });
                  }

                  if (isSelected) {
                    showTimePicker(
                      context: context,
                      initialTime: reminderTime,
                    ).then(
                      (time) {
                        setState(() {
                          if (time != null) {
                            hasReminder = isSelected;
                            reminderTime = time;
                          }
                        });
                      },
                    );
                  }
                },
              ),
              PrimaryButton(onPressed: onPressed),
              const SizedBox(height: 5),
              Visibility(
                visible: hasReminder,
                child: Text(
                  "Com o lembrete ativado, não se preocupe que lembraremos a você quando chegar a hora.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.grey.shade500,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
