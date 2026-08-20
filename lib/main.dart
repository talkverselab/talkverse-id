import 'package:flutter/material.dart';

import 'core/constants.dart';
import 'core/theme.dart';
import 'data/db/app_database.dart';
import 'data/db/seed_loader.dart';
import 'data/repositories/dialogue_repository.dart';
import 'data/repositories/root_repository.dart';
import 'screens/main_screen.dart';

late final AppDatabase appDb;
late final DialogueRepository dialogueRepo;
late final RootRepository rootRepo;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  appDb = AppDatabase();
  await SeedLoader(appDb).seedIfNeeded();
  dialogueRepo = DialogueRepository(appDb);
  rootRepo = RootRepository(appDb);
  await rootRepo.primeAffixUtil();
  runApp(const IndoUniverseApp());
}

class IndoUniverseApp extends StatelessWidget {
  const IndoUniverseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppInfo.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.light,
      home: const MainScreen(),
    );
  }
}
