import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit/habit/views/providers/usecase_provider.dart';

// final dailySummaryProvider =
//     StreamProvider.family<(int completedTaks, int totalTasks), DateTime>(
//   (ref, date) {
//     final database = ref.watch(databaserProvider);
//     return database.watchDailySummary(date);
//   },
// );

final dailySummaryStreamProvider = StreamProvider.family<(int, int), DateTime>(
  (ref, date) {
    final watchDailySummaryUseCase =
        ref.watch(watchDailySummaryUseCaseProvider);
    return watchDailySummaryUseCase.execute(date);
  },
);
