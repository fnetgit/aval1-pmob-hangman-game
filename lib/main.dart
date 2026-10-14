import 'package:flutter/material.dart';

import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/answer_repository_impl.dart';
import 'presentation/controllers/game_instance.dart';
import 'presentation/controllers/game_notifier.dart';
import 'presentation/screens/developers_screen.dart';
import 'presentation/screens/game_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/stats_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final repository = AnswerRepositoryImpl();
  await repository.loadEntries();

  gameNotifier = GameNotifier(repository);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jogo da Forca',
      theme: AppTheme.theme,
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.game: (_) => const GameScreen(),
        AppRoutes.stats: (_) => const StatsScreen(),
        AppRoutes.developers: (_) => const DevelopersScreen(),
      },
    ),
  );
}
