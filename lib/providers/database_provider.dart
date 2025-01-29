import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit/database/database.dart';

//It will filled in main.dart by overriding of ProviderScope from riverpod
final databaserProvider = Provider<AppDatabase>(
  (ref) {
    throw UnimplementedError('database not implemented yet...');
    // return AppDatabase();
  },
);
