import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit/core/database/database.dart';

import 'package:habit/habit/views/habit_page.dart';
import 'package:habit/habit/views/providers/database_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  runApp(ProviderScope(
      overrides: [databaserProvider.overrideWithValue(database)],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habito',
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.shark),
      themeMode: ThemeMode.dark,
      home: const HabitPage(),
    );
  }
}
