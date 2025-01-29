import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit/habit/data/habit_repository.dart';
import 'package:habit/habit/data/local_drift_habit_repository.dart';
import 'package:habit/habit/providers/database_provider.dart';

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  final databaseProvider = ref.watch(databaserProvider);
  return LocalDriftHabitRepository(databaseProvider);
});
