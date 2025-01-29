import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit/providers/database_provider.dart';

final dailySummaryProvider =
    StreamProvider.family<(int completedTaks, int totalTasks), DateTime>(
  (ref, date) {
    final database = ref.watch(databaserProvider);
    return database.watchDailySummary(date);
  },
);
