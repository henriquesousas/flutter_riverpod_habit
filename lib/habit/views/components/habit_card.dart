import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit/habit/providers/database_provider.dart';

class HabitCard extends ConsumerWidget {
  final int habitId;
  final String title;
  final int streak;
  final double progress;
  final bool isCompleted;
  final DateTime date;

  const HabitCard({
    super.key,
    required this.habitId,
    required this.title,
    required this.streak,
    required this.progress,
    required this.isCompleted,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    Future<void> onComplete() async {
      await ref.read(databaserProvider).completedHabits(habitId, date);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Habit completed'),
          behavior: SnackBarBehavior.floating,
        ));
      }
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
        gradient: LinearGradient(
          colors: [
            isCompleted
                ? colorScheme.primaryContainer.withValues(alpha: 0.8)
                : colorScheme.surface.withValues(alpha: 0.1),
            isCompleted
                ? colorScheme.primaryContainer.withValues(alpha: 0.6)
                : colorScheme.surface.withValues(alpha: 0.05)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: colorScheme.shadow, blurRadius: 16),
        ],
      ),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (streak > 0) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                          Text('$streak days'),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: isCompleted
                        ? LinearGradient(
                            colors: [
                              colorScheme.primary,
                              colorScheme.secondary
                            ],
                          )
                        : null,
                    color: isCompleted
                        ? colorScheme.surfaceContainerHighest
                        : null),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onComplete,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        isCompleted
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: isCompleted
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ),
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
