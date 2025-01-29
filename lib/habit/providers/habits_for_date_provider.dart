import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit/database/database.dart';
import 'package:habit/habit/providers/database_provider.dart';

final habitsForDateProvider =
    StreamProvider.family<List<HabitWithCompletion>, DateTime>(
  (ref, date) {
    final database = ref.watch(databaserProvider);
    return database.watchHabitsForDate(date);
  },
);
