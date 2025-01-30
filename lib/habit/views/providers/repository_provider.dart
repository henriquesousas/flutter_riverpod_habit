import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit/habit/domain/repository/habit_repository.dart';
import 'package:habit/habit/data/drift_habit_repository.dart';
import 'package:habit/habit/views/providers/database_provider.dart';

final drifthabitRepositoryProvider = Provider<HabitRepository>((ref) {
  final databaseProvider = ref.watch(databaserProvider);
  return DrifHabitRepository(databaseProvider);
});
